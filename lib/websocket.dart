import 'dart:io';

void main() {
  // 웹 소켓 서버 포트 설정
  const int port = 4040;
  HttpServer.bind('localhost', port).then((HttpServer server) {
    print('WebSocket listening at ws://localhost:$port');
    server.listen((HttpRequest request) {
      if (request.uri.path == '/ws') {
        WebSocketTransformer.upgrade(request).then((WebSocket websocket) {
          websocket.listen((message) {
            print('Received: $message');
            // 받은 메시지를 브로드캐스트
            websocket.add('Echo: $message');
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
