import 'package:flutter/material.dart';
import '../palette.dart' as pal;

class Textfield extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  
  const Textfield({
    super.key, 
    this.controller,
    this.hintText,
    this.maxLines = 1,
  });

  @override
  State<Textfield> createState() => _TextFieldState();
}

class _TextFieldState extends State<Textfield> {
  @override
  Widget build(BuildContext context) {
   return Container(
        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
        height: 35,
        child: 
      
      TextFormField(
        
        controller: widget.controller,
        maxLines: widget.maxLines,
        decoration: pal.decorations.copyWith(
          
          hintText: widget.hintText,
          contentPadding: const EdgeInsets.all(3),
        ),
      ),
    );
  }
}