import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<dynamic> items;
  final String? selectedValue;
  final Function(String?) onChanged;
  final bool required;
  final String Function(dynamic)? itemLabelBuilder;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.selectedValue,
    this.required = false,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: required ? '$label *' : label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        items: items.map((item) {
          final label = itemLabelBuilder != null
              ? itemLabelBuilder!(item)
              : item.toString();
          return DropdownMenuItem<String>(
            value: item['id'].toString(),
            child: Text(label),
          );
        }).toList(),
        onChanged: onChanged,
        validator: required
            ? (value) =>
                (value == null || value.isEmpty) ? '$label is required' : null
            : null,
      ),
    );
  }
}
