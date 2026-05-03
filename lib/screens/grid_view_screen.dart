import 'package:flutter/material.dart';
import '../widgets/grid_item.dart';

class GridViewScreen extends StatelessWidget {
  const GridViewScreen({super.key});

  static const List<Color> _colors = [
    Color(0xFF6C63FF), Color(0xFFFF6B9D), Color(0xFF4CAF50),
    Color(0xFFFF9800), Color(0xFF2196F3), Color(0xFF9C27B0),
    Color(0xFFF44336), Color(0xFF009688), Color(0xFFFF5722),
    Color(0xFF3F51B5), Color(0xFF795548), Color(0xFF00BCD4),
  ];

  static const List<IconData> _icons = [
    Icons.star_rounded,       Icons.favorite_rounded,    Icons.bolt_rounded,
    Icons.local_fire_department_rounded, Icons.diamond_rounded, Icons.celebration_rounded,
    Icons.rocket_launch_rounded, Icons.psychology_rounded, Icons.auto_awesome_rounded,
    Icons.emoji_events_rounded, Icons.public_rounded,    Icons.speed_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 - Grid View'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(
                'Column Grid',
                'GridView.count() - 3 cột cố định',
                Icons.grid_on_rounded,
                const Color(0xFF6C63FF),
              ),
              const SizedBox(height: 12),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.0,

                children: List.generate(12, (index) {
                  return GridItem(
                    index: index + 1,
                    color: _colors[index],
                    icon: _icons[index],
                  );
                }),
              ),

              const SizedBox(height: 32),

              _buildSectionTitle(
                'Responsive Grid',
                'GridView.extent() - độ rộng tối đa 150px',
                Icons.grid_view_rounded,
                const Color(0xFF2196F3),
              ),
              const SizedBox(height: 12),

              GridView.extent(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                maxCrossAxisExtent: 150,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,

                children: List.generate(12, (index) {
                  return GridItem(
                    index: index + 1,
                    color: _colors[(index + 3) % 12],
                    icon: _icons[(index + 6) % 12],
                  );
                }),
              ),

              const SizedBox(height: 16),

              _buildComparisonCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF222222),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Color(0xFF888888)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonCard() {
    return Card(
      color: const Color(0xFFF5F3FF),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.info_outline_rounded,
                    color: Color(0xFF6C63FF), size: 20),
                SizedBox(width: 8),
                Text(
                  'So sánh 2 loại GridView',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6C63FF),
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            _comparisonRow(
              'GridView.count()',
              'Số cột cố định. Thích hợp khi muốn layout nhất quán.',
              const Color(0xFF6C63FF),
            ),
            const SizedBox(height: 8),
            _comparisonRow(
              'GridView.extent()',
              'Kích thước ô cố định, số cột thay đổi theo màn hình. Thích hợp cho responsive.',
              const Color(0xFF2196F3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _comparisonRow(String title, String desc, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: color, fontSize: 13)),
              Text(desc,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF666666))),
            ],
          ),
        ),
      ],
    );
  }
}
