import 'package:flutter/material.dart';
import 'package:teste1/app_controller.dart';
// ignore: unused_import
import 'package:teste1/home_page.dart';

class AppWidget extends StatelessWidget{
  const AppWidget({super.key});

  
  @override
  Widget build(BuildContext context){
    return AnimatedBuilder(
      animation: AppController.instance,
      builder: (context, child){
        return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: AppController.instance.isDarkTheme ? Brightness.dark : Brightness.light
        ),
        home: HomePage(),
    );
    },);
  }
}
