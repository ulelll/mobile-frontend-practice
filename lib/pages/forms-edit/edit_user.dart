import 'package:flutter/material.dart';
import 'package:mobile_sigma_app/pages/edit_widgets/edit_user_form_widget.dart';

class EditUserPage extends StatelessWidget {
   final String userId;
  const EditUserPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'), 
        centerTitle: true,
      ),
      body: EditUserFormWidget(userId: userId),
    );
  }
}
