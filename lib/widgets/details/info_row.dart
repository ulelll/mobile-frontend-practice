import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isClickable;
  final Color? color;

  const InfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.isClickable = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? Colors.red).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color ?? Colors.red),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isClickable ? (color ?? Colors.red) : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
