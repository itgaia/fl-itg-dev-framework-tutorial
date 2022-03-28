import 'package:flutter/material.dart';


const appDebugMode = true;
const appDebugPaintSizeEnabled = false;
const appDebugShowCheckedModeBanner = false;

const keyNameSeparator = '-';
const keyShow = 'show';
const keyAdd = 'add';
const keyRefresh = 'refresh';
const keyEdit = 'edit';
const keyDuplicate = 'duplicate';
const keyDelete = 'delete';
const keyFloating = 'floating';
const keyAction = 'action';
final String keyActionShow = [keyAction, keyShow].join(keyNameSeparator);
final String keyActionAdd = [keyAction, keyAdd].join(keyNameSeparator);
final String keyActionRefresh = [keyAction, keyRefresh].join(keyNameSeparator);
final String keyActionDuplicate = [keyAction, keyDuplicate].join(keyNameSeparator);
final String keyActionEdit = [keyAction, keyEdit].join(keyNameSeparator);
final String keyActionDelete = [keyAction, keyDelete].join(keyNameSeparator);
final String keyFloatingAction = [keyFloating, keyAction].join(keyNameSeparator);
final String keyFloatingActionShow = [keyFloatingAction, keyShow].join(keyNameSeparator);
final String keyFloatingActionAdd = [keyFloatingAction, keyAdd].join(keyNameSeparator);
final String keyFloatingActionRefresh = [keyFloatingAction, keyRefresh].join(keyNameSeparator);
final String keyFloatingActionDuplicate = [keyFloatingAction, keyDuplicate].join(keyNameSeparator);
final String keyFloatingActionEdit = [keyFloatingAction, keyEdit].join(keyNameSeparator);
final String keyFloatingActionDelete = [keyFloatingAction, keyDelete].join(keyNameSeparator);

// key name abbreviation constants
const keyAbbrShow = 's';
const keyAbbrItem = 'i';
const keyAbbrListItem = 'li';
const keyAbbrAddEdit = 'ae';

// key name abbreviation constants for source element - unique
const keyAbbrSourceWidget = 'w';

const appTitleFull = 'Dev Framework Tutorial (part 1)';

const textButtonSnackbarDeleteUndo = 'Undo';
const textHomePageWelcomeMessage1 = 'What a Wonderful World for All of Us...';
const textHomePageWelcomeMessage2 = '(Click the menu up-right for the available options)';
const textSampleException = 'Some exception occurred';
const textSampleFailure = 'Some failure occurred';
const textSampleContent = 'Some sample content';

const keyAppBarPage = Key('app-bar-page');
const keyButtonSaveItemAddEditPage = Key('button-save-item-add-edit');
const keyButtonSnackbarDeleteUndo = Key('button-snackbar-delete-undo');
const keyItemsItemShowPage = Key('page-items-item');
const keyItemsListWidget = Key('widget-items-list');
const keyItemsPage = Key('page-items');
const keyListWidgetItemsData = Key('list-page-items-data');
const keyNotificationFailure = Key('notification-failure');
const keyNotificationSuccess = Key('notification-success');
const keyNotificationInfo = Key('notification-info');
const keyProgressIndicatorMain = Key('progress-indicator-main');
const keyTextPageTitle = Key('text-page-title');
const keyTextHomePageWelcomeMessage1 = Key('text-home-page-welcome-message-1');
const keyTextHomePageWelcomeMessage2 = Key('text-home-page-welcome-message-2');
const keyTextError = Key('text-error');

Future<bool> networkInfoIsConnected = Future.value(false);  // Temporary...

/// If the backend is MongoDb then id field is {"_id":{"$oid":"61011f6d4558ebe4f88acccc"}}
bool useMongoDbBackend = false;

/// Use shared_preferences package for persisting data
bool useSharedPreferencesBackend = true;

/// Use http.client for persisting data
bool useHttpClient = false;

const textTitleSuffixDuplicate = ' (copy)';

// colors
const Color colorDarkGrey = Color.fromRGBO(64, 75, 96, .9);

const mapKeyId = 'id';
const mapKeyBaseId = 'base_id';
const mapKeyRenderList = 'render_list';
const mapKeyInherit = 'inherit';
const mapKeyShowActions = 'show_actions';
const mapKeyField = 'field';
const mapKeyAlign = 'align';
const mapValueAlignRight = 'right';
const mapValueAlignLeft = 'left';
const mapValueAlignCenter = 'center';
const mapKeyKind = 'kind';
const mapValueKindColumn = 'widget_column';
const mapValueKindRow = 'widget_row';
const mapKeyOnClick = 'on_click';
const mapValueOnClickShowCurrentItem = '###show-current-item###';
