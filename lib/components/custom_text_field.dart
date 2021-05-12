import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final _controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String Function(String) validator;

  final bool obscureText;

  CustomTextField(this._controller, this.labelText, this.hintText, this.keyboardType, this.validator, {this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
          border: new OutlineInputBorder(
          ),
          labelText: labelText,
          hintText: hintText),
    );
  }
}
