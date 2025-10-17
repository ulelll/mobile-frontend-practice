import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/user_controller.dart';
import 'package:mobile_sigma_app/controllers/details page/user_detail_controller.dart';
import 'package:mobile_sigma_app/widgets/fields/custom_text_field.dart';
import 'package:mobile_sigma_app/widgets/fields/submit_button.dart';

class EditUserFormWidget extends StatefulWidget {
  final String userId;

  const EditUserFormWidget({
    super.key,
    required this.userId,
  });

  @override
  State<EditUserFormWidget> createState() => _EditUserFormWidgetState();
}

class _EditUserFormWidgetState extends State<EditUserFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  final userController = Get.put(UserController());
  final userDetailController = Get.put(UserDetailController());

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await userDetailController.fetchUserDetail(widget.userId);
    final data = userDetailController.userData.value;

    if (data != null) {
      nameCtrl.text = data['username'] ?? '';
      codeCtrl.text = data['code_id'] ?? '';
      fullNameCtrl.text = data['full_name'] ?? '';
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "username": nameCtrl.text.trim(),
      "code_id": codeCtrl.text.trim(),
      "full_name": fullNameCtrl.text.trim(),
      // password opsional saat update
      if (passwordCtrl.text.trim().isNotEmpty)
        "password": passwordCtrl.text.trim(),
    };

    userController.isLoading.value = true;
    final success = await userController.updateUser(widget.userId, payload);
    userController.isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        'User updated successfully!',
        snackPosition: SnackPosition.TOP,
      );
      userController.fetchUsers();
    } else {
      Get.snackbar(
        'Error',
        'Failed to update user.',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                label: "Username",
                controller: nameCtrl,
                required: true,
              ),
              CustomTextField(
                label: "Code ID",
                controller: codeCtrl,
                required: true,
              ),
              CustomTextField(
                label: "Full Name",
                controller: fullNameCtrl,
                required: true,
              ),
              CustomTextField(
                label: "New Password (optional)",
                controller: passwordCtrl,
              ),

              const SizedBox(height: 24),

              SubmitButton(
                text: "Update User",
                isLoading: userController.isLoading.value,
                onPressed: _handleSubmit,
              ),
            ],
          );
        }),
      ),
    );
  }
}
