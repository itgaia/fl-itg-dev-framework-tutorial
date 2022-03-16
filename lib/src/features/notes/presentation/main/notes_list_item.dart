import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:flutter/material.dart';

import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../data/notes_model.dart';
import '../../domain/notes_helper.dart';
import '../../domain/notes_support.dart';

class NotesListItem extends StatelessWidget {
  final NotesModel item;

  const NotesListItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[NotesListItem]';
    itgLogVerbose('$baseLogMsg build start...');
    itgLogVerbose('$baseLogMsg note: $item');
    // final textTheme = Theme.of(context).textTheme;
    return Material(
      child: NotesCard(item: item)
    );
  }
}

class NotesCard extends StatelessWidget {
  final NotesModel item;
  const NotesCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8.0,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.lightBlue[50]),
        // child: NotesListTile(item: item),
        child: NotesListItemView(item: item),
      ),
    );
  }
}

class NotesListItemView extends StatelessWidget {
  final NotesModel item;

  const NotesListItemView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Title(item: item),
                _Content(item: item)
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ...sl<NotesSupport>().getActionsListForListItem(context: context, data: item, baseKeyName: '$keyNotesWidgetListItemBase-${item.id}'),
            ],
            key: Key(keyNameGenerator(
                keyElement: KeyElement.widget,
                feature: [keyAbbrFeatureNotes, keyAbbrListItem],
                id: item.id,
                suffix: 'actions')),
          ),
        ],
      ),
    );
  }
}

class NotesListTile extends StatelessWidget {
  final NotesModel item;
  final DismissDirectionCallback? onDismissed;

  const NotesListTile({Key? key, required this.item, this.onDismissed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Implement actions (edit, duplicate, delete)
    //       How can I have buttons in Dismissible?
    //       maybe use flutter_slidable package instead...
    return Dismissible(
      key: Key('todoListTile_dismissible_${item.id}'),
      onDismissed: onDismissed,
      direction: DismissDirection.endToStart,
      confirmDismiss: (dismissDirection) async => false,
      background: Container(
        alignment: Alignment.centerRight,
        color: theme.colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(
          Icons.delete,
          color: Color(0xAAFFFFFF),
        ),
      ),
      child: ListTile(
        title: _Title(item: item),
        subtitle: _Content(item: item),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final NotesModel item;
  const _Title({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Text(
            item.title,
            // style: Theme.of(context).textTheme.caption,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            key: Key(keyNameGenerator(
                keyElement: KeyElement.widget,
                feature: [keyAbbrFeatureNotes, keyAbbrListItem],
                id: item.id,
                field: 'title'))
        ),
        onTap: () async {
          var result = await sl<NotesSupport>().actionItemShow(context: context, data: item);
          itgLogVerbose('baseLogMsg onTap - after return from item screen - result: $result');
        },
        key: Key(keyNameGenerator(
            keyElement: KeyElement.widget,
            feature: [keyAbbrFeatureNotes, keyAbbrListItem],
            id: item.id,
            action: KeyAction.show))
    );
  }
}

class _Content extends StatelessWidget {
  final NotesModel item;
  const _Content({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Text(
            item.content,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            key: Key(keyNameGenerator(
                keyElement: KeyElement.widget,
                feature: [keyAbbrFeatureNotes, keyAbbrListItem],
                id: item.id,
                field: 'content'))
        ),
      ),
    );
  }
}
