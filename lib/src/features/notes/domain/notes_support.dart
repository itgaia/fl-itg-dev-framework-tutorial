
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/constants.dart';
import '../../../app/injection_container.dart';
import '../../../common/helper.dart';
import '../../../common/itg_localization.dart';
import '../../../core/support/support_base.dart';
import '../presentation/add_edit/notes_item_add_edit_page.dart';
import '../presentation/main/bloc/notes_bloc.dart';
import '../presentation/show/notes_item_show_page.dart';
import 'delete_notes_item_usecase.dart';

class NotesSupport extends SupportBase {
  @override
  String get titleSingular => 'Note';
  @override
  String get titlePlural => 'Notes';
  @override
  bool get allowRefresh => true;
  @override
  bool get allowEdit => true;
  @override
  bool get allowDuplicate => true;
  @override
  bool get allowAdd => true;
  @override
  bool get allowDelete => true;

  @override
  Future<dynamic> actionItemShow({required BuildContext context, required dynamic data}) async {
    itgLogVerbose('[NotesSupport.actionItemShow] ...');
    final ret = await Navigator.push(
        context,
        NotesItemShowPage.route(title: ItgLocalization.tr('NotesItem'), data: data,
          blocItems: context.read<NotesBloc>())
    );
    return ret;
  }

  @override
  Future<dynamic> actionItemEdit({required BuildContext context, required dynamic data}) async {
    const String baseLogMsg = '[NotesSupport.actionItemEdit]';
    itgLogVerbose('$baseLogMsg ...');
    // final ret = await Navigator.of(context).push(NotesItemAddEditPage.route(action: ItemAddEditAction.edit, initialData: data));
    final ret = await Navigator.push(
      context,
      NotesItemAddEditPage.route(action: ItemAddEditAction.edit, initialData: data)
    );
    itgLogVerbose('$baseLogMsg context: $context');
    context.read<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    // // final bloc = context.read<NotesBloc>();
    // final bloc = BlocProvider.of<NotesBloc>(context);
    // itgLogVerbose('>>> bloc: $bloc');
    // if (bloc is NotesBloc) {
    //   itgLogVerbose('>>> before add event in bloc...');
    //   bloc.add(const NotesSubscriptionRequestedEvent());
    // } else {
    //   itgLogError('$baseLogMsg Error: it was not possible to find the bloc in the context: $context');
    // }

    // TODO: Why it is not the same if I use the sl<>()?
    // itgLogVerbose('>>> BlocProvider.of: ${BlocProvider.of<NotesBloc>(context)}');
    // final bloc = context.read<NotesBloc>();
    // itgLogVerbose('>>> bloc: $bloc');
    // if (bloc is NotesBloc) {
    //   bloc.add(const NotesSubscriptionRequestedEvent());
    // } else {
    //   itgLogError('$baseLogMsg Error: it was not possible to find the bloc in the context: $context');
    // }
    // itgLogVerbose('>>> context.read<NotesBloc>(): ${context.read<NotesBloc>()}\n====================');
    // itgLogVerbose('>>> sl<NotesBloc>(): ${sl<NotesBloc>()}\n====================');
    // itgLogVerbose('>>> check equal: ${sl<NotesBloc>() == context.read<NotesBloc>()}');
    // // sl<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    // itgLogVerbose('$baseLogMsg result: $ret');
    return ret;
  }

  @override
  Future<dynamic> actionItemDuplicate({required BuildContext context, required data}) async {
    itgLogVerbose('[NotesSupport.actionItemDuplicate] ...');
    final ret = await Navigator.of(context).push(NotesItemAddEditPage.route(action: ItemAddEditAction.duplicate, initialData: data.copyWith(id: null, description: '${data.description}$textTitleSuffixDuplicate')));
    context.read<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    // sl<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    return ret;
  }

  @override
  Future<dynamic> actionItemAdd({required BuildContext context, dynamic data}) async {
    itgLogVerbose('[NotesSupport.actionItemAdd] ...');
    final ret =  await Navigator.of(context).push(NotesItemAddEditPage.route(action: ItemAddEditAction.add));
    itgLogVerbose('[NotesSupport.actionItemAdd] return from AddEditPage. Submit a NotesSubscriptionRequestedEvent...');
    context.read<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    // sl<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    return ret;
  }

  @override
  Future<dynamic> actionItemDelete({required BuildContext context, required data}) async {
    const String baseLogMsg = '[NotesSupport.actionItemDelete]';
    itgLogVerbose('$baseLogMsg start...');
    if (await confirm(
        context,
        title: Text('${ItgLocalization.tr("Confirm")} - ${ItgLocalization.tr("Delete")} ${ItgLocalization.tr(titleSingular)}'),
        content: Text(ItgLocalization.tr('Are you sure?'))
    )) {
      // final NotesApi api = NotesApi();
      // await api.deleteNote(current.id);
      // refresh<note, NoteManager>(context: context, notification: false);

      final failureOrSuccess = await sl<DeleteNotesItemUsecase>().call(data.id);
      itgLogVerbose('$baseLogMsg after usecase call - failureOrSuccess: $failureOrSuccess');
      failureOrSuccess.fold(
        (failure) =>
          showNotificationFailure(
            context: context,
            msg: "Error '$failure' when try to delete ${ItgLocalization.tr(titleSingular)}!"
          ),
        (_) {
          itgLogPrint('$baseLogMsg Item deleted...');
          showNotificationSuccess(
              context: context,
              msg: "${ItgLocalization.tr(titleSingular)} ${ItgLocalization.tr('has been deleted')}"
          );
          context.read<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
          if (context.widget is NotesItemShowPage) Navigator.of(context).pop();
        }
      );
    }
  }

  @override
  Future<dynamic> actionItemRefresh({required BuildContext context, required dynamic data}) async {
    itgLogVerbose('[NotesSupport.actionItemRefresh] ...');
    Navigator.of(context).pop();
    // await actionItemsRefresh(context: context);
    actionItemShow(context: context, data: data);
  }

  @override
  Future<dynamic> actionItemsRefresh({required BuildContext context}) async {
    itgLogVerbose('[NotesSupport.actionItemsRefresh] ...');
    // sl<NotesBloc>().add(const NotesSubscriptionRequestedEvent());
    context
        .read<NotesBloc>()
        .add(const NotesSubscriptionRequestedEvent());
  }
}