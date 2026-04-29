// ============================================================
// FILE: lib/widgets/grid_item.dart
// CHỨC NĂNG: Widget hiển thị một item trong GridView
// ============================================================

import 'package:flutter/material.dart';

/// Widget hiển thị một ô trong GridView
class GridItem extends StatelessWidget {
  final int index;        // Số thứ tự item (bắt đầu từ 1)
  final Color color;      // Màu nền container
  final IconData icon;    // Icon hiển thị trong item

  const GridItem({
    super.key,
    required this.index,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Container bo góc với màu nền
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withValues(alpha: 0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon centered trong item
          Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(height: 8),
          // Label text "Item X"
          Text(
            'Item $index',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
