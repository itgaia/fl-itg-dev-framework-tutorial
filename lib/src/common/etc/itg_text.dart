import 'package:flutter/material.dart';

import '../helper.dart';
import '../../app/constants.dart';

class ItgText extends Text {
  final String text;
  final String? label;
  final TextStyle? textStyle;
  const ItgText({required this.text, this.label, this.textStyle, Key? key}) : super(text, style: textStyle, key: key);
}

class ItgTextTitle extends ItgText {
  ItgTextTitle({required String text, BuildContext? context, TextStyle? textStyle, Key? key})
      : super(
      text: text,
      textStyle: textStyle ??= (context == null
          ? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple)
          : TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)),
      key: key
  );
}

class ItgTextWithLabel extends StatelessWidget {
  final String text;
  final String? label;
  final TextStyle? textStyle;
  final String align;
  const ItgTextWithLabel({required this.text, this.label, this.textStyle, this.align = 'left', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    itgLogVerbose('[ItgTextWithLabel.build] text: $text, align: $align');
    Widget widget = TextFormField(
      initialValue: text,
      decoration: InputDecoration(
          labelText: label,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none
      ),
      enabled: false,
      key: key == null ? null : Key('${keyName(key!)}-b'),
    );
    if (align == mapValueAlignRight) {
      widget = Directionality(
        textDirection: TextDirection.rtl,
        child: widget,
        key: key == null ? null : Key('${keyName(key!)}-r'),
      );
    }
    return widget;
    // return Expanded(
    //   child: widget,
    // );
  }
}

class ItgTextDate extends ItgTextWithLabel {
  ItgTextDate({required String text, String? label, TextStyle? textStyle, String? align = 'left', Key? key})
      : super(
      text: jsonValueAsString(text, valueType: 'date'),
      label: label,
      textStyle: textStyle,
      align: align!,
      key: key
  );
}

class ItgTextNumber extends ItgTextWithLabel {
  ItgTextNumber({required String text, String? label, TextStyle? textStyle, String? align = 'left', Key? key})
      : super(
      text: text,
      label: label,
      textStyle: textStyle,
      align: align!,
      key: key
  );
}

class ItgTextML extends ItgTextWithLabel {
  ItgTextML(
      {required String text, String? label, TextStyle? textStyle, String? align = 'left', Key? key})
      : super(
    // text: getContentFromSaved(text)['content']!,
      text: text,
      label: label,
      textStyle: textStyle,
      align: align!,
      key: key
  );
}
