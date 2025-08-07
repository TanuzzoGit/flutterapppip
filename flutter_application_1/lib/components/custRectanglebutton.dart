import 'package:flutter/material.dart';

class Custrectanglebutton extends StatefulWidget {
  final Icon ico;
  final String label;
  final Function fun;
  final Color primaryColor;
  final Color textColor;

  const Custrectanglebutton({
    super.key,
    required this.ico,
    required this.label,
    required this.fun,
    required this.primaryColor,
    required this.textColor
  });
  @override
  State<Custrectanglebutton> createState() => _custrectanglebutton();
}

class _custrectanglebutton extends State<Custrectanglebutton> {
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: widget.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: TextButton.icon(
        icon: widget.ico,
        label: Text(widget.label, style: TextStyle(color: widget.textColor)),
        onPressed: () {
          widget.fun();
        },

        // style: Textbutton.styleFrom(

        //   backgroundColor: Theme.of(context).colorScheme.primary,
        //   foregroundColor: Colors.white,
        //   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        // ),
      ),
    );
  }
}
