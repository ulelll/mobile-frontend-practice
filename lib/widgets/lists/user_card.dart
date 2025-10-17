import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final Map<String, dynamic> user;
  final VoidCallback? onTap; 

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  ImageProvider _getImageProvider(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/default_user.png');
    } else if (path.startsWith('http')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // handle tap event 
      borderRadius: BorderRadius.circular(16),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: _getImageProvider(user['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['username'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(user['full_name'] ?? ''),
                    const SizedBox(height: 4),
                    // Text('PIC: ${user['pic_name'] ?? '-'}'),
                    // Text('📞 ${user['pic_contact'] ?? '-'}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
