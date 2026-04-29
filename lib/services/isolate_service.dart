// ============================================================
// FILE: lib/services/isolate_service.dart
// CHỨC NĂNG: Xử lý các tác vụ nặng trong Isolate riêng biệt
//            - Tính factorial bằng compute()
//            - Giao tiếp giữa 2 isolate qua SendPort
// ============================================================

import 'dart:isolate';
import 'dart:math';
import 'package:flutter/foundation.dart';

// ============================================================
// TASK 1: FACTORIAL DÙNG compute()
// ============================================================

/// Hàm tính factorial - PHẢI là top-level function (không phải method)
/// vì compute() cần serialize hàm này để gửi sang isolate khác
Map<String, dynamic> calculateFactorial(int n) {
  // Dùng BigInt để xử lý số cực lớn (30000! có hơn 100,000 chữ số)
  BigInt result = BigInt.one;

  // Tính n! = 1 × 2 × 3 × ... × n
  for (int i = 2; i <= n; i++) {
    result *= BigInt.from(i);
  }

  // Chuyển kết quả sang String để có thể truyền qua isolate
  final resultStr = result.toString();

  return {
    'input': n,
    'digitCount': resultStr.length,                    // Số chữ số
    'firstDigits': resultStr.substring(0, min(15, resultStr.length)), // 15 chữ số đầu
    'lastDigits': resultStr.length > 15
        ? resultStr.substring(resultStr.length - 10)    // 10 chữ số cuối
        : resultStr,
  };
}

/// Service class cho Isolate Task 1
class IsolateService {
  /// Tính factorial của n dùng compute()
  /// compute() tự động chạy trong Isolate riêng, không block UI
  static Future<Map<String, dynamic>> computeFactorial(int n) async {
    // compute() nhận vào:
    // 1. Top-level function cần chạy trong isolate
    // 2. Tham số truyền vào hàm đó
    return await compute(calculateFactorial, n);
  }
}

// ============================================================
// TASK 2: ISOLATE GIAO TIẾP QUA SENDPORT
// Challenge: Spawn isolate, gửi số random mỗi giây,
//            cộng dồn, dừng khi > 100
// ============================================================

/// Message để giao tiếp giữa main isolate và worker isolate
class IsolateMessage {
  final String type; // 'setup', 'number', 'stop', 'done'
  final dynamic data;

  IsolateMessage({required this.type, this.data});
}

/// Hàm chạy trong worker isolate (top-level function)
/// Nhận SendPort để gửi số về main isolate
Future<void> workerIsolateEntry(SendPort sendPort) async {
  final random = Random();

  // Tạo ReceivePort trong worker để nhận lệnh stop từ main
  final workerReceivePort = ReceivePort();

  // Gửi SendPort của worker về main isolate để main có thể gửi lệnh stop
  sendPort.send(IsolateMessage(
    type: 'setup',
    data: workerReceivePort.sendPort,
  ));

  bool running = true;

  // Lắng nghe lệnh stop từ main isolate
  workerReceivePort.listen((message) {
    if (message is IsolateMessage && message.type == 'stop') {
      running = false;
    }
  });

  // Gửi số random mỗi giây cho đến khi nhận lệnh stop
  while (running) {
    await Future.delayed(const Duration(seconds: 1));

    if (!running) break;

    // Tạo số random từ 1 đến 30
    final randomNumber = random.nextInt(30) + 1;
    sendPort.send(IsolateMessage(type: 'number', data: randomNumber));
  }

  // Gửi tín hiệu đã dừng và exit isolate
  sendPort.send(IsolateMessage(type: 'done', data: null));
  Isolate.exit(); // Thoát isolate gracefully
}

/// Manager class để quản lý Task 2
class IsolateManager {
  Isolate? _isolate;
  SendPort? _workerSendPort;
  ReceivePort? _mainReceivePort;

  /// Khởi động isolate và bắt đầu nhận số random
  Future<Stream<IsolateMessage>> startWorker() async {
    // Tạo ReceivePort trong main isolate để nhận message từ worker
    _mainReceivePort = ReceivePort();

    // Spawn isolate mới chạy hàm workerIsolateEntry
    _isolate = await Isolate.spawn(
      workerIsolateEntry,
      _mainReceivePort!.sendPort,
    );

    // Tạo StreamController để phát events từ isolate worker
    return _mainReceivePort!.cast<IsolateMessage>();
  }

  /// Gửi lệnh stop đến worker isolate
  void stopWorker() {
    if (_workerSendPort != null) {
      _workerSendPort!.send(IsolateMessage(type: 'stop'));
    }
  }

  /// Lưu lại SendPort của worker (nhận được sau khi setup)
  void setWorkerSendPort(SendPort port) {
    _workerSendPort = port;
  }

  /// Dọn dẹp tài nguyên
  void dispose() {
    _isolate?.kill(priority: Isolate.immediate);
    _mainReceivePort?.close();
    _isolate = null;
    _mainReceivePort = null;
    _workerSendPort = null;
  }
}
