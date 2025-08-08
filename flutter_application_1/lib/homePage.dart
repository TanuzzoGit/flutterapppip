import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<_ListaState> listaKey = GlobalKey<_ListaState>();
  String? persona;
  @override
  void initState()  {
    super.initState();
   loadUtente();

  }
  Future<void> loadUtente()async {
              final prefs = await SharedPreferences.getInstance();
      final utente = prefs.getString("utente");
      setState(() {
        persona = utente;
      });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(persona ?? "Non ha letto"),
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Ricarica Ticket',
            onPressed: () {
              listaKey.currentState?._getTickets();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Aggiungi Nuovo Ticket',
            onPressed: () {
              context.go('/insert');
            },
            
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'esci',
            onPressed: ()async {
              final prefs = await SharedPreferences.getInstance();
              prefs.setBool("auth", false);
              prefs.remove("auth");
              context.go('/login');
            },
          ),
        ],
      ),
      body: Lista(key: listaKey),
    );
  }
}

class Appunto {
  String? id;
  String? nomeAutore;
  String? nomeCliente;
  String? contenuto;
  DateTime? dataCreazione;
  String? statoPratica;
  String? tipologia;

  Appunto({
    this.id,
    this.nomeAutore,
    this.nomeCliente,
    this.contenuto,
    this.statoPratica,
    this.dataCreazione,
    this.tipologia,
  });
}

class fetchAppunto {
  Future<List<Appunto>> getAppunti() async {
    final response = await http.get(
      Uri.parse("${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti"),
    );

    if (response.statusCode != 200) {
      throw Exception("Errore nel recupero dei ticket");
    }

    final List<Appunto> appunti =
        (json.decode(response.body) as List).map((data) {
          return Appunto(
            id: data['_id'],
            nomeAutore: data['nomeAutore'],
            nomeCliente: data['nomePersona'],
            contenuto: data['contenuto'],
            statoPratica: data['statoPratica'],
            dataCreazione: DateTime.parse(data['dataCreazione']),
            tipologia: data['tipologia'],
          );
        }).toList();

    return appunti;
  }
}

class Lista extends StatefulWidget {
  const Lista({super.key});

  @override
  State<Lista> createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  List<Appunto>? _tickets;
  final fetchAppunto fetcher = fetchAppunto();

  @override
  void initState() {
    super.initState();
    _getTickets();
    
  }

  void _getTickets() async {
    final result = await fetcher.getAppunti();
    setState(() {
      _tickets = result;
      _tickets?.sort((a, b) {
                        int getPriority(String? stato) {
                          switch (stato) {
                            case "Prendere in Carico":
                              return 0;
                            case "Attende Risposta":
                              return 1;
                            case "Chiuso":
                              return 99;
                            default:
                              return 2;
                          }
                        }
                        return getPriority(
                          a.statoPratica,
                        ).compareTo(getPriority(b.statoPratica));
                      });
    });
  }

  void FilterByName(String nomecliente) async {
    final response = await http.get(
      Uri.parse("${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/client/$nomecliente"),
    );
    final List<Appunto> appunti =
        (json.decode(response.body) as List).map((data) {
          return Appunto(
            id: data['_id'],
            nomeAutore: data['nomeAutore'],
            nomeCliente: data['nomePersona'],
            contenuto: data['contenuto'],
            statoPratica: data['statoPratica'],
            dataCreazione: DateTime.parse(data['dataCreazione']),
            tipologia: data['tipologia'],
          );
        }).toList();
    setState(() {
      _tickets = appunti;
    });
  }

