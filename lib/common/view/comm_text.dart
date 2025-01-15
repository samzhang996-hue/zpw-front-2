// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:zpw/common/style.dart';

class CommText extends StatelessWidget {
  String? text;
  Color textColor;
  double fontSize;
  TextStyle? textStyle;
  FontWeight fontWeight;
  int maxLines;
  TextOverflow overTextFlow;
  FontStyle? fontStyle;
  StrutStyle? strutStyle;
  TextOverflow? overFlow;
  TextAlign? textAlign;
  double wordSpacing;
  double letterSpacing;
  CommText(
      {Key? key,
      @required this.text,
      this.letterSpacing = 0.0,
      this.textColor = Colors.black,
      this.fontSize = 16,
      this.fontWeight = TKFontWeight.normal,
      this.textStyle,
      this.maxLines = 100,
      this.fontStyle = FontStyle.normal,
      this.overTextFlow = TextOverflow.ellipsis,
      this.strutStyle,
      this.textAlign,
      this.wordSpacing = 1.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text ?? '',
      textScaler: const TextScaler.linear(1),
      style: textStyle ??
          TextStyle(
              color: textColor,
              letterSpacing: letterSpacing,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
              fontFamily: "VerdanaPro",
              overflow: TextOverflow.clip,
              wordSpacing: wordSpacing),
      maxLines: maxLines,
      overflow: overFlow ?? TextOverflow.ellipsis,
      strutStyle: strutStyle ??
          StrutStyle(
              fontStyle: fontStyle, fontWeight: fontWeight, fontSize: fontSize),
      textAlign: textAlign ?? TextAlign.left,
    );
  }
}

class TKTextGradient extends StatelessWidget {
  String text;
  double fontSize;
  TextStyle? textStyle;
  FontWeight fontWeight;
  int maxLines;
  TextOverflow overTextFlow;
  FontStyle? fontStyle;
  StrutStyle? strutStyle;
  TextOverflow? overFlow;
  TextAlign? textAlign;
  List<Color>? colors;
  AlignmentGeometry? alignment;
  TKTextGradient(
      {Key? key,
      this.text = "",
      this.colors,
      this.fontSize = 16,
      this.fontWeight = TKFontWeight.normal,
      this.textStyle,
      this.maxLines = 100,
      this.fontStyle = FontStyle.normal,
      this.overTextFlow = TextOverflow.ellipsis,
      this.strutStyle,
      this.textAlign,
      this.alignment})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: colors ?? [const Color(0xffC0F038), const Color(0xff82AE05)],
        ).createShader(Offset.zero & bounds.size);
      },
      blendMode: BlendMode.srcATop,
      child: Container(
        alignment: alignment ?? Alignment.center,
        child: CommText(
          text: text = "",
          textStyle: textStyle ?? const TextStyle(),
          fontSize: fontSize,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          strutStyle: strutStyle,
          textAlign: textAlign,
          overTextFlow: overFlow ?? TextOverflow.ellipsis,
          maxLines: maxLines,
        ),
      ),
    );
  }
}
