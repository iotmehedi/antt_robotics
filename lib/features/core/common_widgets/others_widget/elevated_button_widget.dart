import 'package:flutter/material.dart';

import '../../../../core/routes/route_name.dart';
import '../../../../core/routes/router.dart';
import '../../../../core/utils/consts/textStyle.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final Color textColor;
  final double textFontSize, buttonWidth, buttonHeight;
  final FontWeight textFontWeight;
  final String buttonKeyWord;
  final Function callback;

   ElevatedButtonWidget({
    required this.buttonKeyWord,
    required this.textColor,
    required this.textFontSize,
    required this.textFontWeight,
    super.key,
    required this.buttonWidth,
    required this.buttonHeight, required this.callback,

  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        callback();
      },
      style: ElevatedButton.styleFrom(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
        minimumSize: Size(buttonWidth, buttonHeight),
      ),
      child: globalText2(
          text: buttonKeyWord,
          color: textColor,
          fontSize: textFontSize,
          fontWeight: textFontWeight),
      key: Key('${buttonKeyWord}'),
    );
  }
}
