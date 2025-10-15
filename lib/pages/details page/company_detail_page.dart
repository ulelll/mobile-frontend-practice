import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/details%20page/company_detail_controller.dart';

class CompanyDetailPage extends StatelessWidget {
  final String companyId;

  const CompanyDetailPage({
    Key? key,
    required this.companyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CompanyDetailController());
    
    // Fetch data when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchCompanyDetail(companyId);
    });

    return Scaffold(
      body: Obx(() {
        // Loading state
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.fetchCompanyDetail(companyId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        // Data loaded state
        final data = controller.companyData.value;
        if (data == null) {
          return const Center(
            child: Text('No data available'),
          );
        }

        return _buildContent(data);
      }),
    );
  }

  Widget _buildContent(Map<String, dynamic> data) {
    return CustomScrollView(
      slivers: [
        // App Bar with Image
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: _buildHeaderImage(data),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          actions: [
            // Edit Button
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white),
              onPressed: () => _showEditDialog(data),
              tooltip: 'Edit Company',
            ),
            // Delete Button
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white),
              onPressed: () => _showDeleteDialog(data),
              tooltip: 'Delete Company',
            ),
          ],
        ),
        
        // Content
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCompanyHeader(data),
              _buildCategoryChip(data),
              const Divider(height: 32),
              _buildDescription(data),
              const Divider(height: 32),
              _buildContactSection(data),
              const Divider(height: 32),
              _buildLocationSection(data),
              const Divider(height: 32),
              _buildAdditionalInfo(data),
              const SizedBox(height: 24),
              _buildActionButtons(data),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ],
    );
  }

  void _showEditDialog(Map<String, dynamic> data) {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.edit, color: Colors.blue),
            SizedBox(width: 8),
            Text('Edit Company'),
          ],
        ),
        content: Text('Edit company: ${data['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // TODO: Navigate to edit page
              // Get.to(() => EditCompanyPage(companyId: companyId, companyData: data));
              Get.snackbar(
                'Info',
                'Navigate to edit page here',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.blue[100],
                duration: const Duration(seconds: 2),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> data) {
    Get.dialog(
      AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Delete Company'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to delete this company?'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['name'] ?? 'N/A',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Code: ${data['code_id'] ?? 'N/A'}',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This action cannot be undone.',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              _deleteCompany(data);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _deleteCompany(Map<String, dynamic> data) {
    // TODO: Call API to delete company
    // final controller = Get.find<CompanyDetailController>();
    // controller.deleteCompany(companyId);
    
    // Show loading dialog
    Get.dialog(
      const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting company...'),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );

    // Simulate API call
    Future.delayed(const Duration(seconds: 2), () {
      Get.back(); // Close loading dialog
      
      // Show success message
      Get.snackbar(
        'Success',
        'Company deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
        icon: const Icon(Icons.check_circle, color: Colors.green),
        duration: const Duration(seconds: 3),
      );
      
      // Navigate back to company list
      Get.back();
    });
  }

  Widget _buildHeaderImage(Map<String, dynamic> data) {
    return Stack(
      fit: StackFit.expand,
      children: [
        data['image'] != null && data['image'].toString().isNotEmpty
            ? Image.network(
                data['image'],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildPlaceholderImage(),
              )
            : _buildPlaceholderImage(),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Icon(Icons.business, size: 80, color: Colors.grey),
    );
  }

  Widget _buildCompanyHeader(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['name'] ?? 'Company Name',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Code: ${data['code_id'] ?? '-'}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(Map<String, dynamic> data) {
    final category = data['category'];
    if (category == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Chip(
        avatar: const Icon(Icons.category, size: 18, color: Color.fromARGB(255, 168, 57, 57)),
        label: Text(category['name'] ?? 'Category'),
        backgroundColor: Colors.red[50],
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 106, 55, 55),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDescription(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            data['description'] ?? 'No description available',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Person',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            Icons.person,
            'Name',
            data['pic_name'] ?? '-',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.phone,
            'Phone',
            data['pic_contact'] ?? '-',
            isClickable: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Open map
                },
                icon: const Icon(Icons.map, size: 18),
                label: const Text('View Map'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLocationCard(data),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red[400], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  data['address'] ?? 'No address available',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildLocationDetail('Ward', data['ward']?['name']),
          _buildLocationDetail('Subdistrict', data['subdistrict']?['name']),
          _buildLocationDetail('District', data['district']?['name']),
          _buildLocationDetail('Province', data['province']?['name']),
        ],
      ),
    );
  }

  Widget _buildLocationDetail(String label, String? value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          const SizedBox(width: 28),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(Map<String, dynamic> data) {
    final note = data['note'];
    if (note == null || note.toString().isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Notes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber[200]!),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Colors.amber[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    note.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.amber[900],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isClickable = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color.fromARGB(255, 210, 25, 25)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isClickable ? const Color.fromARGB(255, 182, 44, 44) : Colors.black87,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Edit and Delete buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showEditDialog(data),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showDeleteDialog(data),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}