library;
import 'package:flutter/material.dart';
Color background = Color.fromARGB(255, 255, 248, 243);
Color primary = Color.fromARGB(255, 209, 231, 231);
Color primaryContainer = Color.fromARGB(255, 216, 255, 255);
Color textPrimary = Colors.black;
Color textWhite = Colors.white;

InputDecoration decorations = InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 205, 226, 224),
                strokeAlign: BorderSide.strokeAlignOutside,
                width: 2,
              ),

              borderRadius: BorderRadius.circular(15),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 187, 214, 212),
                strokeAlign: BorderSide.strokeAlignOutside,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            filled: true,
            fillColor: Color.fromARGB(129, 224, 234, 238),
            // hoverColor: Color.fromARGB(136, 255, 0, 0)
          );
Color navbarButtonPrimary =  Color.fromARGB(255, 124, 77, 255);