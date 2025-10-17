import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  ImageProvider _getImageProvider(String? path) {
    if (path == null || path.isEmpty) {
      return const AssetImage('assets/default_product.png'); //default image ntar ganti aja
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
                    image: _getImageProvider(product['image']),
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
                      product['name'] ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(product['note'] ?? ''),
                    const SizedBox(height: 4),
                    Text('Description: ${product['description'] ?? '-'}'),
                    Text('Code ${product['code_id'] ?? '-'}'),
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
