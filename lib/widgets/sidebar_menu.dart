import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SidebarMenu extends StatelessWidget {
  final VoidCallback onClose;

  const SidebarMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: double.infinity,
      decoration: BoxDecoration(
      color: const Color(0xFF2B2B2B),
      borderRadius: BorderRadius.only(
      topRight: Radius.circular(25),
      bottomRight: Radius.circular(25),
    ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          blurRadius: 12,
          offset: const Offset(6, 0),
        ),
      ],
    ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "asix",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 100),
              _menuItem(Icons.business, "Company", () {
                onClose();
                Get.offNamed('/company');
              }),
              _menuItem(Icons.share, "Branch", () {
                onClose();
                Get.offNamed('/branch');
              }),
              _menuItem(Icons.warehouse, "Warehouse", () {
                onClose();
                Get.offNamed('/warehouse');
              }),
              _menuItem(Icons.inventory, "Product", () {
                onClose();
                Get.offNamed('/product');
              }),
              _menuItem(Icons.people, "Users", () {
                onClose();
                Get.offNamed('/user');
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            )
          ],
        ),
      ),
    );
  }
}
