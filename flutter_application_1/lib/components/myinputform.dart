import 'package:flutter/material.dart';

class MyInputForm extends StatefulWidget {
  final String? label;
  final TextEditingController controller;
  const MyInputForm({
    super.key,
    required this.label,
    required this.controller,
  });
   

  @override
  State<MyInputForm> createState() => _myinputformstate();
}

class _myinputformstate extends State<MyInputForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          fontSize: 16
          
        ),
        // border: OutlineInputBorder(
        //   borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2.0),
        //   borderRadius: BorderRadius.circular(10.0),
        // ),
        contentPadding: EdgeInsets.symmetric(horizontal: 8)
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }
}