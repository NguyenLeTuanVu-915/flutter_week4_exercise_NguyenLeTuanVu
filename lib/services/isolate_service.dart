import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';

Map<String, dynamic> calculateFactorial(int n) {
  BigInt result = BigInt.one;

  for (int i = 2; i <= n; i++) {
    result *= BigInt.from(i);
  }

  final resultStr = result.toString();

  return {
    'input': n,
    'digitCount': resultStr.length,
    'firstDigits': resultStr.substring(0, min(15, resultStr.length)),
    'lastDigits': resultStr.length > 15
        ? resultStr.substring(resultStr.length - 10)
        : resultStr,
  };
}

class IsolateService {
  static Future<Map<String, dynamic>> computeFactorial(int n) async {
    return await compute(calculateFactorial, n);
  }
}

class IsolateMessage {
  final String type;
  final dynamic data;

  IsolateMessage({required this.type, this.data});
}

Future<void> workerIsolateEntry(SendPort sendPort) async {
  final random = Random();

  final workerReceivePort = ReceivePort();

  sendPort.send(IsolateMessage(
    type: 'setup',
    data: workerReceivePort.sendPort,
  ));

  bool running = true;

  workerReceivePort.listen((message) {
    if (message is IsolateMessage && message.type == 'stop') {
      running = false;
    }
  });

  while (running) {
    await Future.delayed(const Duration(seconds: 1));

    if (!running) break;

    final randomNumber = random.nextInt(30) + 1;
    sendPort.send(IsolateMessage(type: 'number', data: randomNumber));
  }

  sendPort.send(IsolateMessage(type: 'done', data: null));
  Isolate.exit();
}

class IsolateManager {
  Isolate? _isolate;
  SendPort? _workerSendPort;
  ReceivePort? _mainReceivePort;

  Future<Stream<IsolateMessage>> startWorker() async {
    _mainReceivePort = ReceivePort();
    _isolate = await Isolate.spawn(
      workerIsolateEntry,
      _mainReceivePort!.sendPort,
    );
    return _mainReceivePort!.cast<IsolateMessage>();
  }

  void stopWorker() {
    if (_workerSendPort != null) {
      _workerSendPort!.send(IsolateMessage(type: 'stop'));
    }
  }

  void setWorkerSendPort(SendPort port) {
    _workerSendPort = port;
  }

  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _mainReceivePort?.close();
    _isolate = null;
    _mainReceivePort = null;
    _workerSendPort = null;
  }
}
