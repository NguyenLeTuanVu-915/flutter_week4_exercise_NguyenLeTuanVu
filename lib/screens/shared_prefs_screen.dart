import 'package:flutter/material.dart';
import '../services/shared_prefs_service.dart';

class SharedPrefsScreen extends StatefulWidget {
  const SharedPrefsScreen({super.key});

  @override
  State<SharedPrefsScreen> createState() => _SharedPrefsScreenState();
}

class _SharedPrefsScreenState extends State<SharedPrefsScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Map<String, String?> _savedData = {};

  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final data = await SharedPrefsService.getAllUserData();
    if (!mounted) return;
    setState(() {
      _savedData = data;
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final success = await SharedPrefsService.saveUserData(
      name: _nameController.text.trim(),
      age: _ageController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (success) {
      await _loadData();
      if (mounted) {
        _showSnackBar('Dữ liệu đã được lưu thành công!', Colors.green);
      }
    } else {
      if (mounted) {
        _showSnackBar('Lưu thất bại, vui lòng thử lại', Colors.red);
      }
    }

    setState(() => _isSaving = false);
  }

  Future<void> _clearData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa tất cả dữ liệu đã lưu?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await SharedPrefsService.clearAllData();
      await _loadData();
      _nameController.clear();
      _ageController.clear();
      _emailController.clear();
      if (mounted) {
        _showSnackBar('Đã xóa tất cả dữ liệu', Colors.orange);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatTimestamp(String? iso) {
    if (iso == null) return 'Chưa có';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/'
          '${dt.month.toString().padLeft(2, '0')}/'
          '${dt.year} '
          '${dt.hour.toString().padLeft(2, '0')}:'
          '${dt.minute.toString().padLeft(2, '0')}:'
          '${dt.second.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 3 - Shared Preferences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildInputSection(),
            const SizedBox(height: 20),
            _buildSavedDataSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.edit_rounded, color: Color(0xFFFF9800), size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Nhập thông tin',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF222222),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration(
                  'Họ và tên *',
                  Icons.person_outline_rounded,
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Vui lòng nhập tên' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _ageController,
                decoration: _inputDecoration(
                  'Tuổi (tùy chọn)',
                  Icons.cake_outlined,
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    final age = int.tryParse(v);
                    if (age == null || age < 1 || age > 150) {
                      return 'Tuổi không hợp lệ (1-150)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration(
                  'Email (tùy chọn)',
                  Icons.email_outlined,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v != null && v.isNotEmpty) {
                    if (!v.contains('@') || !v.contains('.')) {
                      return 'Email không hợp lệ';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _isSaving ? null : _saveData,
                      icon: _isSaving
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_rounded),
                      label: Text(_isSaving ? 'Đang lưu...' : 'Save Name'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _loadData,
                      icon: const Icon(Icons.visibility_rounded),
                      label: const Text('Show'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Color(0xFF6C63FF)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedDataSection() {
    final hasData = _savedData['name'] != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage_rounded,
                    color: Color(0xFF6C63FF), size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Dữ liệu đã lưu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF222222),
                  ),
                ),
                const Spacer(),
                if (hasData)
                  TextButton.icon(
                    onPressed: _clearData,
                    icon: const Icon(Icons.delete_outline_rounded,
                        color: Colors.red, size: 18),
                    label: const Text('Clear',
                        style: TextStyle(color: Colors.red)),
                    style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8)),
                  ),
              ],
            ),
            const Divider(height: 20),

            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (!hasData)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Icon(Icons.inbox_outlined, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Chưa có dữ liệu nào được lưu',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Nhập thông tin và nhấn "Save Name"',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            else
              Column(
                children: [
                  _dataRow(
                    Icons.person_rounded,
                    'Họ và tên',
                    _savedData['name'] ?? '-',
                    const Color(0xFF6C63FF),
                  ),
                  _dataRow(
                    Icons.cake_rounded,
                    'Tuổi',
                    _savedData['age'] ?? 'Không có',
                    const Color(0xFFFF9800),
                  ),
                  _dataRow(
                    Icons.email_rounded,
                    'Email',
                    _savedData['email'] ?? 'Không có',
                    const Color(0xFF4CAF50),
                  ),
                  _dataRow(
                    Icons.access_time_rounded,
                    'Lần lưu cuối',
                    _formatTimestamp(_savedData['timestamp']),
                    const Color(0xFF9C27B0),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF333333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
      ),
      filled: true,
      fillColor: const Color(0xFFFAFAFA),
    );
  }
}
