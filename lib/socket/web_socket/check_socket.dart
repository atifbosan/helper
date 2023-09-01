import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebsocketDemo extends StatefulWidget {
  const WebsocketDemo({Key? key}) : super(key: key);
  @override
  State<WebsocketDemo> createState() => _WebsocketDemoState();
}

class _WebsocketDemoState extends State<WebsocketDemo> {
  List<String> messages = [];
  TextEditingController _controller = TextEditingController();
  String btcUsdtPrice = "0";
  String btcExchangeRate = "0";
  final channel2 = IOWebSocketChannel.connect('wss://ws.postman-echo.com/raw');
  final channel = IOWebSocketChannel.connect(
      'wss://stream.binance.com:9443/ws/btcusdt@trade');
  @override
  void initState() {
    super.initState();
    streamListener2();
    streamListener();
  }

  streamListener() {
    channel.stream.listen((data) {
      // print(data);
      // channel.sink.add('received!');
      // channel.sink.close(status.goingAway);
      Map getData = jsonDecode(data);
      setState(() {
        //  = getData['p'];
        //  messages.add(getData['messages'])
        btcUsdtPrice = getData['p'];
        btcExchangeRate = getData['E'].toString();
      });
      // print(getData['p']);
    });
  }

  streamListener2() {
    channel2.stream.listen((data) {
      print("Channel: Check Channel Connected: ${channel2.protocol}");
      print("Channel: Check Channel Connected: ${channel2.ready}");
      print('_WebsocketDemoState.streamListener2: $data');
      // channel.sink.add('received!');
      // channel.sink.close(status.goingAway);
      Map getData = jsonDecode(data);
      //  setState(() {
      // messages.add(getData['message']);
      setMessage(getData['message']);
      // });
      // print(getData['p']);
    });
  }

  sendMessage(String msg) {
    try {
      print("Mesage send: $msg");

      ///  setMessage(msg);
      channel2.sink.add({
        "message": msg,
      });
    } catch (e) {
      print('_WebsocketDemoState.sendMessage: ${e}');
    }
  }

  setMessage(String msg) {
    setState(() {
      messages.add(msg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _controller,
              decoration: InputDecoration(hintText: "Send Message"),
            ),
            MaterialButton(
              onPressed: () {
                sendMessage(_controller.text);
              },
              child: Text("Send"),
            ),
            Flexible(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return Text(messages[index]);
                  }),
            ),
            Text(
              "Web Socket",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                btcUsdtPrice + "\n" + btcExchangeRate,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 250, 194, 25),
                    fontSize: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
