import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../../../common/itg_localization.dart';
import '../../domain/links_helper.dart';
import '../../domain/links_support.dart';
import 'bloc/links_bloc.dart';
import 'links_list_item.dart';

class LinksPage extends StatelessWidget {
  static const routeName = '/links';

  static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const LinksPage()
    );
  }

  const LinksPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[LinksPage]';
    itgLogVerbose('$baseLogMsg build...');
    // TODO: Do we need it? We already have dependency injection...
    // How can I BlocListeners can work with sl<>?
    return BlocProvider(
      // create: (_) => LinksBloc(Links: GetLinksUsecase())
      create: (context) => sl<LinksBloc>()
        ..add(const LinksSubscriptionRequestedEvent()),
      child: const LinksView(),
    );
  }
}

class LinksView extends StatelessWidget {
  const LinksView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[LinksView]';
    itgLogVerbose('$baseLogMsg build...');
    return Scaffold(
      appBar: AppBar(
        title: Text(ItgLocalization.tr('Links'), key: keyTextPageTitle),
        actions: const [
          // TodosOverviewFilterButton(),
          // TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<LinksBloc, LinksState>(
            listener: (context, state) {
              itgLogVerbose('$baseLogMsg BlocListener (all) - state.status: ${state.status}');
            }
          ),
          BlocListener<LinksBloc, LinksState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              itgLogVerbose('$baseLogMsg BlocListener (status changed) - state.status: ${state.status}');
              if (state.status == LinksStatus.failure) {
                itgLogError('$baseLogMsg  failure: ${textMessageToDisplayError(dataModelName: 'Links', errorMessage: '')}');
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        textMessageToDisplayError(dataModelName: 'Links', errorMessage: ''),
                        key: keyTextError
                      ),
                    ),
                  );
              }
            },
          ),
          BlocListener<LinksBloc, LinksState>(
            listenWhen: (previous, current) =>
              previous.lastDeletedItem != current.lastDeletedItem &&
              current.lastDeletedItem != null,
            listener: (context, state) {
              final deletedItem = state.lastDeletedItem!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    SnackBar(
                      content: Text(textMessageToDisplayDeleteItem(
                        dataModelName: 'Links',
                        itemTitle: deletedItem.title
                      )),
                      action: SnackBarAction(
                        label: textButtonSnackbarDeleteUndo,
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context
                              .read<LinksBloc>()
                              .add(const LinksItemUndoDeletionRequestedEvent());
                        },
                      ),
                    ),
                );
            },
          ),
        ],
        child: BlocBuilder<LinksBloc, LinksState>(
          builder: (context, state) {
            itgLogVerbose('$baseLogMsg BlocBuilder start - state.status: ${state.status}');
            if (state.items.isEmpty) {
              itgLogVerbose('$baseLogMsg items is empty...');
              if (state.status == LinksStatus.loading) {
                return const Center(child: CupertinoActivityIndicator(key: keyProgressIndicatorMain));
              } else if (state.status != LinksStatus.success) {
                return const SizedBox();
              } else {
                itgLogVerbose('$baseLogMsg show text that items is Empty...');
                return Center(
                  child: Text(
                    textMessageToDisplayNoData(dataModelName: 'Links'),
                    style: Theme.of(context).textTheme.caption,
                  ),
                );
              }
            }

            itgLogVerbose('$baseLogMsg render items in ListView...');
            itgLogVerbose('$baseLogMsg state.items.last: ${state.items.last}...');
            return CupertinoScrollbar(
              child: ListView(
                children: [
                  for (final item in state.filteredItems)
                    LinksListItem(item: item)
                ],
                key: keyItemsListWidget,
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ...sl<LinksSupport>().getFloatingActionsListForItems(context: context, baseKeyName: keyLinksWidgetListItemBase)
        ],
        key: const Key('$keyLinksWidgetListItemBase-floating-actions'),
      ),
      key: keyItemsPage
    );
  }
}
