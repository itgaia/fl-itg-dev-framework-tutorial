import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../app/injection_container.dart';
import '../../../../common/helper.dart';
import '../../../../common/itg_localization.dart';
import '../../domain/notes_helper.dart';
import '../../domain/notes_support.dart';
import 'bloc/notes_bloc.dart';
import 'notes_list_item.dart';

class NotesPage extends StatelessWidget {
  static const routeName = '/notes';

  static Route<void> route() {
    return MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => const NotesPage()
    );
  }

  const NotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[NotesPage]';
    itgLogVerbose('$baseLogMsg build...');
    // TODO: Do we need it? We already have dependency injection...
    // How can I BlocListeners can work with sl<>?
    return BlocProvider(
      // create: (_) => NotesBloc(Notes: GetNotesUsecase())
      create: (context) => sl<NotesBloc>()
        ..add(const NotesSubscriptionRequestedEvent()),
      child: const NotesView(),
    );
  }
}

class NotesView extends StatelessWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String baseLogMsg = '[NotesView]';
    itgLogVerbose('$baseLogMsg build...');
    return Scaffold(
      appBar: AppBar(
        title: Text(ItgLocalization.tr('Notes'), key: keyTextPageTitle),
        actions: const [
          // TodosOverviewFilterButton(),
          // TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<NotesBloc, NotesState>(
            listener: (context, state) {
              itgLogVerbose('$baseLogMsg BlocListener (all) - state.status: ${state.status}');
            }
          ),
          BlocListener<NotesBloc, NotesState>(
            listenWhen: (previous, current) => previous.status != current.status,
            listener: (context, state) {
              itgLogVerbose('$baseLogMsg BlocListener (status changed) - state.status: ${state.status}');
              if (state.status == NotesStatus.failure) {
                itgLogError('$baseLogMsg  failure: ${textMessageToDisplayError(dataModelName: 'Notes', errorMessage: '')}');
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(
                        textMessageToDisplayError(dataModelName: 'Notes', errorMessage: ''),
                        key: keyTextError
                      ),
                    ),
                  );
              }
            },
          ),
          BlocListener<NotesBloc, NotesState>(
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
                        dataModelName: 'Notes',
                        itemTitle: deletedItem.title
                      )),
                      action: SnackBarAction(
                        label: textButtonSnackbarDeleteUndo,
                        onPressed: () {
                          messenger.hideCurrentSnackBar();
                          context
                              .read<NotesBloc>()
                              .add(const NotesItemUndoDeletionRequestedEvent());
                        },
                      ),
                    ),
                );
            },
          ),
        ],
        child: BlocBuilder<NotesBloc, NotesState>(
          builder: (context, state) {
            itgLogVerbose('$baseLogMsg BlocBuilder start - state.status: ${state.status}');
            if (state.items.isEmpty) {
              itgLogVerbose('$baseLogMsg items is empty...');
              if (state.status == NotesStatus.loading) {
                return const Center(child: CupertinoActivityIndicator(key: keyProgressIndicatorMain));
              } else if (state.status != NotesStatus.success) {
                return const SizedBox();
              } else {
                itgLogVerbose('$baseLogMsg show text that items is Empty...');
                return Center(
                  child: Text(
                    textMessageToDisplayNoData(dataModelName: 'Notes'),
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
                    NotesListItem(item: item)
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
          ...sl<NotesSupport>().getFloatingActionsListForItems(context: context, baseKeyName: keyNotesWidgetListItemBase)
        ],
        key: const Key('$keyNotesWidgetListItemBase-floating-actions'),
      ),
      key: keyItemsPage
    );
  }
}
