import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../palette.dart' as pals;
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Takeresp extends StatefulWidget {
  final String? ticketId;
  final Function updateTickets;
  const Takeresp({super.key, required this.ticketId,required this.updateTickets});

  @override
  State<Takeresp> createState() => _takerespstate();
}

class _takerespstate extends State<Takeresp> {
  TextEditingController contentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      padding: EdgeInsets.all(16), // Aggiungi padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8), // Bordi arrotondati opzionali
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Contenuto ( opzionale )"),

          TextFormField(
            controller: contentController,
            decoration: pals.decorations,
          ),
          SizedBox(height: 20),
          // Aggiungi un pulsante per chiudere il dialog
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Chiudi"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  final res = await http.put(
                    Uri.parse(
                      "${dotenv.env['PROD'] == 'true' ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/pic/${widget.ticketId}",
                    ),
                    headers: {'Content-Type': 'application/json'},

                    body: jsonEncode({
                      "dipendenteResponsabile": prefs.getString("utente"),
                      "contenuto": contentController.text,
                    }),
                  );
                  print(res.body);
                  Navigator.of(context).pop();
                  widget.updateTickets();

                },
                child: Text("Salva"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
