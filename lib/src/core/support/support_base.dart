import 'package:flutter/material.dart';

import '../../app/constants.dart';
import '../../common/helper.dart';
import '../../common/itg_localization.dart';

abstract class SupportBase {
  String titleSingular = 'Support';
  String titlePlural = 'Supports';
  bool miniFloatingActionButton = false;
  bool allowRefresh = false;
  bool allowEdit = false;
  bool allowDuplicate = false;
  bool allowAdd = false;
  bool allowDelete = false;

  Future<dynamic> actionItemShow({required BuildContext context, required dynamic data});
  Future<dynamic> actionItemEdit({required BuildContext context, required dynamic data});
  Future<dynamic> actionItemAdd({required BuildContext context, dynamic data});
  Future<dynamic> actionItemDelete({required BuildContext context, required dynamic data});
  Future<dynamic> actionItemDuplicate({required BuildContext context, required dynamic data});
  Future<dynamic> actionItemRefresh({required BuildContext context, required dynamic data});
  Future<dynamic> actionItemsRefresh({required BuildContext context});

  List<Widget> getFloatingActionsListForItem<T, TSupport>({required data, required BuildContext context, required String baseKeyName}) {
    return [
      if (allowRefresh)
        buttonFloatingAction(context: context, tooltip: "Refresh ${ItgLocalization.tr(titleSingular)}...",
            onAction: () async {
              var result = await actionItemRefresh(data: data, context: context);
              itgLogVerbose('[getActionsListForListItem] after return from item refresh - result: $result');
            },
            icon: Icons.refresh_outlined, mini: miniFloatingActionButton,
            key: Key('$baseKeyName-$keyFloatingActionRefresh')),
      if (allowEdit)
        buttonFloatingAction(context: context, tooltip: "Edit ${ItgLocalization.tr(titleSingular)}...",
            onAction: () async {
              var result = await actionItemEdit(context: context, data: data);
              itgLogVerbose('[getActionsListForListItem] after return from item edit screen - result: $result');
            },
            icon: Icons.edit_outlined, mini: miniFloatingActionButton,
            key: Key('$baseKeyName-$keyFloatingActionEdit')),
      if (allowDuplicate)
        buttonFloatingAction(context: context, tooltip: "Duplicate ${ItgLocalization.tr(titleSingular)}...",
            onAction: () async {
              await actionItemDuplicate(context: context, data: data);
            },
            icon: Icons.copy_outlined, mini: miniFloatingActionButton,
            key: Key('$baseKeyName-$keyFloatingActionDuplicate')),
      if (allowAdd)
        buttonFloatingAction(context: context, tooltip: "Add new ${ItgLocalization.tr(titleSingular)}...",
            onAction: () async {
              await actionItemAdd(context: context, data: data);
            },
            icon: Icons.add_outlined, mini: miniFloatingActionButton,
            key: Key('$baseKeyName-$keyFloatingActionAdd')),
      if (allowDelete)
        buttonFloatingAction(context: context, tooltip: "Delete ${ItgLocalization.tr(titleSingular)}...",
            onAction: () async {
              await actionItemDelete(context: context, data: data);
            },
            icon: Icons.delete_forever_outlined, mini: miniFloatingActionButton,
            key: Key('$baseKeyName-$keyFloatingActionDelete')),
    ];
  }

  List<Widget> getFloatingActionsListForItems<T, TSupport>({required BuildContext context, required String baseKeyName}) {
    return [
      buttonFloatingAction(context: context, tooltip: "Refresh ${ItgLocalization.tr(titleSingular)}...",
          onAction: () async {
            await actionItemsRefresh(context: context);
          },
          icon: Icons.refresh_outlined, mini: miniFloatingActionButton,
          key: Key('$baseKeyName-$keyFloatingActionRefresh')),
      buttonFloatingAction(context: context, tooltip: "Add new ${ItgLocalization.tr(titleSingular)}...",
          onAction: () async {
            var result = await actionItemAdd(context: context);
            itgLogVerbose('[getFloatingActionsListForItems/add/onAction] result: $result');
          },
          icon: Icons.add_outlined, mini: miniFloatingActionButton,
          key: Key('$baseKeyName-$keyFloatingActionAdd')),
    ];
  }

  List<Widget> getActionsListForListItem<T, TSupport>({required BuildContext context, required dynamic data, required String baseKeyName}) {
    return [
      buttonDoAction(context: context, tooltip: "Edit...",
          onAction: () async {
            await actionItemEdit(context: context, data: data);
          },
          icon: Icons.edit_outlined,
          key: Key('$baseKeyName-$keyActionEdit')),
      buttonDoAction(context: context, tooltip: "Duplicate...",
          onAction: () async {
            await actionItemDuplicate(context: context, data: data);
          },
          icon: Icons.copy_outlined,
          key: Key('$baseKeyName-$keyActionDuplicate')),
      buttonDoAction(context: context, tooltip: "Delete...",
          onAction: () async {
            await actionItemDelete(context: context, data: data);
          },
          icon: Icons.delete_forever_outlined,
          key: Key('$baseKeyName-$keyActionDelete')),
    ];
  }
}
