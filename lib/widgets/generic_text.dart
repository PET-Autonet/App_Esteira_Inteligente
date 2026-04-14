import 'package:flutter/material.dart';
import 'package:teste1/app_controller.dart';

class GenericText extends StatelessWidget{
  
  final String text;
  const GenericText({
    super.key,
    required this.text,
  });
  


  @override
  Widget build(BuildContext context) {
    return Text(
    text,
    textAlign: TextAlign.center,
    style: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w900,
      color: AppController.instance.isDarkTheme ? Colors.white : Colors.black,
    )
  );
  }}