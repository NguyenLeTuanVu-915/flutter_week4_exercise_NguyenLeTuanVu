// ============================================================
// FILE: lib/screens/isolate_screen.dart
// CHỨC NĂNG: Màn hình demo Isolate
//            - Task 1: Tính factorial 30000 dùng compute()
//            - Task 2: Background isolate gửi số random, cộng dồn đến >100
// ============================================================

import 'dart:async';
import 'dart:isolate';
import 'package:flutter/material.dart';
import '../services/isolate_service.dart';

class IsolateScreen extends StatefulWidget {
  const IsolateScreen({super.key});

  @override
  State<IsolateScreen> createState() => _IsolateScreenState();
}

class _IsolateScreenState extends State<IsolateScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 5 - Isolate'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.calculate_rounded), text: 'Task 1: Factorial'),
            Tab(icon: Icon(Icons.shuffle_rounded), text: 'Task 2: Random Sum'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Tab 1: Tính factorial
          _FactorialTab(),
          // Tab 2: Random number isolate
          _RandomSumTab(),
        ],
      ),
    );
  }
}

// ============================================================
// TAB 1: TÍNH FACTORIAL DÙNG compute()
// ============================================================
class _FactorialTab extends StatefulWidget {
  const _FactorialTab();

  @override
  State<_FactorialTab> createState() => _FactorialTabState();
}

class _FactorialTabState extends State<_FactorialTab> {
  bool _isCalculating = false;
  Map<String, dynamic>? _result;
  String? _error;
  int _selectedN = 30000;
  Duration? _duration;

  // Các lựa chọn giá trị n
  final List<int> _nOptions = [100, 1000, 5000, 10000, 30000];

