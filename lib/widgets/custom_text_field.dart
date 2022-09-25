import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final bool isNumberOnly;
  final bool isNumberAndCapsOnly;
  final bool isSmall;
  final TextEditingController? controller;
  final bool? enabled;

  const CustomTextField({
    Key? key,
    required this.label,
    this.isNumberOnly = false,
    this.isNumberAndCapsOnly = false,
    this.obscureText = false,
    this.isSmall = false,
    this.controller,
    this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: 40.0,
      width: isSmall ? size.width * 0.39 : size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: TextField(
          enabled: enabled,
          controller: controller,
          obscureText: obscureText,
          textCapitalization: isNumberAndCapsOnly
              ? TextCapitalization.characters
              : TextCapitalization.none,
          keyboardType:
              isNumberOnly ? TextInputType.number : TextInputType.text,
          inputFormatters: <TextInputFormatter>[
            if (isNumberOnly)
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            if (isNumberAndCapsOnly)
              FilteringTextInputFormatter.allow(RegExp("[0-9A-Z]")),
          ],
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: label,
            hintStyle: const TextStyle(
              color: Color(0xFFBDBDBD),
              fontSize: 15,
            ),
          ),
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
