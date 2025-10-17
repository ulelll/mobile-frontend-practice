import 'package:flutter/material.dart';
import 'package:mobile_sigma_app/pages/create_widgets/company_form_widget.dart';

class EditCompanyPage extends StatelessWidget {
  final String companyId;
  const EditCompanyPage({super.key, required this.companyId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Company'),
        centerTitle: true,
      ),
      body: CompanyFormWidget(isEdit: true, companyId: companyId),
    );
  }
}
