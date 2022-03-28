import 'package:dev_framework_tutorial/src/common/etc/itg_text.dart';
import 'package:dev_framework_tutorial/src/features/links/data/links_model.dart';
import 'package:flutter/material.dart';

import '../../domain/links_helper.dart';

class LinksItemScreen extends StatelessWidget {
  final LinksModel data;

  const LinksItemScreen({required this.data, Key? key}) : super(key: key);

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
              key: const Key('$keyLinksWidgetItemShowBase-col1-id')
            ),
            //** fields start **//
            ItgTextWithLabel(
              label: 'Description',
              text: data.description,
              key: const Key('$keyLinksWidgetItemShowBase-col1-description')
            ),
            ItgTextWithLabel(
              label: 'Notes',
              text: data.notes,
              key: const Key('$keyLinksWidgetItemShowBase-col1-notes')
            ),
            //** fields end **//
          ],
        ),
      )
    );
  }
}
