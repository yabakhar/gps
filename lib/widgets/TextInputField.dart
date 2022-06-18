import 'package:flutter/material.dart';
import '../core/utils/constants.dart';

class TextInputField extends StatelessWidget {
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Color? cursorColor;
  final String? hintText;
  final IconData? prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Color? fillColor;
  final double? vContentPadding;
  final double? hContentPadding;

  TextInputField(
      {this.controller,
      this.vContentPadding,
      this.hContentPadding,
      this.obscureText = false,
      this.hintText,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.keyboardType,
      this.fillColor,
      this.cursorColor});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: cursorColor,
      obscureText: obscureText,
      validator: validator,
      decoration: new InputDecoration(
        filled: true,
        fillColor: fillColor ?? AppColors.greyLightColor,
        contentPadding: EdgeInsets.symmetric(
          vertical: vContentPadding ?? 30,
          horizontal: hContentPadding ?? 14,
        ),
        alignLabelWithHint: true,
        labelText: hintText,
        labelStyle: TextStyle(color: Color(0xff3678b5)),
        // hintText: hintText,
        //hintStyle: TextStyle(color: primaryColor),
        prefixIcon: Icon(
          prefixIcon,
          color: Color(0xff3678b5),
        ),
        suffixIcon: suffixIcon,
        focusedBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        enabledBorder: new OutlineInputBorder(
          borderRadius: new BorderRadius.circular(5.0),
          borderSide: BorderSide(color: Colors.transparent),
        ),
        // contentPadding: EdgeInsets.all(30)
      ),
    );
  }
}
