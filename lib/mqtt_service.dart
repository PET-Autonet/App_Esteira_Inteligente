import 'dart:async';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  static final MqttService _instance = MqttService._internal();
  factory MqttService() => _instance;
  MqttService._internal();

  MqttServerClient? _client;
  bool _isConnected = false;
  
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messages => _messageController.stream;
  
  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionController.stream;
  
  bool get isConnected => _isConnected;

  // Para conexão segura (TLS/SSL) como HiveMQ
  Future<bool> connectSecure(String brokerUrl, int port, String username, String password) async {
    try {
      String clientId = 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
      
      _client = MqttServerClient.withPort(brokerUrl, clientId, port);
      _client!.logging(on: true);
      _client!.keepAlivePeriod = 60;
      _client!.autoReconnect = true;
      _client!.setProtocolV311();
      
      // Configuração para TLS/SSL - Apenas secure=true
      _client!.secure = true;  // Habilita TLS/SSL
      // O mqtt_client lida automaticamente com certificados
      
      _client!.onConnected = _onConnected;
      _client!.onDisconnected = _onDisconnected;
      _client!.onAutoReconnected = _onAutoReconnected;
      _client!.onSubscribed = _onSubscribed;
      
      // Configura mensagem de conexão com autenticação
      MqttConnectMessage connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .keepAliveFor(60)
          .authenticateAs(username, password);
      
      _client!.connectionMessage = connMessage;
      
      print('Conectando ao broker HiveMQ: $brokerUrl:$port');
      await _client!.connect();
      
      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        _isConnected = true;
        _connectionController.add(true);
        print('Conectado ao HiveMQ!');
        
        _client!.updates!.listen(_handleIncomingMessage);
        return true;
      } else {
        print('Falha na conexão: ${_client!.connectionStatus}');
        _connectionController.add(false);
        return false;
      }
    } catch (e) {
      print('Erro ao conectar: $e');
      _isConnected = false;
      _connectionController.add(false);
      return false;
    }
  }

  // Método para conexão não segura (porta 1883)
  Future<bool> connect(String brokerUrl, int port, {String? username, String? password}) async {
    try {
      String clientId = 'flutter_client_${DateTime.now().millisecondsSinceEpoch}';
      
      _client = MqttServerClient.withPort(brokerUrl, clientId, port);
      _client!.logging(on: true);
      _client!.keepAlivePeriod = 60;
      _client!.autoReconnect = true;
      _client!.setProtocolV311();
      
      _client!.onConnected = _onConnected;
      _client!.onDisconnected = _onDisconnected;
      _client!.onAutoReconnected = _onAutoReconnected;
      _client!.onSubscribed = _onSubscribed;
      
      MqttConnectMessage connMessage = MqttConnectMessage()
          .withClientIdentifier(clientId)
          .startClean()
          .keepAliveFor(60);
      
      if (username != null && password != null && username.isNotEmpty) {
        connMessage.authenticateAs(username, password);
      }
      
      _client!.connectionMessage = connMessage;
      
      print('Conectando ao broker: $brokerUrl:$port');
      await _client!.connect();
      
      if (_client!.connectionStatus!.state == MqttConnectionState.connected) {
        _isConnected = true;
        _connectionController.add(true);
        print('Conectado!');
        
        _client!.updates!.listen(_handleIncomingMessage);
        return true;
      } else {
        print('Falha na conexão: ${_client!.connectionStatus}');
        _connectionController.add(false);
        return false;
      }
    } catch (e) {
      print('Erro ao conectar: $e');
      _isConnected = false;
      _connectionController.add(false);
      return false;
    }
  }

  void _onConnected() {
    print('Cliente MQTT conectado');
    _isConnected = true;
    _connectionController.add(true);
  }
  
  void _onDisconnected() {
    print('Cliente MQTT desconectado');
    _isConnected = false;
    _connectionController.add(false);
  }
  
  void _onAutoReconnected() {
    print('Cliente MQTT reconectado automaticamente');
    _isConnected = true;
    _connectionController.add(true);
  }
  
  void _onSubscribed(String topic) {
    print('Inscrito no tópico: $topic');
  }
  
  void _handleIncomingMessage(List<MqttReceivedMessage<MqttMessage>> messages) {
    for (var message in messages) {
      final MqttPublishMessage publishMessage = message.payload as MqttPublishMessage;
      final String topic = message.topic;
      final String payload = MqttPublishPayload.bytesToStringAsString(publishMessage.payload.message);
      
      print('Mensagem recebida - Tópico: $topic, Payload: $payload');
      
      _messageController.add({
        'topic': topic,
        'payload': payload,
        'timestamp': DateTime.now(),
      });
    }
  }
  
  void subscribe(String topic, {MqttQos qos = MqttQos.atLeastOnce}) {
    if (_isConnected && _client != null) {
      print('Inscrevendo no tópico: $topic');
      _client!.subscribe(topic, qos);
    } else {
      print('Não é possível inscrever: cliente não conectado');
    }
  }
  
  void unsubscribe(String topic) {
    if (_isConnected && _client != null) {
      print('Cancelando inscrição do tópico: $topic');
      _client!.unsubscribe(topic);
    }
  }
  
  void publish(String topic, String message, {MqttQos qos = MqttQos.atLeastOnce}) {
    if (_isConnected && _client != null) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      print('Publicando mensagem - Tópico: $topic, Mensagem: $message');
      _client!.publishMessage(topic, qos, builder.payload!);
    } else {
      print('Não é possível publicar: cliente não conectado');
    }
  }
  
  void disconnect() {
    if (_client != null) {
      _client!.disconnect();
      _isConnected = false;
      _connectionController.add(false);
    }
  }
  
  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
  }
}