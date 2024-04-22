import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color textColor;
  final TextAlign textAlign;

  const CommonText(
      {super.key,
        this.text = "",
        this.fontSize = 14,
        this.fontWeight = FontWeight.normal,
        this.textColor = Colors.black,
        this.textAlign = TextAlign.center
        ,});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight,
        fontSize: fontSize,
        color: textColor,
      ),
      textAlign: textAlign,
    );
  }
}
