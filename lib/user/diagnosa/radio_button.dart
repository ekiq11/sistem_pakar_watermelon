// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MyRadioListTile<T> extends StatelessWidget {
  final int? value;
  final T? groupValue;
  final String leading;
  final Widget? title;
  final ValueChanged<int?> onChanged;

  const MyRadioListTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.leading,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: SizedBox(
        height: 24,
        child: Row(
          children: [
            _customRadioButton,
          ],
        ),
      ),
    );
  }

  Widget get _customRadioButton {
    final String? title;
    final isSelected = value == groupValue;
    return Container(
      width: 32.0,
      height: 32.0,
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : null,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey[300]!,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          leading,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[600]!,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ),
    );
  }
}
