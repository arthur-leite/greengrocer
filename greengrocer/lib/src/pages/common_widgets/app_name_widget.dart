import 'package:flutter/material.dart';
import 'package:greengrocer/src/config/custom_colors.dart';

class AppNameWidget extends StatelessWidget {
  final Color? mainTitleColor;
  final Color? subtitleColor;
  final double titleFontSize;

  const AppNameWidget(
      {super.key,
      this.mainTitleColor,
      this.subtitleColor,
      this.titleFontSize = 30});

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(fontSize: titleFontSize),
        children: [
          TextSpan(
            text: 'Green',
            style: TextStyle(
              color: mainTitleColor ?? CustomColors.customSwatchColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: 'Grocer',
            style: TextStyle(
                color: subtitleColor ?? CustomColors.customContrastColor,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
