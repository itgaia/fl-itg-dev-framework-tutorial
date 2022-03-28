import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:flutter/cupertino.dart';

import '../../../app/app_private_config.dart';
import '../data/notes_model.dart';

// key name abbreviation constants for feature - unique
const keyAbbrFeatureNotes = 'nt';

const appTitleNotes = 'Notes';
const appTitleNotesItem = 'Note';
const appTitleNotesItemAddPage = 'New $appTitleNotesItem';
const appTitleNotesItemEditPage = 'Edit $appTitleNotesItem';
const appTitleNotesItemDuplicatePage = 'Duplicate $appTitleNotesItem';

const urlNotes = '$serverUrl/notes';

const keyButtonNotesPage = Key('button-notes-page');

const keyNotesWidgetBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes';
const keyNotesWidgetListItemBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes-$keyAbbrListItem';
const keyNotesWidgetItemShowBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes-$keyAbbrItem$keyAbbrShow';
const keyNotesWidgetItemAddEditBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes-$keyAbbrItem$keyAbbrAddEdit';

// assets
const assetNotesFixture = 'notes_fixture_asset.json';
const assetNotesResponseFixture = 'notes_response_fixture.json';
const assetNotesItemCreateResponseFixture = 'notes_item_create_response_fixture.json';

Map<String, dynamic> fieldsNotes = {
  'description': {'kind': 'field', 'type': 'string', 'label': 'Description', 'required': true},
  'content': {'kind': 'field', 'type': 'string', 'label': 'Content', 'required': true},
};

List<NotesModel> itemsNotesSample({int count = 5}) => List.generate(
    count,
        (i) => NotesModel(id: '${i+1}', description: 'test description ${i+1}', content: 'test content ${i+1}')
);

NotesModel itemNotesSample() => itemsNotesSample().first;

Map<String, dynamic> itemNotesObjectAsString(NotesModel item, {bool omitEmpty = true}) {
  Map<String, dynamic> ret = {};
  for (var element in NotesModel.fields) {
    if (!omitEmpty || (omitEmpty && item[element].toString().isNotEmpty)) {
      ret[element] = item[element];
    }
  }
  return ret;
}