import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../common/helper.dart';
import '../../../core/error/exception.dart';
import '../domain/links_helper.dart';
import 'links_model.dart';

const msgBaseSourceClass = 'LinksRemoteDataSource';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

abstract class LinksRemoteDataSource {
  /// Throws a [ServerException] for all error codes.
  Future<List<LinksModel>> getLinks();
  Future<List<LinksModel>> searchLinks(query);
  Future<LinksModel> createLinksItem(LinksModel linksItem);
  Future<LinksModel> updateLinksItem(LinksModel linksItem);
  Future<void> deleteLinksItem(String id);
}

class LinksRemoteDataSourceImpl implements LinksRemoteDataSource {
  final http.Client client;

  LinksRemoteDataSourceImpl({required this.client});

  @override
  Future<List<LinksModel>> searchLinks(query) async {
    itgLogVerbose('>>> LinksRemoteDataSourceImpl.searchLinks ---- query: $query');
    return List.generate(5, (i) => LinksModel(description: 'description $i'));
  }

  @override
  Future<List<LinksModel>> getLinks() async => _getLinksFromUrl(urlLinks);

  /// Returns data (List<LinksModel>) or a ServerException is raised
  Future<List<LinksModel>> _getLinksFromUrl(String url) async {
    const String baseLogMsg = '[LinksRemoteDataSourceImpl._getLinksFromUrl]';
    itgLogVerbose('$baseLogMsg url: $url');
    try {
      final linksUrl = Uri.parse(url);
      final response = await client.get(
        linksUrl,
        headers: {'Content-Type': 'application/json'},
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        final body = json.decode(response.body) as List;
        return body
          .map<LinksModel>((json) => LinksModel.fromJson(json))
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
  Future<LinksModel> createLinksItem(LinksModel data) async {
    const String baseLogMsg = '[LinksRemoteDataSourceImpl.createLinksItem]';
    try {
      final url = Uri.parse(urlLinks);
      itgLogVerbose('$baseLogMsg url: $url');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson())
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if ([200,201].contains(response.statusCode)) {
        itgLogVerbose('$baseLogMsg success...');
        final retData = LinksModel.fromJson(json.decode(response.body));
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
  Future<LinksModel> updateLinksItem(LinksModel data) async {
    const String baseLogMsg = '[LinksRemoteDataSourceImpl.updateLinksItem]';
    final body = jsonEncode(data.toJson());
    itgLogVerbose('$baseLogMsg data: $data');
    itgLogVerbose('$baseLogMsg body: $body');
    try {
      final url = Uri.parse('$urlLinks/${data.id}');
      itgLogVerbose('$baseLogMsg url: $url');
      final response = await client.put(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body
      );
      itgLogVerbose('$baseLogMsg response.statusCode: ${response.statusCode}');
      if ([200,204].contains(response.statusCode)) {
        itgLogVerbose('$baseLogMsg response.body: ${response.body}');
        LinksModel retData;
        if (response.body.isNotEmpty) {
          retData = LinksModel.fromJson(json.decode(response.body));
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
  Future<void> deleteLinksItem(String id) async {
    const String baseLogMsg = '[LinksRemoteDataSourceImpl.deleteLinksItem]';
    try {
      final url = Uri.parse('$urlLinks/$id');
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
