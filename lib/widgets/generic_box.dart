import 'package:flutter/material.dart';
import 'package:teste1/app_controller.dart';

class GenericBox extends StatelessWidget {
  final Widget child;
  const GenericBox({
  super.key,
  required this.child,
  });
  

  @override
  Widget build(BuildContext context) {
    return Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppController.instance.isDarkTheme ? Colors.lightGreen : Colors.green,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [BoxShadow(
                    color: const Color.fromARGB(255, 45, 102, 46),
                    offset: Offset(3.0, 3.0),
                    blurRadius: 4.0,
                    spreadRadius: 2.0,
                    blurStyle: BlurStyle.normal,
          
                  ),
                  ]
                ),
              child: Center(
              child: child
              )
              );
  }
}