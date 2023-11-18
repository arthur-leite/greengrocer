import 'package:flutter/material.dart';
import 'package:greengrocer/src/config/custom_colors.dart';
import 'package:greengrocer/src/pages/common_widgets/app_name_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      // Background Gradient
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CustomColors.customSwatchColor.shade900,
              CustomColors.customSwatchColor.shade200,
            ],
          ),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Nome do App
            AppNameWidget(
              mainTitleColor: Colors.white,
              titleFontSize: 35,
            ),

            SizedBox(
              height: 10,
            ),

            // Load
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
