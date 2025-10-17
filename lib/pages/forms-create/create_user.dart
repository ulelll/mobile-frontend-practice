import 'package:flutter/material.dart';
import 'package:mobile_sigma_app/pages/create_widgets/create_user_form_widget.dart';

class CreateUserPage extends StatelessWidget {
  const CreateUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New User'), 
        centerTitle: true,
      ),
      body: const UserFormWidget(),
    );
  }
}
