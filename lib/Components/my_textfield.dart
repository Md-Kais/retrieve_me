import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final IconData prefixIcon;
  final String labelText;
  final List<TextInputFormatter>? inputFormatters; // Added inputFormatters
  final TextInputType? keyboardType; // Made keyboardType optional

  const MyTextField({
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.prefixIcon,
    required this.labelText,
    this.inputFormatters, // Pass inputFormatters as an optional parameter
    this.keyboardType, // Pass keyboardType as an optional parameter
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType, // Use keyboardType here (can be null)
        inputFormatters:
            inputFormatters, // Use inputFormatters here (can be null)
        style: TextStyle(color: Color.fromRGBO(20, 245, 210, 55)),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: Color.fromARGB(179, 223, 206, 206)),
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 156, 178, 197), // Border color
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0), // Border radius
            ),
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
