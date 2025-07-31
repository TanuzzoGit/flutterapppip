
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class customfloat extends StatelessWidget {

  const customfloat({super.key});

  @override
  Widget build(BuildContext context) {
   
        return Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              tooltip: "Aggiungi Nuovo Ticket",
              onPressed: () {
                context.go('/');
              },
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              elevation: 1,
              shape: CircleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.surface,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.home, color: Colors.black),
            ),
          ),
        );
  }}