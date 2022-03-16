import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../app/constants.dart';
import '../../../common/helper.dart';
import '../../../core/error/exception.dart';
import 'notes_model.dart';

const msgBaseSourceClass = 'NotesRemoteDataSource';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

abstract class NotesRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<NotesModel>> getNotes();
  Future<List<NotesModel>> searchNotes(query);
  Future<NotesModel> createNotesItem(NotesModel notesItem);
  Future<NotesModel> updateNotesItem(NotesModel notesItem);
  Future<void> deleteNotesItem(String id);
}

class NotesRemoteDataSourceImpl implements NotesRemoteDataSource {
  final http.Client client;

  NotesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<NotesModel>> searchNotes(query) async {
    itgLogVerbose('>>> NotesRemoteDataSourceImpl.searchNotes ---- query: $query');
    return List.generate(5, (i) => NotesModel(description: 'description $i'));
  }

  @override
  Future<List<NotesModel>> getNotes() async => _getNotesFromUrl(urlNotes);

  /// Returns data (List<NotesModel>) or a ServerException is raised
  Future<List<NotesModel>> _getNotesFromUrl(String url) async {
    const String baseLogMsg = '[NotesRemoteDataSourceImpl._getNotesFromUrl]';
    itgLogVerbose('$baseLogMsg url: $url');
    try {
      final notesUrl = Uri.parse(url);
      final response = await client.get(
        notesUrl,
        headers: {'Content-Type': 'application/json'},
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        return body
          .map<NotesModel>((json) => NotesModel.fromJson(json))
          .toList();
      } else {
        throw ServerException(description: 'Invalid response "${response.statusCode}"...');
      }
    } on ServerException catch (e) {
      itgLogError('$baseLogMsg Server exception: $e');
      rethrow;
    } catch (e) {
      itgLogError('$baseLogMsg exception: $e');
      throw ServerException(description: e.toString());
    }
  }

  @override
  Future<NotesModel> createNotesItem(NotesModel data) async {
    const String baseLogMsg = '[NotesRemoteDataSourceImpl.createNotesItem]';
    try {
      final url = Uri.parse(urlNotes);
      itgLogVerbose('$baseLogMsg url: $url');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson())
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if ([200,201].contains(response.statusCode)) {
        itgLogVerbose('$baseLogMsg success...');
        final retData = NotesModel.fromJson(json.decode(response.body));
        return retData;
      } else {
        itgLogVerbose('$baseLogMsg fail - response code "${response.statusCode}"');
        throw ServerException(description: '$baseLogMsg Failed tp create item with response code "${response.statusCode}"...');
      }
    } on ServerException catch (e) {
      itgLogError('$baseLogMsg Server exception: $e');
      rethrow;
    } catch (e) {
      itgLogError('$baseLogMsg Unhandled exception: $e');
      throw ServerException(description: e.toString());
    }
  }

  @override
  Future<NotesModel> updateNotesItem(NotesModel data) async {
    const String baseLogMsg = '[NotesRemoteDataSourceImpl.updateNotesItem]';
    final body = jsonEncode(data.toJson());
    itgLogVerbose('$baseLogMsg data: $data');
    itgLogVerbose('$baseLogMsg body: $body');
    try {
      final url = Uri.parse('$urlNotes/${data.id}');
      itgLogVerbose('$baseLogMsg url: $url');
      final response = await client.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if ([200,204].contains(response.statusCode)) {
        itgLogVerbose('$baseLogMsg response.body: ${response.body}');
        NotesModel retData;
        if (response.body.isNotEmpty) {
          retData = NotesModel.fromJson(json.decode(response.body));
        } else {
          // TODO: Do I need this one?
          retData = data.copyWith();
        }
        return retData;
      } else {
        throw ServerException(description: '$baseLogMsg Failed tp update item with response code "${response.statusCode}"...');
      }
    } on ServerException catch (e) {
      itgLogError('$baseLogMsg Server exception: $e');
      rethrow;
    } catch (e) {
      itgLogError('$baseLogMsg Unhandled exception: $e');
      throw ServerException(description: e.toString());
    }
  }

  @override
  Future<void> deleteNotesItem(String id) async {
    const String baseLogMsg = '[NotesRemoteDataSourceImpl.deleteNotesItem]';
    try {
      final url = Uri.parse('$urlNotes/$id');
      itgLogVerbose('$baseLogMsg url: $url');
      final response = await client.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if (![200,204].contains(response.statusCode)) {
        throw ServerException(description: '$baseLogMsg Failed tp delete item "$id" with response code "${response.statusCode}"...');
      }
    } on ServerException catch (e) {
      itgLogError('$baseLogMsg Server exception: $e');
      rethrow;
    } catch (e) {
      itgLogError('$baseLogMsg Unhandled exception: $e');
      throw ServerException(description: e.toString());
    }
  }
}
