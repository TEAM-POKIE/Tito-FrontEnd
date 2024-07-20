import 'dart:io';

void main() {
  const int port = 4040;
  HttpServer.bind(InternetAddress.anyIPv4, port).then((HttpServer server) {
    print('WebSocket listening at ws://0.0.0.0:$port');
    final Map<String, List<WebSocket>> chatRooms = {};

    server.listen((HttpRequest request) {
      if (request.uri.pathSegments.isNotEmpty &&
          request.uri.pathSegments[0] == 'ws') {
        final chatRoomId = request.uri.pathSegments[1];
        WebSocketTransformer.upgrade(request).then((WebSocket websocket) {
          if (!chatRooms.containsKey(chatRoomId)) {
            chatRooms[chatRoomId] = [];
          }
          chatRooms[chatRoomId]!.add(websocket);
          print('Client connected to $chatRoomId: ${websocket.hashCode}');

          websocket.listen((message) {
            print('Received in $chatRoomId: $message');
            for (var client in chatRooms[chatRoomId]!) {
              if (client != websocket) {
                client.add(message);
              }
            }
          }, onDone: () {
            chatRooms[chatRoomId]!.remove(websocket);
            print(
                'Client disconnected from $chatRoomId: ${websocket.hashCode}');
          });
        });
      } else {
        request.response
          ..statusCode = HttpStatus.forbidden
          ..write('WebSocket connections only')
          ..close();
      }
    });
  });
}
