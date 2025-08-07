import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Navbar({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    
    return AppBar(
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
    icon: Icon(Icons.west, color: Colors.black),
    onPressed: () => Navigator.of(context).pop(),
  ), 
      title: Text(title,style: TextStyle(fontSize: 16),),
      elevation: 6,
      shape: Border(
        bottom: BorderSide(
          color: const Color.fromARGB(75, 0, 0, 0),
          width: 1.5
        ),
      ),
      // backgroundColor: const Color.fromARGB(255, 255, 240, 208),
      backgroundColor: Colors.white,
      shadowColor: const Color.fromARGB(153, 0, 0, 0),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
