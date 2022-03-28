import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../data/links_model.dart';
import '../../domain/links_helper.dart';
import '../../domain/links_support.dart';
import '../main/bloc/links_bloc.dart';
import 'links_item_screen.dart';

const msgBaseSourceClass = 'LinksItemShowPage';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');
void msgLogPrint(String msg) => itgLogPrint('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

class LinksItemShowPage extends StatelessWidget {
  static const routeName = '/links_item';

  static Route<void> route({required LinksModel data, required String title, LinksBloc? blocItems}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => blocItems == null
        ? LinksItemShowPage(title: title, item: data)
        : BlocProvider<LinksBloc>.value(
            value: blocItems,
            child: BlocListener<LinksBloc, LinksState>(
              listenWhen: (previous, current) =>
              previous.status != current.status &&
                  current.status == LinksStatus.success,
              listener: (context, state) {
                msgBaseSourceMethod = 'LinksBloc changed';
                msgLogInfo('data: $data');

                try {
                  final newData = state.items.firstWhere((element) => element.id == data.id);
                  msgLogInfo('newData: $newData');
                  sl<LinksSupport>().actionItemRefresh(context: context, data: newData);
                } on StateError {
                  itgLogError('[LinksItemShowPage.Route] on items state change - Did not find item with id: ${data.id}');
                }
                // showNotificationSuccess(context: context, msg: 'Items changed...');
                // Navigator.of(context).pop();
              },
              child: LinksItemShowPage(title: title, item: data)
            ),
          )
    );
  }

  final String title;
  final LinksModel item;

  const LinksItemShowPage({required this.title, required this.item, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    msgBaseSourceMethod = 'build';
    msgLogInfo('title: $title');
    return Scaffold(
        appBar: AppBar(title: Text(title, key: keyTextPageTitle)),
        body: LinksItemScreen(data: item),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...sl<LinksSupport>().getFloatingActionsListForItem(data: item, context: context, baseKeyName: keyLinksWidgetItemShowBase)
          ],
          key: const Key('$keyLinksWidgetItemShowBase-floating-actions'),
        ),
        key: keyItemsItemShowPage
    );
  }

}