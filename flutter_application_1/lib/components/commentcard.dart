import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class commentcard extends StatefulWidget {
  final List<dynamic> comments;
  final String ticketId;
  const commentcard({
    super.key,
    required this.comments,
    required this.ticketId,
  });
  @override
  State<commentcard> createState() => commentcardstate();
}

class commentcardstate extends State<commentcard> {
  TextEditingController commentcontroller = TextEditingController();

Future<void> _inviaCommento() async {
  if (commentcontroller.text.isEmpty) return;

  final url = '${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/commenti/aggiungiCommento';

  try {
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'ticketId': widget.ticketId,
        'commento': {
          'autore': 'NomeAutore', // Sostituisci con il nome reale dell'autore
          'testo': commentcontroller.text,
        }
      }),
    );

    if (response.statusCode == 200) {
      // Commento inviato con successo
      commentcontroller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Commento inviato con successo')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante l\'invio del commento')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Errore di connessione: $e')),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: Card(
        elevation: 8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(
                16,
              ), // Nota: ho cambiato EdgeInsetsGeometry in EdgeInsets
              child: messageScroller(comments: widget.comments),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Allinea in fondo
                children: [
                  // TextField espandibile
                  Expanded(
                    child: Textfield(
                      controller: commentcontroller,
                      maxLines: null, // Permette espansione verticale
                      // Altezza minima iniziale
                    ),
                  ),

                  IconButton(
                    onPressed: _inviaCommento,
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageScroller extends StatefulWidget {
  final List<dynamic> comments;
  const messageScroller({super.key, required this.comments});

  @override
  State<messageScroller> createState() => _messageState();
}

class _messageState extends State<messageScroller> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Altezza fissa
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 12),
            ...widget.comments.map(
              (comment) => messageBubble(
                autore: comment['autore'] ?? 'Anonimo',
                testo: comment['testo'] ?? '',
                date: comment['data'] ?? '',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messageBubble extends StatefulWidget {
  final String? autore;
  final String? testo;
  final String? date;
  const messageBubble({super.key, this.autore, this.testo, this.date});

  @override
  State<messageBubble> createState() => _messageBubble();
}

class _messageBubble extends State<messageBubble> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color.fromARGB(113, 247, 187, 76),
            borderRadius: BorderRadius.all(Radius.circular(8)),
            border: Border.all(
              color: const Color.fromARGB(255, 247, 187, 76),
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.autore ?? "NA",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.testo ?? "NA",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        Text(
          widget.date ?? "NA",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
