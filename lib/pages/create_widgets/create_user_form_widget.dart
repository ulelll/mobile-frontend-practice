import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_sigma_app/controllers/user_controller.dart';
import 'package:mobile_sigma_app/widgets/fields/custom_text_field.dart';
import 'package:mobile_sigma_app/widgets/fields/submit_button.dart';

class UserFormWidget extends StatefulWidget {
  const UserFormWidget({super.key});

  @override
  State<UserFormWidget> createState() => _UserFormWidgetState();
}

class _UserFormWidgetState extends State<UserFormWidget> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final fullNameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final userController = Get.put(UserController());

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      "username": nameCtrl.text.trim(),
      "code_id": codeCtrl.text.trim(),
      "full_name": fullNameCtrl.text.trim(),
      "password": passwordCtrl.text.trim(),
    };

    userController.isLoading.value = true;
    final success = await userController.createUser(payload);
    userController.isLoading.value = false;

    if (success) {
      Get.back();
      Get.snackbar(
        'Success',
        'User created successfully!',
        snackPosition: SnackPosition.TOP,
      );
      userController.fetchUsers();
    } else {
      Get.snackbar(
        'Error',
        'Failed to create user.',
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
                label: "User Name",
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
                label: "Password",
                controller: passwordCtrl,
                required: true,
              ),

              const SizedBox(height: 16),

              SubmitButton(
                text: "Create User",
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
