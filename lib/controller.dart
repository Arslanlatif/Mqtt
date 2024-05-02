// ignore_for_file: avoid_print

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Controller {
  late MqttServerClient client;
  final String serverUrl;
  final String serverId;
  bool connected = false;
  String subscribedTopic = "";

  Controller({required this.serverId, required this.serverUrl});

  Future<void> connectToBroker() async {
    client = MqttServerClient(serverId, serverUrl);

    try {
      await client.connect();
      connected = true;
    } catch (e) {
      print('Error connecting to broker: $e');
    }
  }

  void disconnect() {
    if (connected) {
      client.disconnect();
      connected = false;
      subscribedTopic = "";
    }
  }

  void subscribe(String topic) {
    if (topic.isNotEmpty) {
      if (connected) {
        client.subscribe(topic, MqttQos.atLeastOnce);
        subscribedTopic = topic;
      } else {
        print("Not connected to broker, cannot subscribe!");
      }
    }
  }

  void unsubscribe() {
    if (subscribedTopic.isNotEmpty) {
      if (connected) {
        client.unsubscribe(subscribedTopic);
        subscribedTopic = "";
      } else {
        print("Not connected to broker, cannot unsubscribe!");
      }
    }
  }

  void publish({required String topic, required String message}) {
    if (message.isNotEmpty && connected && topic.isNotEmpty) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      final payload = builder.payload;

      if (payload != null) {
        client.publishMessage(topic, MqttQos.atLeastOnce, payload);
        print("Published message '$message' to topic '$topic'");
      } else {
        print("Error creating payload. Cannot publish!");
      }
    } else {
      print("Not connected to broker, cannot publish!");
    }
  }
}
