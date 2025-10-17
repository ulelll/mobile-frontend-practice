import 'package:flutter/material.dart';
import 'package:mobile_sigma_app/pages/create_widgets/create_product_form_widget.dart';

class CreateProductPage extends StatelessWidget {
  const CreateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        centerTitle: true,
      ),
      body: const CreateProductFormWidget(),
    );
  }
}
