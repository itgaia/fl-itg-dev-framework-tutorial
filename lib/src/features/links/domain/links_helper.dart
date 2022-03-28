import 'package:dev_framework_tutorial/src/app/constants.dart';
import 'package:flutter/cupertino.dart';

import '../../../app/app_private_config.dart';
import '../data/links_model.dart';

// key name abbreviation constants for feature - unique
const keyAbbrFeatureLinks = 'ln';

const appTitleLinks = 'Links';
const appTitleLinksItem = 'Link';
const appTitleLinksItemAddPage = 'New $appTitleLinksItem';
const appTitleLinksItemEditPage = 'Edit $appTitleLinksItem';
const appTitleLinksItemDuplicatePage = 'Duplicate $appTitleLinksItem';

const urlLinks = '$serverUrl/links';

const keyButtonLinksPage = Key('button-links-page');

const keyLinksWidgetBase = '$keyAbbrSourceWidget-$keyAbbrFeatureLinks';
const keyLinksWidgetListItemBase = '$keyAbbrSourceWidget-$keyAbbrFeatureLinks-$keyAbbrListItem';
const keyLinksWidgetItemShowBase = '$keyAbbrSourceWidget-$keyAbbrFeatureLinks-$keyAbbrItem$keyAbbrShow';
const keyLinksWidgetItemAddEditBase = '$keyAbbrSourceWidget-$keyAbbrFeatureLinks-$keyAbbrItem$keyAbbrAddEdit';

// assets
const assetLinksFixture = 'links_fixture_asset.json';
const assetLinksResponseFixture = 'links_response_fixture.json';
const assetLinksItemCreateResponseFixture = 'links_item_create_response_fixture.json';

Map<String, dynamic> fieldsLinks = {
  'description': {'kind': 'field', 'type': 'string', 'label': 'Description', 'required': true},
  'notes': {'kind': 'field', 'type': 'string', 'label': 'Notes', 'required': false},
};

List<LinksModel> itemsLinksSample({int count = 5}) => List.generate(
    count,
        (i) => LinksModel(id: '${i+1}', description: 'test description ${i+1}', notes: 'test notes ${i+1}')
);

LinksModel itemLinksSample() => itemsLinksSample().first;

Map<String, dynamic> itemLinksObjectAsString(LinksModel item, {bool omitEmpty = true}) {
  Map<String, dynamic> ret = {};
  for (var element in LinksModel.fields) {
    if (!omitEmpty || (omitEmpty && item[element].toString().isNotEmpty)) {
      ret[element] = item[element];
    }
  }
  return ret;
}