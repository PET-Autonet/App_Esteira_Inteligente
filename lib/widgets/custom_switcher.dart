import 'package:flutter/material.dart';
import 'package:teste1/app_controller.dart';

class CustomSwitcher extends StatelessWidget {

  const CustomSwitcher({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Switch(
          value: AppController.instance.isDarkTheme,
          onChanged: (value) {
              AppController.instance.changeTheme();
          },
          );
  }
}