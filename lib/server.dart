import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  final server = await createServer();
  print('Server started at: ${server.address} on port ${server.port}');
}

Future<HttpServer> createServer() async {
  final address = InternetAddress.loopbackIPv4;
  const port = 4040;
  return await HttpServer.bind(address, port);
}

Future<void> handleRequest(HttpServer server) async {
  await for (HttpRequest request in server) {
    switch (request.method) {
      case 'GET':
        handleGet(request);
        break;
      case 'POST':
        handlePost(request);
        break;
      default:
        handleDefault(request);
    }
  }
}

String stringStorage = 'Hi from server on Dart';

void handleGet(HttpRequest request) => request.response
  ..write(stringStorage)
  ..close();

Future<void> handlePost(HttpRequest request) async {
  stringStorage = await utf8.decoder.bind(request).join();
  request.response
    ..write('Accepted')
    ..statusCode = HttpStatus.ok;
}

void handleDefault(HttpRequest request) => request.response
  ..statusCode = HttpStatus.methodNotAllowed
  ..write('Unsupported request ${request.method}')
  ..close();
