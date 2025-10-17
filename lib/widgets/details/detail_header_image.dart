import 'package:flutter/material.dart';

class DetailHeaderImage extends StatelessWidget {
  final String? imageUrl;
  final IconData placeholderIcon;

  const DetailHeaderImage({
    super.key,
    this.imageUrl,
    this.placeholderIcon = Icons.business,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        (imageUrl != null && imageUrl!.isNotEmpty)
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() => Container(
        color: Colors.grey[300],
        child: Icon(placeholderIcon, size: 80, color: Colors.grey),
      );
}
