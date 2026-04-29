// ============================================================
// FILE: lib/widgets/contact_item.dart
// CHỨC NĂNG: Widget hiển thị một contact item trong ListView
// ============================================================

import 'package:flutter/material.dart';

/// Model dữ liệu cho một contact
class Contact {
  final String name;
  final String phone;
  final String email;
  final String department;
  final Color avatarColor;
  final bool isOnline;

  const Contact({
    required this.name,
    required this.phone,
    required this.email,
    required this.department,
    required this.avatarColor,
    this.isOnline = false,
  });

  /// Lấy chữ cái đầu của tên để hiển thị avatar
  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}

/// Widget hiển thị một contact trong danh sách
class ContactItem extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const ContactItem({
    super.key,
    required this.contact,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // === Avatar Placeholder ===
              _buildAvatar(),
              const SizedBox(width: 14),

              // === Thông tin contact ===
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tên contact
                    Text(
                      contact.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Số điện thoại
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 13,
                          color: Color(0xFF888888),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          contact.phone,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    // Email
                    Row(
                      children: [
                        const Icon(
                          Icons.email_outlined,
                          size: 13,
                          color: Color(0xFF888888),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            contact.email,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF666666),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Department badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: contact.avatarColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        contact.department,
                        style: TextStyle(
                          fontSize: 10,
                          color: contact.avatarColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // === Nút gọi điện ===
              IconButton(
                onPressed: () {
                  // Trong app thật, sẽ mở dialer
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gọi cho ${contact.name}...'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                icon: Icon(
                  Icons.call_rounded,
                  color: contact.avatarColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Xây dựng avatar placeholder với chữ cái đầu
  Widget _buildAvatar() {
    return Stack(
      children: [
        // Vòng tròn avatar
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                contact.avatarColor,
                contact.avatarColor.withValues(alpha: 0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: contact.avatarColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // Hiển thị chữ cái đầu của tên (initials)
          child: Center(
            child: Text(
              contact.initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Chấm trạng thái online/offline
        Positioned(
          bottom: 2,
          right: 2,
          child: Container(
            width: 13,
            height: 13,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: contact.isOnline ? Colors.green : Colors.grey,
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
