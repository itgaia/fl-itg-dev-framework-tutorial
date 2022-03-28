import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../../../common/itg_localization.dart';
import '../../data/links_model.dart';
import '../../domain/links_helper.dart';
import '../../domain/save_links_item_usecase.dart';
import '../main/bloc/links_bloc.dart';
import 'bloc/links_item_add_edit_bloc.dart';
import 'links_item_add_edit_view.dart';

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

class LinksItemAddEditPage extends StatelessWidget {
  static const routeName = '/links_item_add_edit';

  static Route<void> route({required ItemAddEditAction action, LinksModel? initialData, LinksBloc? blocItems}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LinksItemAddEditBloc(
              saveLinksItemUsecase: sl<SaveLinksItemUsecase>(),
              initialData: initialData,
            ),
          ),
          if (blocItems != null)
            BlocProvider<LinksBloc>.value(value: blocItems)
        ],
        child: LinksItemAddEditPage(action: action),
      ),
    );
  }

  final ItemAddEditAction action;

  const LinksItemAddEditPage({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[LinksItemAddEditPage.build]';
    final String title = titleFromAction(baseTitle: appTitleLinksItem, action: action);
    itgLogVerbose('$baseLogMsg action: $action, title: $title');
    return MultiBlocListener(
      listeners: [
        BlocListener<LinksItemAddEditBloc, LinksItemAddEditState>(
          listenWhen: (previous, current) =>
            previous.status != current.status &&
            current.status == LinksItemAddEditStatus.success,
          listener: (context, state) {
            itgLogPrint('[LinksItemAddEditPage/listener/success] Item saved...');
            showNotificationSuccess(context: context, msg: 'Item saved...');
            Navigator.of(context).pop();
          },
        ),
        BlocListener<LinksItemAddEditBloc, LinksItemAddEditState>(
          listenWhen: (previous, current) => current.status == LinksItemAddEditStatus.failure,
          listener: (context, state) => showNotificationFailure(context: context, msg: 'Fail to save item!'),
        )
      ],
      child: LinksItemAddEditView(title: title),
    );
  }
}
