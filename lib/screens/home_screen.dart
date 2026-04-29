// ============================================================
// FILE: lib/screens/home_screen.dart
// CHỨC NĂNG: Màn hình chính - menu điều hướng đến các bài tập
// ============================================================

import 'package:flutter/material.dart';
import 'list_view_screen.dart';
import 'grid_view_screen.dart';
import 'shared_prefs_screen.dart';
import 'async_screen.dart';
import 'isolate_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Danh sách các bài tập để hiển thị menu
    final List<_MenuItem> menuItems = [
      _MenuItem(
        title: 'Exercise 1\nList View',
        subtitle: 'Danh sách contacts có thể cuộn',
        icon: Icons.list_alt_rounded,
        color: const Color(0xFF4CAF50),
        screen: const ListViewScreen(),
      ),
      _MenuItem(
        title: 'Exercise 2\nGrid View',
        subtitle: 'GridView.count & GridView.extent',
        icon: Icons.grid_view_rounded,
        color: const Color(0xFF2196F3),
        screen: const GridViewScreen(),
      ),
      _MenuItem(
        title: 'Exercise 3\nShared Preferences',
        subtitle: 'Lưu & đọc dữ liệu cục bộ',
        icon: Icons.save_rounded,
        color: const Color(0xFFFF9800),
        screen: const SharedPrefsScreen(),
      ),
      _MenuItem(
        title: 'Exercise 4\nAsync Programming',
        subtitle: 'Future, async/await demo',
        icon: Icons.access_time_rounded,
        color: const Color(0xFF9C27B0),
        screen: const AsyncScreen(),
      ),
      _MenuItem(
        title: 'Exercise 5\nIsolate',
        subtitle: 'Tính factorial & background isolate',
        icon: Icons.memory_rounded,
        color: const Color(0xFFF44336),
        screen: const IsolateScreen(),
      ),
    ];

    return Scaffold(
      // AppBar với tiêu đề
      appBar: AppBar(
        title: const Text('Week 4 Exercise'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.white24,
            height: 1,
          ),
        ),
      ),

      body: Container(
        // Gradient nền
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF5F3FF), Color(0xFFEEEBFF)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              _buildHeaderCard(),
              const SizedBox(height: 20),
              const Text(
                'Chọn bài tập:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 12),
              // Danh sách menu items
              Expanded(
                child: ListView.separated(
                  itemCount: menuItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _buildMenuCard(context, menuItems[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget header card hiển thị thông tin môn học
  Widget _buildHeaderCard() {
    return Card(
      color: const Color(0xFF6C63FF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 32),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Flutter Mobile Development',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Week 4 - ListView, GridView,\nSharedPrefs, Async & Isolate',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget card cho từng menu item
  Widget _buildMenuCard(BuildContext context, _MenuItem item) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Điều hướng đến màn hình tương ứng
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => item.screen),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.icon, color: item.color, size: 28),
              ),
              const SizedBox(width: 16),
              // Nội dung text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF888888),
                      ),
                    ),
                  ],
                ),
              ),
              // Mũi tên điều hướng
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: item.color,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Model dữ liệu cho menu item
class _MenuItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget screen;

  _MenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.screen,
  });
}
