import 'package:flutter/material.dart';
import 'package:teste1/app_controller.dart';
import 'package:teste1/widgets/button_pressed.dart';
import 'package:teste1/widgets/generic_box.dart';
import 'package:teste1/widgets/generic_text.dart';
import 'package:teste1/widgets/custom_switcher.dart';
import 'package:teste1/mqtt_service.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  late String nome = "Nenhuma";
  String status = "Desconectado";

  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final MqttService _mqttService = MqttService();
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    _portController.text = "1883";

    _mqttService.connectionStatus.listen((isConnected) {
      setState(() {
        status = isConnected ? "Conectado" : "Desconectado";
        _isConnecting = false;
      });
    });

    _mqttService.messages.listen((message) {
      print("Mensagem recebida: ${message['payload']} do tópico: ${message['topic']}");
    });
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    _mqttService.dispose();
    super.dispose();
  }

  Future<void> _connectToBroker() async {
    final String brokerUrl = 'c7b73935d5e347138edfe8774f66e3fe.s1.eu.hivemq.cloud';
    final int port = 8883;
    final String username = _userController.text.trim();
    final String password = _passController.text.trim();

    if (username.isEmpty) {
      _showSnackBar('Por favor, insira o usuário e a senha');
      return;
    }

    setState(() {
      _isConnecting = true;
      status = "Conectando...";
    });

    bool success = await _mqttService.connectSecure(brokerUrl, port, username, password);

      if (success) {
    _showSnackBar('Conectado ao HiveMQ!');
    _mqttService.subscribe('esteira/comandos');
    _mqttService.subscribe('esteira/status');
    } else {
      _showSnackBar('Falha ao conectar ao broker!');
      setState(() {
        status = "Desconectado";
      });
    }
  }

  void _disconnect() {
    _mqttService.disconnect();
    _showSnackBar('Desconectado do broker');
  }

  void _sendToolCommand(String toolName) {
    if (!_mqttService.isConnected) {
      _showSnackBar('Conecte-se ao broker primeiro!');
      return;
    }

    _mqttService.publish('esteira/ferramenta', toolName);
    _showSnackBar('Comando enviado: $toolName');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

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
            // Container da ferramenta selecionada
            Container(
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
                )]
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
            ),
            SizedBox(height: 15),
            
            // Linha com dois botões
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
                        this.nome = "Chave de Fenda";
                      });
                      _sendToolCommand('Chave de Fenda');
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
                      _sendToolCommand('Alicate Grifo');
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            
            // Botão Chave Phillips
            ButtonPressed(
              child: GenericBox(
                child: GenericText(text: "Chave Phillips")
              ),
              onPressed: () {
                setState(() {
                  this.nome = "Chave Phillips";
                });
                _sendToolCommand('Chave Phillips');
              },
            ),
            SizedBox(height: 15),
            
            // Status da conexão
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
                    GenericText(text: 'Status da conexão'),
                    GenericText(text: _isConnecting ? "Conectando..." : status)
                  ],
                ),
              ),
            ),
            SizedBox(height: 15),
            
            // Card de conexão
            Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                
                  children: [
                    TextField(
                      controller: _ipController,
                      enabled: !_mqttService.isConnected && !_isConnecting,
                      decoration: InputDecoration(
                        labelText: "Endereço do Broker",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _portController,
                      enabled: !_mqttService.isConnected && !_isConnecting,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Porta do Broker",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                    controller: _userController,
                    enabled: !_mqttService.isConnected && !_isConnecting,
                    decoration: InputDecoration(
                      labelText: "Usuário",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _passController,
                    enabled: !_mqttService.isConnected && !_isConnecting,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Senha",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: (_mqttService.isConnected || _isConnecting) ? null : _connectToBroker,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppController.instance.isDarkTheme ? Colors.lightGreen : Colors.green,
                              minimumSize: Size(double.infinity, 40)
                            ),
                            child: GenericText(text: "Conectar"),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _mqttService.isConnected ? _disconnect : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(double.infinity, 40)
                            ),
                            child: GenericText(text: "Desconectar"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}