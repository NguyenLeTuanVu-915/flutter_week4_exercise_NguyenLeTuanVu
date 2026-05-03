import 'package:flutter/material.dart';
import '../widgets/contact_item.dart';

class ListViewScreen extends StatefulWidget {
  const ListViewScreen({super.key});

  @override
  State<ListViewScreen> createState() => _ListViewScreenState();
}

class _ListViewScreenState extends State<ListViewScreen> {

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Contact> _allContacts = const [
    Contact(
      name: 'Nguyễn Văn An',
      phone: '0901 234 567',
      email: 'nguyenvanan@email.com',
      department: 'Engineering',
      avatarColor: Color(0xFF6C63FF),
      isOnline: true,
    ),
    Contact(
      name: 'Trần Thị Bình',
      phone: '0912 345 678',
      email: 'tranthiminh@email.com',
      department: 'Design',
      avatarColor: Color(0xFFFF6B9D),
      isOnline: true,
    ),
    Contact(
      name: 'Lê Minh Cường',
      phone: '0923 456 789',
      email: 'leminhcuong@email.com',
      department: 'Marketing',
      avatarColor: Color(0xFF4CAF50),
      isOnline: false,
    ),
    Contact(
      name: 'Phạm Thu Dung',
      phone: '0934 567 890',
      email: 'phamthudung@email.com',
      department: 'HR',
      avatarColor: Color(0xFFFF9800),
      isOnline: true,
    ),
    Contact(
      name: 'Hoàng Đức Em',
      phone: '0945 678 901',
      email: 'hoangducem@email.com',
      department: 'Finance',
      avatarColor: Color(0xFF2196F3),
      isOnline: false,
    ),
    Contact(
      name: 'Vũ Thị Phương',
      phone: '0956 789 012',
      email: 'vuthiphuong@email.com',
      department: 'Engineering',
      avatarColor: Color(0xFF9C27B0),
      isOnline: true,
    ),
    Contact(
      name: 'Đỗ Văn Giang',
      phone: '0967 890 123',
      email: 'dovangiang@email.com',
      department: 'Sales',
      avatarColor: Color(0xFFF44336),
      isOnline: false,
    ),
    Contact(
      name: 'Bùi Thị Hoa',
      phone: '0978 901 234',
      email: 'buithihoa@email.com',
      department: 'Design',
      avatarColor: Color(0xFF009688),
      isOnline: true,
    ),
    Contact(
      name: 'Ngô Minh Ích',
      phone: '0989 012 345',
      email: 'ngominhich@email.com',
      department: 'Marketing',
      avatarColor: Color(0xFFFF5722),
      isOnline: false,
    ),
    Contact(
      name: 'Dương Thị Kim',
      phone: '0990 123 456',
      email: 'duongthikim@email.com',
      department: 'Engineering',
      avatarColor: Color(0xFF3F51B5),
      isOnline: true,
    ),
    Contact(
      name: 'Tô Văn Long',
      phone: '0901 234 111',
      email: 'tovanlong@email.com',
      department: 'Finance',
      avatarColor: Color(0xFF795548),
      isOnline: false,
    ),
    Contact(
      name: 'Cao Thị Mai',
      phone: '0912 345 222',
      email: 'caothimai@email.com',
      department: 'HR',
      avatarColor: Color(0xFF607D8B),
      isOnline: true,
    ),
    Contact(
      name: 'Lý Văn Nam',
      phone: '0923 456 333',
      email: 'lyvannam@email.com',
      department: 'Sales',
      avatarColor: Color(0xFFE91E63),
      isOnline: false,
    ),
    Contact(
      name: 'Đinh Thị Oanh',
      phone: '0934 567 444',
      email: 'dinhthioanh@email.com',
      department: 'Engineering',
      avatarColor: Color(0xFF00BCD4),
      isOnline: true,
    ),
    Contact(
      name: 'Trịnh Văn Phong',
      phone: '0945 678 555',
      email: 'trinhvanphong@email.com',
      department: 'Design',
      avatarColor: Color(0xFF8BC34A),
      isOnline: true,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Contact> get _filteredContacts {
    if (_searchQuery.isEmpty) return _allContacts;
    return _allContacts.where((contact) {
      return contact.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          contact.phone.contains(_searchQuery) ||
          contact.department.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredContacts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 1 - List View'),
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF6C63FF),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Tìm kiếm contacts...',
                hintStyle: const TextStyle(color: Colors.white60),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.white24,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${filtered.length} contacts',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF888888),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${filtered.where((c) => c.isOnline).length} online',
                      style: const TextStyle(fontSize: 12, color: Colors.green),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: filtered.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_search, size: 64, color: Colors.grey),
                        SizedBox(height: 12),
                        Text(
                          'Không tìm thấy contact',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return ContactItem(
                        contact: filtered[index],
                        onTap: () => _showContactDetail(context, filtered[index]),
                      );
                    },
                    padding: const EdgeInsets.only(bottom: 16),
                  ),
          ),
        ],
      ),
    );
  }

  void _showContactDetail(BuildContext context, Contact contact) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: contact.avatarColor,
              ),
              child: Center(
                child: Text(
                  contact.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              contact.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(contact.department,
                style: TextStyle(color: contact.avatarColor)),
            const SizedBox(height: 16),
            _detailRow(Icons.phone, contact.phone),
            _detailRow(Icons.email, contact.email),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6C63FF), size: 20),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}
