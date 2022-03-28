import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/injection_container.dart';
import '../../../common/helper.dart';
import '../domain/links_helper.dart';
import 'links_model.dart';

const msgBaseSourceClass = 'LinksLocalDataSourceImpl';
String msgBaseSourceMethod = '';
void msgLogInfo(String msg) => itgLogVerbose('[$msgBaseSourceClass/$msgBaseSourceMethod] $msg');

abstract class LinksLocalDataSource {
  Future<List<LinksModel>> getLinks({String query = ''});
  Future<void> removeLink(id);
  Future<LinksModel> addLink(link);
  Future<LinksModel> editLink(link);

  Future<void> cacheLinks(List<LinksModel> linksToCache);
}

const cachedLinksKey = 'CACHED_LINKS';
const textMultiLine = '''This is a multi-line text sample.
Testing line 2
Testing line 3

This a new paragraph
With 2nd line
and a 3rd line''';

// const itemLongContent = LinksModel(
//   id: '4',
//   description: 'A link with a long content',
//   content: textMultiLine
// );

class LinksLocalDataSourceImpl implements LinksLocalDataSource {

  LinksLocalDataSourceImpl();

  @override
  Future<List<LinksModel>> getLinks({String query = ''}) {
    itgLogVerbose('>>> LinksLocalDataSourceImpl.getLinks - query: $query');
    return _getLastLinks();
  }

  @override
  Future<void> removeLink(id) async {
    // return Future.value(null);
  }

  @override
  Future<LinksModel> addLink(link) {
    itgLogVerbose('[LinksLocalDataSourceImpl.addLink] not implemented yet...');
    // return Future.value(const LinksModel(description: 'description 11', content: 'content 11'));
    return Future.value(itemLinksSample());
  }

  @override
  Future<LinksModel> editLink(link) {
    return Future.value(link);
  }

  Future<List<LinksModel>> _getLastLinks() async {
    msgBaseSourceMethod = 'getLastLinks';
    msgLogInfo('start...');
    String? jsonString = sl<SharedPreferences>().getString(cachedLinksKey);
    msgLogInfo('jsonString: $jsonString');

    // jsonString = null;
    late List<LinksModel> items;
    if (jsonString == null) {
      items = itemsLinksSample(count: 2);
      // items = linksSampleData(count: 13);
      // items[3] = itemLongContent;
      // cacheLinks(items);
    } else {
      items = (json.decode(jsonString) as List).map((dynamic json) {
        return LinksModel.fromJson(json);
      }).toList();
    }
    return Future.value(items);

    // } else {
    //   throw const CacheException();
    // }
  }

  @override
  Future<bool> cacheLinks(List<LinksModel> linksToCache) async {
    msgLogInfo('>>> cacheLinks - links string to save: ${json.encode(linksToCache.map((LinksModel link) => link.toJson()).toList())}');
    return sl<SharedPreferences>().setString(
      cachedLinksKey,
      json.encode(linksToCache.map((LinksModel link) => link.toJson()).toList()),
    );
  }
}
