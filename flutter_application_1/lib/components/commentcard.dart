import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textfield.dart';

class commentcard extends StatefulWidget {
  final List<dynamic> comments;
  const commentcard({super.key, required this.comments});
  @override
  State<commentcard> createState() => commentcardstate();
}

class commentcardstate extends State<commentcard> {
  TextEditingController commentcontroller = TextEditingController();
  
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
              padding: const EdgeInsets.all(16),  // Nota: ho cambiato EdgeInsetsGeometry in EdgeInsets
              child: messageScroller(comments: widget.comments),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Textfield(
                      controller: commentcontroller,
                      hintText: "Scrivi un commento...",
                      maxLines: null, // Permette multilinea
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      // Logica per inviare il commento
                    },
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
            ...widget.comments.map(
              (comment) => messageBubble(
                autore: comment['autore'] ?? 'Anonimo',
                testo: comment['testo'] ?? '',
                date: comment['data'] ?? '',
              ),
            ),
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
          "14:50",
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
