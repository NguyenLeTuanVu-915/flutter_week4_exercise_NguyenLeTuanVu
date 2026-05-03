import 'package:flutter/material.dart';

enum AsyncStatus {
  idle,
  loading,
  success,
  error,
}

class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String avatarUrl;
  final DateTime joinDate;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatarUrl,
    required this.joinDate,
  });
}

class AsyncScreen extends StatefulWidget {
  const AsyncScreen({super.key});

  @override
  State<AsyncScreen> createState() => _AsyncScreenState();
}

class _AsyncScreenState extends State<AsyncScreen>
    with SingleTickerProviderStateMixin {
  AsyncStatus _status = AsyncStatus.idle;

  UserModel? _user;

  final List<_LogEntry> _logs = [];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _addLog(String message, {Color color = const Color(0xFF333333)}) {
    setState(() {
      _logs.add(_LogEntry(
        message: message,
        time: DateTime.now(),
        color: color,
      ));
    });
  }

  Future<UserModel> _fetchUser() async {
    await Future.delayed(const Duration(seconds: 3));

    return UserModel(
      id: 1001,
      name: 'Nguyễn Văn An',
      email: 'nguyenvanan@company.com',
      role: 'Senior Flutter Developer',
      avatarUrl: 'https://placeholder.com/avatar',
      joinDate: DateTime(2022, 6, 15),
    );
  }

  Future<void> _loadUser() async {
    setState(() {
      _status = AsyncStatus.loading;
      _user = null;
      _logs.clear();
    });

    _addLog('Bắt đầu tải dữ liệu...', color: const Color(0xFF6C63FF));
    _addLog('Đang kết nối server...', color: const Color(0xFF9C27B0));

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _status == AsyncStatus.loading) {
        _addLog('Đã kết nối, đang nhận dữ liệu...', color: const Color(0xFF2196F3));
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && _status == AsyncStatus.loading) {
        _addLog('Đang xử lý response...', color: const Color(0xFFFF9800));
      }
    });

    try {
      final user = await _fetchUser();

      if (mounted) {
        setState(() {
          _user = user;
          _status = AsyncStatus.success;
        });
        _addLog('User loaded successfully!', color: Colors.green);
        _addLog('User: ${user.name}', color: Colors.green);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _status = AsyncStatus.error);
        _addLog('Lỗi: $e', color: Colors.red);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 4 - Async Programming'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildStatusCard(),
            const SizedBox(height: 16),

            if (_user != null) ...[
              _buildUserCard(),
              const SizedBox(height: 16),
            ],

            if (_logs.isNotEmpty) _buildLogCard(),
            const SizedBox(height: 16),

            _buildExplainCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildStatusIcon(),
            const SizedBox(height: 16),

            Text(
              _getStatusText(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _getStatusColor(),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getStatusSubtext(),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _status == AsyncStatus.loading ? null : _loadUser,
                icon: const Icon(Icons.person_search_rounded),
                label: Text(
                  _status == AsyncStatus.loading ? 'Đang tải...' : 'Load User',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (_status) {
      case AsyncStatus.idle:
        return const Icon(
          Icons.person_outline_rounded,
          size: 64,
          color: Colors.grey,
        );
      case AsyncStatus.loading:
        return AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (_, child) => Transform.scale(
            scale: _pulseAnimation.value,
            child: child,
          ),
          child: const SizedBox(
            width: 64,
            height: 64,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Color(0xFF9C27B0),
            ),
          ),
        );
      case AsyncStatus.success:
        return Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE8F5E9),
          ),
          child: const Icon(Icons.check_circle_rounded,
              size: 48, color: Colors.green),
        );
      case AsyncStatus.error:
        return const Icon(Icons.error_outline_rounded,
            size: 64, color: Colors.red);
    }
  }

  String _getStatusText() {
    switch (_status) {
      case AsyncStatus.idle:
        return 'Nhấn nút để tải user';
      case AsyncStatus.loading:
        return 'Loading user...';
      case AsyncStatus.success:
        return 'User loaded successfully!';
      case AsyncStatus.error:
        return 'Tải thất bại!';
    }
  }

  String _getStatusSubtext() {
    switch (_status) {
      case AsyncStatus.idle:
        return 'Demo async/await với Future.delayed 3 giây';
      case AsyncStatus.loading:
        return 'Đang gọi API... (mô phỏng 3 giây)';
      case AsyncStatus.success:
        return 'Dữ liệu đã tải xong sau 3 giây';
      case AsyncStatus.error:
        return 'Đã xảy ra lỗi trong quá trình tải';
    }
  }

  Color _getStatusColor() {
    switch (_status) {
      case AsyncStatus.idle:
        return Colors.grey;
      case AsyncStatus.loading:
        return const Color(0xFF9C27B0);
      case AsyncStatus.success:
        return Colors.green;
      case AsyncStatus.error:
        return Colors.red;
    }
  }

  Widget _buildUserCard() {
    final user = _user!;
    return Card(
      color: const Color(0xFFE8F5E9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_rounded, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Thông tin User',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const Divider(),
            _userInfoRow('ID', '#${user.id}'),
            _userInfoRow('Tên', user.name),
            _userInfoRow('Email', user.email),
            _userInfoRow('Vai trò', user.role),
            _userInfoRow(
              'Ngày tham gia',
              '${user.joinDate.day}/${user.joinDate.month}/${user.joinDate.year}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _userInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.terminal_rounded, color: Color(0xFF333333)),
                SizedBox(width: 8),
                Text(
                  'Console Log',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _logs.map((log) {
                  final h = log.time.hour.toString().padLeft(2, '0');
                  final m = log.time.minute.toString().padLeft(2, '0');
                  final s = log.time.second.toString().padLeft(2, '0');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text(
                      '[$h:$m:$s] ${log.message}',
                      style: TextStyle(
                        color: log.color,
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExplainCard() {
    return Card(
      color: const Color(0xFFF3E5F5),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded,
                    color: Color(0xFF9C27B0)),
                SizedBox(width: 8),
                Text(
                  'Giải thích code',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9C27B0),
                  ),
                ),
              ],
            ),
            const Divider(),
            _codeExplain('Future<T>', 'Đại diện cho giá trị sẽ có trong tương lai'),
            _codeExplain('async', 'Đánh dấu hàm là bất đồng bộ'),
            _codeExplain('await', 'Chờ Future hoàn thành mà không block UI'),
            _codeExplain('Future.delayed()', 'Tạo delay giả lập (3 giây trong bài này)'),
          ],
        ),
      ),
    );
  }

  Widget _codeExplain(String keyword, String explain) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              keyword,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(explain,
                style: const TextStyle(fontSize: 12, color: Color(0xFF555555))),
          ),
        ],
      ),
    );
  }
}

class _LogEntry {
  final String message;
  final DateTime time;
  final Color color;

  _LogEntry({
    required this.message,
    required this.time,
    required this.color,
  });
}