  /// Tính factorial trong isolate riêng
  Future<void> _calculate() async {
    setState(() {
      _isCalculating = true;
      _result = null;
      _error = null;
    });

    final stopwatch = Stopwatch()..start();

    try {
      // Gọi compute() - chạy calculateFactorial trong isolate riêng
      // UI Thread KHÔNG bị block trong lúc này
      final result = await IsolateService.computeFactorial(_selectedN);

      stopwatch.stop();

      if (mounted) {
        setState(() {
          _result = result;
          _duration = stopwatch.elapsed;
          _isCalculating = false;
        });
      }
    } catch (e) {
      stopwatch.stop();
      if (mounted) {
        setState(() {
          _error = 'Lỗi: $e';
          _isCalculating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // === Chọn giá trị n ===
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chọn n để tính n!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nút chọn giá trị n
                  Wrap(
                    spacing: 8,
                    children: _nOptions.map((n) {
                      return ChoiceChip(
                        label: Text(n.toString()),
                        selected: _selectedN == n,
                        onSelected: (selected) {
                          if (selected) setState(() => _selectedN = n);
                        },
                        selectedColor: const Color(0xFFF44336),
                        labelStyle: TextStyle(
                          color: _selectedN == n ? Colors.white : null,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isCalculating ? null : _calculate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF44336),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      icon: _isCalculating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.play_circle_rounded),
                      label: Text(
                        _isCalculating
                            ? 'Đang tính trong isolate...'
                            : 'Tính $_selectedN!',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // === Loading indicator ===
          if (_isCalculating) _buildLoadingCard(),

          // === Hiển thị kết quả ===
          if (_result != null) _buildResultCard(),

          // === Hiển thị lỗi ===
          if (_error != null)
            Card(
              color: const Color(0xFFFFEBEE),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.red)),
              ),
            ),

          const SizedBox(height: 16),

          // === Giải thích compute() ===
          _buildComputeExplain(),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      color: const Color(0xFFFFEBEE),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircularProgressIndicator(color: Color(0xFFF44336)),
            const SizedBox(height: 16),
            Text(
              'Đang tính $_selectedN! trong Isolate...',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFFF44336)),
            ),
            const SizedBox(height: 8),
            const Text(
              '✅ UI vẫn responsive! Thử cuộn màn hình.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final result = _result!;
    return Card(
      color: const Color(0xFFFFEBEE),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFFF44336)),
                const SizedBox(width: 8),
                Text(
                  '${result['input']}! đã tính xong!',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF44336),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _resultRow('Số chữ số', '${result['digitCount']} chữ số'),
            _resultRow('15 chữ số đầu', '${result['firstDigits']}...'),
            _resultRow('10 chữ số cuối', '...${result['lastDigits']}'),
            if (_duration != null)
              _resultRow(
                'Thời gian tính',
                '${_duration!.inMilliseconds} ms (${(_duration!.inMilliseconds / 1000).toStringAsFixed(2)}s)',
              ),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 13, fontFamily: 'monospace'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComputeExplain() {
    return Card(
      color: const Color(0xFFFFF3E0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Color(0xFFFF9800)),
                SizedBox(width: 8),
                Text(
                  'Tại sao dùng compute()?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9800),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '• Tính 30000! là tác vụ cực nặng (CPU-bound)\n'
              '• Nếu chạy trên main thread → UI bị freeze\n'
              '• compute() tự động spawn Isolate riêng\n'
              '• Main thread (UI) vẫn chạy bình thường\n'
              '• Kết quả được trả về qua message passing',
              style: TextStyle(fontSize: 13, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// TAB 2: ISOLATE GIAO TIẾP - RANDOM SUM
// ============================================================
class _RandomSumTab extends StatefulWidget {
  const _RandomSumTab();

  @override
  State<_RandomSumTab> createState() => _RandomSumTabState();
}

class _RandomSumTabState extends State<_RandomSumTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Giữ state khi chuyển tab
  final IsolateManager _manager = IsolateManager();

  bool _isRunning = false;
  int _sum = 0;          // Tổng tích lũy
  final List<_NumberEvent> _events = []; // Lịch sử các số nhận được
  String _status = 'Nhấn Start để bắt đầu';
  bool _isDone = false;
  StreamSubscription? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    _manager.dispose();
    super.dispose();
  }

  /// Bắt đầu worker isolate
  Future<void> _startWorker() async {
    setState(() {
      _isRunning = true;
      _isDone = false;
      _sum = 0;
      _events.clear();
      _status = '🚀 Worker isolate đã được spawn...';
    });

    // Lấy stream từ worker isolate
    final stream = await _manager.startWorker();

    // Lắng nghe messages từ worker isolate
    _subscription = stream.listen(
      (message) {
        if (!mounted) return;

        switch (message.type) {
          case 'setup':
            // Nhận SendPort của worker để có thể gửi lệnh stop
            _manager.setWorkerSendPort(message.data as SendPort);
            setState(() => _status = '📡 Connected! Worker đang gửi số mỗi giây...');
            break;

          case 'number':
            // Nhận số random từ worker, cộng vào tổng
            final number = message.data as int;
            setState(() {
              _sum += number;
              _events.insert(0, _NumberEvent(number: number, sum: _sum));
              _status = '📥 Nhận số: $number | Tổng: $_sum';

              // Kiểm tra điều kiện dừng: tổng > 100
              if (_sum > 100) {
                _status = '🛑 Tổng ($_sum) > 100! Gửi lệnh STOP...';
                _manager.stopWorker();
              }
            });
            break;

          case 'done':
            // Worker đã dừng và exit
            setState(() {
              _isRunning = false;
              _isDone = true;
              _status = '✅ Worker isolate đã thoát gracefully (Isolate.exit())';
            });
            _subscription?.cancel();
            _manager.dispose();
            break;
        }
      },
      onError: (e) {
        setState(() {
          _isRunning = false;
          _status = '❌ Lỗi: $e';
        });
      },
    );
  }

  /// Dừng worker isolate thủ công
  void _stopWorker() {
    _manager.stopWorker();
    setState(() => _status = '🛑 Đang gửi lệnh STOP đến worker...');
  }

  /// Reset về trạng thái ban đầu
  void _reset() {
    _subscription?.cancel();
    _manager.dispose();
    setState(() {
      _isRunning = false;
      _isDone = false;
      _sum = 0;
      _events.clear();
      _status = 'Nhấn Start để bắt đầu';
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Bắt buộc khi dùng AutomaticKeepAliveClientMixin
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // === Tổng hiện tại + trạng thái ===
          _buildSumCard(),
          const SizedBox(height: 16),

          // === Các nút điều khiển ===
          _buildControlButtons(),
          const SizedBox(height: 16),

          // === Lịch sử số nhận được ===
          if (_events.isNotEmpty) _buildEventsCard(),

          const SizedBox(height: 16),

          // === Giải thích cơ chế ===
          _buildIsolateExplain(),
        ],
      ),
    );
  }

  Widget _buildSumCard() {
    final progress = (_sum / 100).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Tổng hiện tại
            Text(
              'Tổng tích lũy',
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 8),
            Text(
              '$_sum',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: _sum > 100
                    ? Colors.red
                    : _sum > 70
                        ? Colors.orange
                        : const Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 8),
            // Progress bar đến 100
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _sum > 100
                      ? Colors.red
                      : _sum > 70
                          ? Colors.orange
                          : const Color(0xFF6C63FF),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(_sum / 100 * 100).toStringAsFixed(0)}% (dừng khi > 100)',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            // Trạng thái
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _status,
                style: const TextStyle(fontSize: 12, color: Color(0xFF333333)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      children: [
        // Nút Start
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _isRunning ? null : _startWorker,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.play_arrow_rounded),
            label: const Text('Start'),
          ),
        ),
        const SizedBox(width: 8),
        // Nút Stop thủ công
        Expanded(
          child: ElevatedButton.icon(
            onPressed: (_isRunning && !_isDone) ? _stopWorker : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.stop_rounded),
            label: const Text('Stop'),
          ),
        ),
        const SizedBox(width: 8),
        // Nút Reset
        Expanded(
          child: ElevatedButton.icon(
            onPressed: (!_isRunning || _isDone) ? _reset : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Reset'),
          ),
        ),
      ],
    );
  }

  Widget _buildEventsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_long_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Lịch sử (${_events.length} lần nhận)',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Danh sách events (chỉ hiển thị 10 gần nhất)
            ...(_events.take(10).map((event) {
              return Container(
                margin: const EdgeInsets.only(bottom: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C63FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '+${event.number}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tổng: ${event.sum}',
                      style: const TextStyle(fontSize: 13),
                    ),
                    const Spacer(),
                    if (event.sum > 100)
                      const Text('🛑 STOP',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          )),
                  ],
                ),
              );
            })),
            if (_events.length > 10)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '... và ${_events.length - 10} lần trước đó',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIsolateExplain() {
    return Card(
      color: const Color(0xFFE8EAF6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.device_hub_rounded, color: Color(0xFF3F51B5)),
                SizedBox(width: 8),
                Text(
                  'Cơ chế hoạt động',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F51B5),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '1️⃣  Main isolate spawn Worker isolate\n'
              '2️⃣  Worker gửi SendPort về main (để main stop được)\n'
              '3️⃣  Worker gửi số random mỗi giây qua SendPort\n'
              '4️⃣  Main nhận số, cộng dồn vào tổng\n'
              '5️⃣  Khi tổng > 100, main gửi lệnh "stop" về worker\n'
              '6️⃣  Worker nhận lệnh stop, exit bằng Isolate.exit()',
              style: TextStyle(fontSize: 13, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}

/// Model lưu lịch sử mỗi lần nhận số
class _NumberEvent {
  final int number;
  final int sum;
  _NumberEvent({required this.number, required this.sum});
}
