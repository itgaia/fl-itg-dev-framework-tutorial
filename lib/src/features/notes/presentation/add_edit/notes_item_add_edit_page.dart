import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../../../common/itg_localization.dart';
import '../../data/notes_model.dart';
import '../../domain/notes_helper.dart';
import '../../domain/save_notes_item_usecase.dart';
import '../main/bloc/notes_bloc.dart';
import 'bloc/notes_item_add_edit_bloc.dart';
import 'notes_item_add_edit_view.dart';

enum ItemAddEditAction { add, edit, duplicate }

String titleFromAction({required String baseTitle, required ItemAddEditAction action}) {
  switch (action) {
    case ItemAddEditAction.add:
      return '${ItgLocalization.tr("New")} ${ItgLocalization.tr(baseTitle)}';
    case ItemAddEditAction.edit:
      return '${ItgLocalization.tr("Edit")} ${ItgLocalization.tr(baseTitle)}';
    case ItemAddEditAction.duplicate:
      return '${ItgLocalization.tr("Duplicate")} ${ItgLocalization.tr(baseTitle)}';
  }
}

class NotesItemAddEditPage extends StatelessWidget {
  static const routeName = '/notes_item_add_edit';

  static Route<void> route({required ItemAddEditAction action, NotesModel? initialData, NotesBloc? blocItems}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => NotesItemAddEditBloc(
              saveNotesItemUsecase: sl<SaveNotesItemUsecase>(),
              initialData: initialData,
            ),
          ),
          if (blocItems != null)
            BlocProvider<NotesBloc>.value(value: blocItems)
        ],
        child: NotesItemAddEditPage(action: action),
      ),
    );
  }

  final ItemAddEditAction action;

  const NotesItemAddEditPage({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[NotesItemAddEditPage.build]';
    final String title = titleFromAction(baseTitle: appTitleNotesItem, action: action);
    itgLogVerbose('$baseLogMsg action: $action, title: $title');
    return MultiBlocListener(
      listeners: [
        BlocListener<NotesItemAddEditBloc, NotesItemAddEditState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == NotesItemAddEditStatus.success,
          listener: (context, state) {
            itgLogPrint('[NotesItemAddEditPage/listener/success] Item saved...');
            showNotificationSuccess(context: context, msg: 'Item saved...');
            Navigator.of(context).pop();
          },
        ),
        BlocListener<NotesItemAddEditBloc, NotesItemAddEditState>(
          listenWhen: (previous, current) => current.status == NotesItemAddEditStatus.failure,
          listener: (context, state) => showNotificationFailure(context: context, msg: 'Fail to save item!'),
        )
      ],
      child: NotesItemAddEditView(title: title),
    );
  }
}
