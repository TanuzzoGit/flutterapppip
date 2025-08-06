import 'package:flutter/material.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const Navbar({required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    
    return AppBar(
      title: Text(title),
      elevation: 10,
      shape: Border(
        bottom: BorderSide(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
