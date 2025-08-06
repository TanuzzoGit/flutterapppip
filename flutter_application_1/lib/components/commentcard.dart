import 'package:flutter/material.dart';

class commentcard extends StatefulWidget {
  final List<dynamic> comments;
  const commentcard({super.key, required this.comments});
  @override
  State<commentcard> createState() => commentcardstate();
}

class commentcardstate extends State<commentcard> {
  @override
  Widget build(BuildContext context) {
    return
    SizedBox(
      width: double.infinity,

      child: Card(
      //TODO funzione get Commenti, ma prima popola almeno un'entry del db con dei commenti.
      elevation: 8,
      child: Column(children: [
        Padding(
          padding: EdgeInsetsGeometry.all(16),
          child:
        messageScroller(comments : widget.comments),
        )
        // TextFormField()
        ]),
    ));
  }
}

class messageScroller extends StatefulWidget {
   final List<dynamic> comments;
  const messageScroller({super.key,required this.comments});

  @override
  State<messageScroller> createState() => _messageState();
}

class _messageState extends State<messageScroller> {
  @override
  Widget build(BuildContext build) {
    return SingleChildScrollView(
      //TODO:Rendere componente dinamico
      child: Column(
        children: [
          //Padding.
          SizedBox(height: 12),
          ...widget.comments.map(
                          (comment) => messageBubble(
                            autore: comment['autore'] ?? 'Anonimo',
                            testo: comment['testo'] ?? '',
                            date: comment['data'] ?? '',
                          ),
                        )
        ],
      ),
    );
  }
}

class messageBubble extends StatefulWidget{
   final String? autore;
  final String? testo;
  final String? date;
  const messageBubble({super.key,this.autore,this.testo,this.date});

  @override
  State<messageBubble> createState() => _messageBubble(); 

}

class _messageBubble extends State<messageBubble>{
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [Container(
      width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(113, 247, 187, 76),
              borderRadius: BorderRadius.all(Radius.circular(8)),
              border: Border.all(color: const Color.fromARGB(255, 247, 187, 76),width: 2)
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
          Text("14:50",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500))
          ]);
  }
}