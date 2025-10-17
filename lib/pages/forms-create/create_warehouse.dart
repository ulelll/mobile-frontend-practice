import 'package:flutter/material.dart';
import 'package:mobile_sigma_app/pages/create_widgets/create_warehouse_form_widget.dart';

class CreateWarehousePage extends StatelessWidget {
  const CreateWarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New warehouse'), 
        centerTitle: true,
      ),
      body: const CreateWarehouseFormWidget(),
    );
  }
}
