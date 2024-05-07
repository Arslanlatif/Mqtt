// ignore_for_file: avoid_print

import 'dart:developer';

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
    client = MqttServerClient(serverUrl, serverId);
    client.port = 1883;

    try {
      await client.connect();
      connected = true;
      log('connected to broker');
    } catch (e) {
      log('Error connecting to broker: $e');
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
        log("Subscribed");
      } else {
        log("Not connected to broker, cannot subscribe!");
      }
    }
  }

  void unsubscribe() {
    if (subscribedTopic.isNotEmpty) {
      if (connected) {
        client.unsubscribe(subscribedTopic);
        subscribedTopic = "";
        log("Un-Subscribed");
      } else {
        log("Not connected to broker, cannot unsubscribe!");
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
        log("Published message '$message' to topic '$topic'");
      } else {
        log("Error creating payload. Cannot publish!");
      }
    } else {
      log("Not connected to broker, cannot publish!");
    }
  }
}
