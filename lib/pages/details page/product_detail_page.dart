import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/details page/product_detail_controller.dart';
import 'package:mobile_sigma_app/widgets/details/detail_header.dart';
import 'package:mobile_sigma_app/widgets/details/detail_chip.dart';
import 'package:mobile_sigma_app/widgets/details/detail_section_text.dart';
import 'package:mobile_sigma_app/widgets/details/info_row.dart';
import 'package:mobile_sigma_app/widgets/details/location_section.dart';
import 'package:mobile_sigma_app/widgets/details/note_section.dart';
import 'package:mobile_sigma_app/widgets/details/detail_action_buttons.dart';
import 'package:mobile_sigma_app/widgets/details/detail_header_image.dart';

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductDetailController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchProductDetail(productId);
    });

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(child: Text(controller.errorMessage.value));
        }

        final data = controller.productData.value;
        if (data == null) return const Center(child: Text('No data available'));

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 250,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: DetailHeaderImage(imageUrl: data['image']),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DetailHeader(
                    title: data['name'] ?? 'Product Name',
                    subtitle: 'Code: ${data['code_id'] ?? '-'}',
                  ),
                  if (data['category'] != null)
                    DetailChip(label: data['category']['name']),
                  const Divider(height: 32),
                  DetailSectionText(
                    title: 'About',
                    content: data['description'] ?? '',
                  ),
                  const Divider(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Contact Person',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        InfoRow(
                          icon: Icons.person,
                          label: 'Name',
                          value: data['pic_name'] ?? '-',
                        ),
                        const SizedBox(height: 12),
                        InfoRow(
                          icon: Icons.phone,
                          label: 'Phone',
                          value: data['pic_contact'] ?? '-',
                          isClickable: true,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  NoteSection(note: data['note']),
                  const SizedBox(height: 24),
                  DetailActionButtons(
                    onEdit: () => _onEdit(data),
                    onDelete: () => _onDelete(data),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

    void _onEdit(Map<String, dynamic> data) {
      Get.snackbar('Edit', 'Navigate to edit page here',
          snackPosition: SnackPosition.TOP);
    }

    void _onDelete(Map<String, dynamic> data) async {
    final controller = Get.find<ProductDetailController>();
    final productId = data['id'];

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        elevation: 12,
        shadowColor: Colors.black.withOpacity(0.25),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Product?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
          // Container provides a custom box shadow and roundness
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12), // adjust roundness here
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => Get.back(result: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 204, 64, 64),
                shadowColor: Colors.transparent, // use container's shadow instead
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );

    // Only delete if confirmed
    if (confirm == true) {
      final success = await controller.deleteProduct(productId);

      if (success) {
        Get.back();

        // ✅ Show success message
        Get.snackbar(
          'Deleted',
          'Product successfully deleted',
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to delete product',
          snackPosition: SnackPosition.TOP,
        );
      }
    }
  }
}
