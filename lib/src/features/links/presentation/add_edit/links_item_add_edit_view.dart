import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/itg_localization.dart';
import '../../domain/links_helper.dart';
import 'bloc/links_item_add_edit_bloc.dart';

class LinksItemAddEditView extends StatelessWidget {
  const LinksItemAddEditView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final status = context.select((LinksItemAddEditBloc bloc) => bloc.state.status);
    // final isNew = context.select((LinksItemAddEditBloc bloc) => bloc.state.isNew);
    final theme = Theme.of(context);
    final floatingActionButtonTheme = theme.floatingActionButtonTheme;
    final fabBackgroundColor = floatingActionButtonTheme.backgroundColor ?? theme.colorScheme.secondary;
    // final String title = isNew
    //     ? ItgLocalization.tr(appTitleLinksItemAddPage)
    //     : ItgLocalization.tr(appTitleLinksItemEditPage);
    const String baseMsgSource = '[LinksItemAddEditView.build]';
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
            // : () => context.read<LinksItemAddEditBloc>().add(const LinksItemAddEditSubmittedEvent()),
            : () {
          itgLogVerbose('$baseMsgSource save - clicked - add LinksItemAddEditSubmittedEvent...');
          context.read<LinksItemAddEditBloc>().add(const LinksItemAddEditSubmittedEvent());
          // sl<LinksItemAddEditBloc>().add(const LinksItemAddEditSubmittedEvent());
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
              children: const [_DescriptionField(), _NotesField()],
            ),
          ),
        ),
      ),
    );
  }
}

//** fields start **//
class _DescriptionField extends StatelessWidget {
  const _DescriptionField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LinksItemAddEditBloc>().state;
    final hintText = state.initialData?.description ?? '';
    itgLogVerbose('[LinksItemAddEditView._DescriptionField.build] text: $hintText, label: ${ItgLocalization.tr('description')}');

    return TextFormField(
      key: const Key('$keyLinksWidgetItemAddEditBase-col1-description'),
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
        itgLogVerbose('LinksItemAddEditView._DescriptionField - TextFormField - onChange - value: $value');
        context.read<LinksItemAddEditBloc>().add(LinksItemAddEditDescriptionChangedEvent(value));
        // sl<LinksItemAddEditBloc>().add(LinksItemAddEditCodeChangedEvent(value));
      },
    );
  }
}

class _NotesField extends StatelessWidget {
  const _NotesField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LinksItemAddEditBloc>().state;
    final hintText = state.initialData?.notes ?? '';
    itgLogVerbose('[LinksItemAddEditView._NotesField.build] text: $hintText, label: ${ItgLocalization.tr('notes')}');

    return TextFormField(
      key: const Key('$keyLinksWidgetItemAddEditBase-col1-notes'),
      initialValue: state.notes,
      decoration: InputDecoration(
        enabled: !state.status.isSubmittingOrSuccess,
        labelText: ItgLocalization.tr('notes'),
        hintText: hintText,
      ),
      maxLength: 300,
      maxLines: 7,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        itgLogVerbose('LinksItemAddEditView._NotesField - TextFormField - onChange - value: $value');
        context.read<LinksItemAddEditBloc>().add(LinksItemAddEditNotesChangedEvent(value));
        // sl<LinksItemAddEditBloc>().add(LinksItemAddEditCodeChangedEvent(value));
      },
    );
  }
}
//** fields end **//
