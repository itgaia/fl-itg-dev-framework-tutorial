import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/itg_localization.dart';
import '../../domain/notes_helper.dart';
import 'bloc/notes_item_add_edit_bloc.dart';

class NotesItemAddEditView extends StatelessWidget {
  const NotesItemAddEditView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final status = context.select((NotesItemAddEditBloc bloc) => bloc.state.status);
    // final isNew = context.select((NotesItemAddEditBloc bloc) => bloc.state.isNew);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ?? theme.colorScheme.secondary;
    // final String title = isNew
    //     ? ItgLocalization.tr(appTitleNotesItemAddPage)
    //     : ItgLocalization.tr(appTitleNotesItemEditPage);
    const String baseMsgSource = '[NotesItemAddEditView.build]';
    itgLogVerbose('$baseMsgSource title: $title');

    return Scaffold(
      appBar: AppBar(title: Text(title, key: keyTextPageTitle)),
      floatingActionButton: FloatingActionButton(
        tooltip: ItgLocalization.tr('Save changes'),
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        backgroundColor: status.isSubmittingOrSuccess
            ? fabBackgroundColor.withOpacity(0.5)
            : fabBackgroundColor,
        onPressed: status.isSubmittingOrSuccess
            ? null
            // : () => context.read<NotesItemAddEditBloc>().add(const NotesItemAddEditSubmittedEvent()),
            : () {
          itgLogVerbose('$baseMsgSource save - clicked - add NotesItemAddEditSubmittedEvent...');
          context.read<NotesItemAddEditBloc>().add(const NotesItemAddEditSubmittedEvent());
          // sl<NotesItemAddEditBloc>().add(const NotesItemAddEditSubmittedEvent());
        },
        child: status.isSubmittingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
        key: keyButtonSaveItemAddEditPage,
      ),
      body: CupertinoScrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [_DescriptionField(), _ContentField()],
            ),
          ),
        ),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesItemAddEditBloc>().state;
    final hintText = state.initialData?.description ?? '';
    itgLogVerbose('[NotesItemAddEditView._DescriptionField.build] text: $hintText, label: ${ItgLocalization.tr('description')}');

    return TextFormField(
      key: const Key('$keyNotesWidgetItemAddEditBase-col1-description'),
      initialValue: state.description,
      decoration: InputDecoration(
        enabled: !state.status.isSubmittingOrSuccess,
        labelText: ItgLocalization.tr('description'),
        hintText: hintText,
      ),
      maxLength: 50,
      inputFormatters: [
        LengthLimitingTextInputFormatter(50),
      ],
      onChanged: (value) {
        itgLogVerbose('NotesItemAddEditView._DescriptionField - TextFormField - onChange - value: $value');
        context.read<NotesItemAddEditBloc>().add(NotesItemAddEditDescriptionChangedEvent(value));
        // sl<NotesItemAddEditBloc>().add(NotesItemAddEditCodeChangedEvent(value));
      },
    );
  }
}

class _ContentField extends StatelessWidget {
  const _ContentField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotesItemAddEditBloc>().state;
    final hintText = state.initialData?.content ?? '';
    itgLogVerbose('[NotesItemAddEditView._ContentField.build] text: $hintText, label: ${ItgLocalization.tr('content')}');

    return TextFormField(
      key: const Key('$keyNotesWidgetItemAddEditBase-col1-content'),
      initialValue: state.content,
      decoration: InputDecoration(
        enabled: !state.status.isSubmittingOrSuccess,
        labelText: ItgLocalization.tr('content'),
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        itgLogVerbose('NotesItemAddEditView._ContentField - TextFormField - onChange - value: $value');
        context.read<NotesItemAddEditBloc>().add(NotesItemAddEditContentChangedEvent(value));
        // sl<NotesItemAddEditBloc>().add(NotesItemAddEditNotesChangedEvent(value));
      },
    );
  }
}