  bool _toggleSearch = false;
  bool isFiltered = false;
  @override
  Widget build(BuildContext context) {
    String? state = GoRouterState.of(context).extra as String?;
    print(state);
    if(state == "true") {setState(() {
      _getTickets();
    });}
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: 
              isFiltered ?
                ElevatedButton(onPressed:() {setState(() {
                  isFiltered = false;
                  _getTickets();
                });} , style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  shape: CircleBorder(),
                ), child: Icon(Icons.close, color: Colors.black))
               : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  shape: CircleBorder(
                    
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _toggleSearch = !_toggleSearch;
                  });
                  print(_toggleSearch);
                },
                child: Icon(Icons.search, color: Colors.black),
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                width: _toggleSearch ? MediaQuery.sizeOf(context).width  : 0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _toggleSearch ? 1.0 : 0.0,
                  child:
                      _toggleSearch
                          ? Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 12,
                              top: 8,
                              bottom: 8,
                            ),
                            child: TextField(
                              onSubmitted: (value) {
                                FilterByName(value);
                                setState(() {
                                  isFiltered = true;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Cerca per Nome Cliente",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          )
                          : const SizedBox.shrink(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                        isFiltered = true;

                      
                    });
                  },
                  icon: const Icon(Icons.sort, color: Colors.black),
                  label: MediaQuery.sizeOf(context).width < 300 ? const Text("Ordina per Priorità") : Text(""),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(8.0),
            children:
                (_tickets ?? []).map((ticket) {
                  return InkWell(
                    onTap: () => context.push('/ticket/${ticket.id}'),
                    borderRadius: BorderRadius.circular(10.0),
                    child: Card(
                      color:Colors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.3),
                          width: 1.0,
                        ),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow(
                                      context,
                                      label: "Autore",
                                      value: ticket.nomeAutore ?? "Sconosciuto",
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      context,
                                      label: "Cliente",
                                      value:
                                          ticket.nomeCliente ?? "Sconosciuto",
                                    ),
                                    const SizedBox(height: 8),
                                    _buildInfoRow(
                                      context,
                                      label: "Contenuto",
                                      value:
                                          "${ticket.contenuto!.length > 45 ? ticket.contenuto!.substring(0, 45) : ticket.contenuto}...",
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    ticket.statoPratica ?? "Sconosciuto",
                                    style: TextStyle(
                                      color: () {
                                        switch (ticket.statoPratica) {
                                          case "In lavorazione":
                                            return Colors.orange;
                                          case "Chiuso":
                                            return Colors.green;
                                          case "Prendere in Carico":
                                            return Colors.red;
                                          case "Attendiamo Chiamata":
                                            return Colors.grey;
                                          case "Attende Risposta":
                                            return Colors.blue;
                                          default:
                                            return Theme.of(
                                              context,
                                            ).colorScheme.primary;
                                        }
                                      }(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                    const SizedBox(height: 8),

                                  Text(
                                    ticket.tipologia ?? "N/A",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                    const SizedBox(height: 8),

                                  // IconButton(
                                  //   padding: EdgeInsets.zero,
                                  //   constraints: const BoxConstraints(),
                                  //   iconSize: 18,
                                  //   onPressed: () async {
                                  //     final response = await http.delete(
                                  //       Uri.parse(
                                  //         "${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/${ticket.id}",
                                  //       ),
                                  //     );
                                  //     if (response.statusCode == 200) {
                                  //       setState(() {
                                  //         _tickets?.remove(ticket);
                                  //       });
                                  //       ScaffoldMessenger.of(
                                  //         context,
                                  //       ).showSnackBar(
                                  //         const SnackBar(
                                  //           content: Text(
                                  //             "Ticket eliminato con successo!",
                                  //           ),
                                  //         ),
                                  //       );
                                  //     } else {
                                  //       ScaffoldMessenger.of(
                                  //         context,
                                  //       ).showSnackBar(
                                  //         const SnackBar(
                                  //           content: Text(
                                  //             "Errore durante l'eliminazione del ticket.",
                                  //           ),
                                  //         ),
                                  //       );
                                  //     }
                                  //   },
                                  //   icon: const Icon(
                                  //     Icons.clear,
                                  //     color: Colors.white,
                                  //     size: 12,
                                  //   ),
                                  //   style: IconButton.styleFrom(
                                  //     backgroundColor: const Color.fromARGB(
                                  //       255,
                                  //       200,
                                  //       100,
                                  //       100,
                                  //     ),
                                  //     fixedSize: const Size(18, 18),
                                  //   ),

                                  // ),
                                    const SizedBox(height: 8),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
