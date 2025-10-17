import 'package:flutter/material.dart';
import 'package:mobile_sigma_app/pages/create_widgets/company_form_widget.dart';

class CreateCompanyPage extends StatelessWidget {
  const CreateCompanyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Company'),
        centerTitle: true,
      ),
      body: const CompanyFormWidget(isEdit: false),
    );
  }
}
