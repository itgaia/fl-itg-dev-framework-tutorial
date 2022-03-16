import 'package:dev_framework_tutorial/src/app/constants.dart';

import '../data/notes_model.dart';

const keyNotesWidgetBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes';
const keyNotesWidgetListItemBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes-$keyAbbrListItem';
const keyNotesWidgetItemShowBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes-$keyAbbrItem$keyAbbrShow';
const keyNotesWidgetItemAddEditBase = '$keyAbbrSourceWidget-$keyAbbrFeatureNotes-$keyAbbrItem$keyAbbrAddEdit';

List<NotesModel> notesSampleData({int count = 5}) => List.generate(
    count,
        (i) => NotesModel(id: '${i+1}', description: 'test description ${i+1}', content: 'test content ${i+1}')
);
