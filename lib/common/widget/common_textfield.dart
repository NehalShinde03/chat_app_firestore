import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? obscureText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final String? labelText;
  final ValueChanged? onChanged;
  final int? maxLine;
  final Color? iconColor;

  const CommonTextField(
      {super.key,
        this.hintText = "",
        this.prefixIcon,
        this.suffixIcon,
        this.obscureText,
        this.onTap,
        this.controller,
        this.validator,
        this.labelText = "",
        this.onChanged,
        this.maxLine = 1,
        this.iconColor
      });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: controller,
      obscureText: obscureText ?? false,
      obscuringCharacter: '*',
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLine,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          // hintText: hintText,
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
          prefixIcon: Icon(prefixIcon, color: iconColor),
          suffixIcon: GestureDetector(
            onTap: onTap,
            child: Icon(suffixIcon),
          )),
    );
  }
}
