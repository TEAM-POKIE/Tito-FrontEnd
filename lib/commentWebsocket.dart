import 'dart:io';

import 'package:web_socket_channel/io.dart';

void main() async {
  final server = await HttpServer.bind(InternetAddress.anyIPv4, 4000);
  print('Listening on port 4000');

  server.transform(WebSocketTransformer()).listen(handleWebSocket);
}

void handleWebSocket(WebSocket socket) {
  final channel = IOWebSocketChannel(socket);

  print('New client connected');

  channel.stream.listen((message) {
    print('Received message: $message');
    channel.sink.add(message); // Echo the message back to the client
  }, onDone: () {
    print('Client disconnected');
  });
}
