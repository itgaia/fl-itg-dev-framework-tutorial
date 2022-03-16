import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../data/notes_model.dart';
import '../../domain/notes_helper.dart';
import '../../domain/notes_support.dart';
import '../main/bloc/notes_bloc.dart';
import 'notes_item_screen.dart';

const msgBaseSourceClass = 'NotesItemShowPage';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');
void msgLogPrint(String msg) => itgLogPrint('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

class NotesItemShowPage extends StatelessWidget {
  static const routeName = '/notes_item';

  static Route<void> route({required NotesModel data, required String title, NotesBloc? blocItems}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => blocItems == null
        ? NotesItemShowPage(title: title, item: data)
        : BlocProvider<NotesBloc>.value(
            value: blocItems,
            child: BlocListener<NotesBloc, NotesState>(
              listenWhen: (previous, current) =>
              previous.status != current.status &&
                  current.status == NotesStatus.success,
              listener: (context, state) {
                msgBaseSourceMethod = 'NotesBloc changed';
                msgLogInfo('data: $data');

                try {
                  final newData = state.items.firstWhere((element) => element.id == data.id);
                  msgLogInfo('newData: $newData');
                  sl<NotesSupport>().actionItemRefresh(context: context, data: newData);
                } on StateError {
                  itgLogError('[NotesItemShowPage.Route] on items state change - Did not find item with id: ${data.id}');
                }
                // showNotificationSuccess(context: context, msg: 'Items changed...');
                // Navigator.of(context).pop();
              },
              child: NotesItemShowPage(title: title, item: data)
            ),
          )
    );
  }

  final String title;
  final NotesModel item;

  const NotesItemShowPage({required this.title, required this.item, Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    msgBaseSourceMethod = 'build';
    msgLogInfo('title: $title');
    return Scaffold(
        appBar: AppBar(title: Text(title, key: keyTextPageTitle)),
        body: NotesItemScreen(data: item),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ...sl<NotesSupport>().getFloatingActionsListForItem(data: item, context: context, baseKeyName: keyNotesWidgetItemShowBase)
          ],
          key: const Key('$keyNotesWidgetItemShowBase-floating-actions'),
        ),
        key: keyItemsItemShowPage
    );
  }

}