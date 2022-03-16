import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/injection_container.dart';
import '../../../common/helper.dart';
import '../domain/notes_helper.dart';
import 'notes_model.dart';

const msgBaseSourceClass = 'NotesLocalDataSourceImpl';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

abstract class NotesLocalDataSource {
  Future<List<NotesModel>> getNotes({String query = ''});
  Future<void> removeNote(id);
  Future<NotesModel> addNote(note);
  Future<NotesModel> editNote(note);

  Future<void> cacheNotes(List<NotesModel> notesToCache);
}

const cachedNotesKey = 'CACHED_NOTES';
const textMultiLine = '''This is a multi-line text sample.
Testing line 2
Testing line 3

This a new paragraph
With 2nd line
and a 3rd line''';

const itemLongContent = NotesModel(
  id: '4',
  description: 'A note with a long content',
  content: textMultiLine
);

class NotesLocalDataSourceImpl implements NotesLocalDataSource {

  NotesLocalDataSourceImpl();

  @override
  Future<List<NotesModel>> getNotes({String query = ''}) {
    itgLogVerbose('>>> NotesLocalDataSourceImpl.getNotes - query: $query');
    return _getLastNotes();
  }

  @override
  Future<void> removeNote(id) async {
    // return Future.value(null);
  }

  @override
  Future<NotesModel> addNote(note) {
    itgLogVerbose('[NotesLocalDataSourceImpl.addNote] not implemented yet...');
    return Future.value(const NotesModel(description: 'description 11', content: 'content 11'));
  }

  @override
  Future<NotesModel> editNote(note) {
    return Future.value(note);
  }

  Future<List<NotesModel>> _getLastNotes() async {
    msgBaseSourceMethod = 'getLastNotes';
    msgLogInfo('start...');
    String? jsonString = sl<SharedPreferences>().getString(cachedNotesKey);
    msgLogInfo('jsonString: $jsonString');

    // jsonString = null;
    late List<NotesModel> items;
    if (jsonString == null) {
      items = notesSampleData(count: 2);
      // items = notesSampleData(count: 13);
      // items[3] = itemLongContent;
      // cacheNotes(items);
    } else {
      items = (json.decode(jsonString) as List).map((dynamic json) {
        return NotesModel.fromJson(json);
      }).toList();
    }
    return Future.value(items);

    // } else {
    //   throw const CacheException();
    // }
  }

  @override
  Future<bool> cacheNotes(List<NotesModel> notesToCache) async {
    msgLogInfo('>>> cacheNotes - notes string to save: ${json.encode(notesToCache.map((NotesModel note) => note.toJson()).toList())}');
    return sl<SharedPreferences>().setString(
      cachedNotesKey,
      json.encode(notesToCache.map((NotesModel note) => note.toJson()).toList()),
    );
  }
}
