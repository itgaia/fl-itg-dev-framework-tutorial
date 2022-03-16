import 'package:dev_framework_tutorial/src/common/etc/itg_text.dart';
import 'package:dev_framework_tutorial/src/features/notes/data/notes_model.dart';
import 'package:flutter/material.dart';

import '../../domain/notes_helper.dart';

class NotesItemScreen extends StatelessWidget {
  final NotesModel data;

  const NotesItemScreen({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ItgTextWithLabel(
              label: 'ID',
              text: data.id == null ? '<not assigned>' : data.id!,
              key: const Key('$keyNotesWidgetItemShowBase-col1-id')
            ),
            ItgTextWithLabel(
              label: 'Description',
              text: data.description,
              key: const Key('$keyNotesWidgetItemShowBase-col1-description')
            ),
            ItgTextWithLabel(
              label: 'Content',
              text: data.content,
              key: const Key('$keyNotesWidgetItemShowBase-col1-content')
            ),
          ],
        ),
      )
    );
  }
}
