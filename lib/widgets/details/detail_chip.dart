import 'package:flutter/material.dart';

class DetailChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? color;

  const DetailChip({
    super.key,
    required this.label,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Chip(
        avatar: Icon(icon ?? Icons.label, size: 18, color: color ?? Colors.red[400]),
        label: Text(label),
        backgroundColor: (color ?? Colors.red).withOpacity(0.1),
        labelStyle: TextStyle(
          color: color ?? Colors.red[700],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
