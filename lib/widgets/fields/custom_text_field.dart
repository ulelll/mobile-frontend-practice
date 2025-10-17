  import 'package:flutter/material.dart';

  class CustomTextField extends StatelessWidget {
    final String label;
    final TextEditingController controller;
    final bool required;
    final TextInputType keyboardType;
    final int maxLines;
    final String? hint;

    const CustomTextField({
      super.key,
      required this.label,
      required this.controller,
      this.required = false,
      this.keyboardType = TextInputType.text,
      this.maxLines = 1,
      this.hint,
    });

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            labelText: required ? '$label *' : label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return '$label is required';
                  }
                  return null;
                }
              : null,
        ),
      );
    }
  }
