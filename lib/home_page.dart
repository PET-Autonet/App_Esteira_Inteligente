import 'package:flutter/material.dart';
import 'package:teste1/app_controller.dart';
import 'package:teste1/widgets/button_pressed.dart';
import 'package:teste1/widgets/generic_box.dart';
import 'package:teste1/widgets/generic_text.dart';
import 'package:teste1/widgets/custom_switcher.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {
  late String nome = "Nenhuma";
  String status = "Desconectado";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text("Esteira Inteligente", style: TextStyle(
          color: AppController.instance.isDarkTheme ? Colors.white : Colors.black,
        )),
        backgroundColor: AppController.instance.isDarkTheme ? Colors.grey[900] : Colors.grey[300],
        actions: [
          Row(
            children: [
              Text(
                "Tema",
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: AppController.instance.isDarkTheme ? Colors.white : Colors.black,
              ),
              ),
              CustomSwitcher()
            ],
          )
          
        ],
      ),
      
      body: Padding(
      padding: EdgeInsets.only(top: 20, right: 5, left: 5),
      child: Column(
        children: [
          SizedBox(
            
            child: Container(
                height: 80,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  GenericText(text: "Ferramenta Selecionada:"),
                  GenericText(text: nome)
                ],
              )
              )
              )
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
                      Expanded(
                        child: ButtonPressed(
                          child: GenericBox(
                            child: GenericText(text: "Chave de Fenda")
                          ),
                          onPressed: () {
                            setState(() {
                              this.nome = "Chave de fenda";
                            });
                            
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ButtonPressed(
                          child: GenericBox(
                            child: GenericText(text: "Alicate Grifo")
                          ),
                          onPressed: () {
                            setState(() {
                              this.nome = "Alicate Grifo";
                            });
                            
                          },
                        ),
                      ),],
                      ),
                      SizedBox(height: 15),
                      ButtonPressed(
                        child: GenericBox(
                          child: GenericText(text: "Chave Phillips")
                        ),
                        onPressed: () {
                          setState(() {
                            this.nome = "Chave Phillips";
                          });
                          
                        },
                      ),
                      SizedBox(height: 15),
                      SizedBox(
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppController.instance.isDarkTheme ? Colors.lightGreen : Colors.green,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [BoxShadow(
                                  color: const Color.fromARGB(255, 45, 102, 46),
                                  offset: Offset(3, 3),
                                  blurRadius: 4,
                                  spreadRadius: 2,
                                  blurStyle: BlurStyle.normal,
                                )]
                              ),
                              child: Center(
                                child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GenericText(text: "Status da conexão:"),
                              GenericText(text: status)
                            ],
                          ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Card(
                        child: Padding(
                      padding: EdgeInsetsGeometry.all(8),
                      child: Column(
                        children: [
                        TextField(
                          onChanged: (text){
                            
                          },
                          decoration: InputDecoration(
                            labelText: "Endereço de IP",
                            border: OutlineInputBorder()
                          ),
                        ),
                        ElevatedButton(
                        
                          onPressed: () {
                            print("clicou!");
                          },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppController.instance.isDarkTheme ? Colors.lightGreen : Colors.green,
                              minimumSize: Size(double.infinity, 32)
                            ),
                            child: GenericText(text: "Conectar"),
                          
                          )
                      ],
                      )
                    ),
                  
                      )
                      
  
        ],
      ),
      ),
    );

  }




}

