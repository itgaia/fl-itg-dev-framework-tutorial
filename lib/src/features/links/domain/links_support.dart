
import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/constants.dart';
import '../../../app/injection_container.dart';
import '../../../common/helper.dart';
import '../../../common/itg_localization.dart';
import '../../../core/support/support_base.dart';
import '../presentation/add_edit/links_item_add_edit_page.dart';
import '../presentation/main/bloc/links_bloc.dart';
import '../presentation/show/links_item_show_page.dart';
import 'delete_links_item_usecase.dart';

class LinksSupport extends SupportBase {
  @override
  String get titleSingular => 'Link';
  @override
  String get titlePlural => 'Links';
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
    itgLogVerbose('[LinksSupport.actionItemShow] ...');
    final ret = await Navigator.push(
        context,
        LinksItemShowPage.route(title: ItgLocalization.tr('LinksItem'), data: data,
          blocItems: context.read<LinksBloc>())
    );
    return ret;
  }

  @override
  Future<dynamic> actionItemEdit({required BuildContext context, required dynamic data}) async {
    const String baseLogMsg = '[LinksSupport.actionItemEdit]';
    itgLogVerbose('$baseLogMsg ...');
    // final ret = await Navigator.of(context).push(LinksItemAddEditPage.route(action: ItemAddEditAction.edit, initialData: data));
    final ret = await Navigator.push(
      context,
      LinksItemAddEditPage.route(action: ItemAddEditAction.edit, initialData: data)
    );
    itgLogVerbose('$baseLogMsg context: $context');
    context.read<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    // // final bloc = context.read<LinksBloc>();
    // final bloc = BlocProvider.of<LinksBloc>(context);
    // itgLogVerbose('>>> bloc: $bloc');
    // if (bloc is LinksBloc) {
    //   itgLogVerbose('>>> before add event in bloc...');
    //   bloc.add(const LinksSubscriptionRequestedEvent());
    // } else {
    //   itgLogError('$baseLogMsg Error: it was not possible to find the bloc in the context: $context');
    // }

    // TODO: Why it is not the same if I use the sl<>()?
    // itgLogVerbose('>>> BlocProvider.of: ${BlocProvider.of<LinksBloc>(context)}');
    // final bloc = context.read<LinksBloc>();
    // itgLogVerbose('>>> bloc: $bloc');
    // if (bloc is LinksBloc) {
    //   bloc.add(const LinksSubscriptionRequestedEvent());
    // } else {
    //   itgLogError('$baseLogMsg Error: it was not possible to find the bloc in the context: $context');
    // }
    // itgLogVerbose('>>> context.read<LinksBloc>(): ${context.read<LinksBloc>()}\n====================');
    // itgLogVerbose('>>> sl<LinksBloc>(): ${sl<LinksBloc>()}\n====================');
    // itgLogVerbose('>>> check equal: ${sl<LinksBloc>() == context.read<LinksBloc>()}');
    // // sl<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    // itgLogVerbose('$baseLogMsg result: $ret');
    return ret;
  }

  @override
  Future<dynamic> actionItemDuplicate({required BuildContext context, required data}) async {
    itgLogVerbose('[LinksSupport.actionItemDuplicate] ...');
    final ret = await Navigator.of(context).push(LinksItemAddEditPage.route(action: ItemAddEditAction.duplicate, initialData: data.copyWith(id: null, description: '${data.description}$textTitleSuffixDuplicate')));
    context.read<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    // sl<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    return ret;
  }

  @override
  Future<dynamic> actionItemAdd({required BuildContext context, dynamic data}) async {
    itgLogVerbose('[LinksSupport.actionItemAdd] ...');
    final ret =  await Navigator.of(context).push(LinksItemAddEditPage.route(action: ItemAddEditAction.add));
    itgLogVerbose('[LinksSupport.actionItemAdd] return from AddEditPage. Submit a LinksSubscriptionRequestedEvent...');
    context.read<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    // sl<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    return ret;
  }

  @override
  Future<dynamic> actionItemDelete({required BuildContext context, required data}) async {
    const String baseLogMsg = '[LinksSupport.actionItemDelete]';
    itgLogVerbose('$baseLogMsg start...');
    if (await confirm(
        context,
        title: Text('${ItgLocalization.tr("Confirm")} - ${ItgLocalization.tr("Delete")} ${ItgLocalization.tr(titleSingular)}'),
        content: Text(ItgLocalization.tr('Are you sure?'))
    )) {
      // final LinksApi api = LinksApi();
      // await api.deleteLink(current.id);
      // refresh<link, LinkManager>(context: context, notification: false);

      final failureOrSuccess = await sl<DeleteLinksItemUsecase>().call(data.id);
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
          context.read<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
          if (context.widget is LinksItemShowPage) Navigator.of(context).pop();
        }
      );
    }
  }

  @override
  Future<dynamic> actionItemRefresh({required BuildContext context, required dynamic data}) async {
    itgLogVerbose('[LinksSupport.actionItemRefresh] ...');
    Navigator.of(context).pop();
    // await actionItemsRefresh(context: context);
    actionItemShow(context: context, data: data);
  }

  @override
  Future<dynamic> actionItemsRefresh({required BuildContext context}) async {
    itgLogVerbose('[LinksSupport.actionItemsRefresh] ...');
    // sl<LinksBloc>().add(const LinksSubscriptionRequestedEvent());
    context
        .read<LinksBloc>()
        .add(const LinksSubscriptionRequestedEvent());
  }
}