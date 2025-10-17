import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/user_profile.dart';

class ProfilePage extends StatelessWidget {
  final controller = Get.put(UserProfileController());

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.error.value != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: ${controller.error.value}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: controller.fetchUserProfile,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (controller.user.value == null) {
          return const Center(child: Text('No profile data available'));
        }

        final userData = controller.user.value!;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Header Background
              Container(
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color.fromARGB(255, 201, 34, 34), const Color.fromARGB(255, 82, 70, 70)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Profile Content
              Transform.translate(
                offset: const Offset(0, -60),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // Profile Picture
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            backgroundImage: const AssetImage('assets/rukia.jpg'),
                            radius: 56,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // User Name Display
                      Text(
                        userData['full_name'] ?? 'User',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '@${userData['username'] ?? 'username'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Profile Fields Card
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // Username Field
                            _buildProfileField(
                              context,
                              label: 'Username',
                              value: userData['username'] ?? 'N/A',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),
                             _buildProfileField(
                              context,
                              label: 'Full Name',
                              value: userData['full_name'] ?? 'N/A',
                              icon: Icons.person_outline,
                            ),
                            const SizedBox(height: 20),

                            // Code ID Field
                            _buildProfileField(
                              context,
                              label: 'Code ID',
                              value: userData['code_id'] ?? 'N/A',
                              icon: Icons.badge_outlined,
                              isMonospace: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Add your logout logic here
                            // Example: controller.logout();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[600],
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, size: 20, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                'Logout',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileField(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool isMonospace = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.blue[600]),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: isMonospace
                ? Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'monospace',
                      color: Colors.black87,
                    )
                : Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                    ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}