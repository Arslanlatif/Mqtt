import 'package:flutter/material.dart';
import 'package:mqtt/controller.dart';
import 'package:mqtt/widget/button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController topicController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Controller controller =
      Controller(serverUrl: 'test.mosquitto.org', serverId: 'uniqueClientId');
  String publishedMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('HomeScreen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //! Button to connect
          button(
            onPressed: () {
              if (controller.connected) {
                controller.disconnect();
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('disconnected!')));
              } else {
                controller.connectToBroker();
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Connected!')));
              }
              setState(() {});
            },
            child: Text(controller.connected ? 'Disconnect' : 'Connect'),
          ),

          //! Enter topic
          TextFormField(
            controller: topicController,
            decoration: InputDecoration(
                hintText: 'Enter topic',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),

          //! Subscribe
          button(
              onPressed: () {
                final topic = topicController.text;
                if (topic.isNotEmpty) {
                  controller.subscribe(topic);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Subscribed!')));
                } else {
                  controller.unsubscribe();
                }
              },
              child: const Text('Subscribe')),

          //! Enter message for publishing
          TextFormField(
            controller: messageController,
            decoration: InputDecoration(
                hintText: 'Enter message for publishing',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),

          //! Publish message
          button(
              onPressed: () {
                final topic = topicController.text;
                final message = messageController.text;

                if (message.isNotEmpty && topic.isNotEmpty) {
                  controller.publish(topic: topic, message: message);
                  setState(() {
                    publishedMessage = message;
                  });
                  // messageController.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message published!')));
                }
              },
              child: const Text('Publish the entered message')),

          //!

          Chip(label: Text(publishedMessage))
        ],
      ),
    );
  }
}
