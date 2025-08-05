import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/customfloat.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> stati = <String>[
  'Prendere in Carico',
  'In Lavorazione',
  'Attende Risposta',
  'Attendiamo Risposta',
  'Chiuso',
];
const List<String> colleghi = <String>[
  'Mario',
  'Lucrezia',
  'Massimo',
  'Damiano',
  'Gaetano',
  'Francesco',
  'Giuseppe',
];

class SpecificTicket extends StatefulWidget {
  final String ticketId;

  const SpecificTicket({super.key, required this.ticketId});

  @override
  State<SpecificTicket> createState() => _SpecificTicketState();
}

class _SpecificTicketState extends State<SpecificTicket> {
  Map<String, dynamic>? _ticketDetails;
  String? _selectedStato;
  String? _selectedResponsabile;

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
  }

  Future<void> _fetchTicketDetails() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/${widget.ticketId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _ticketDetails = json.decode(response.body);
        // Inizializza i valori selezionati
        _selectedStato = _ticketDetails!['statoPratica'] ?? stati.first;
        _selectedResponsabile =
            _ticketDetails!['dipendenteResponsabile'] ?? colleghi.first;
      });
    } else {
      throw Exception('Failed to load ticket details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: Navbar(title: "Ticket Details"),
          body:
              _ticketDetails == null
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Autore: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                _ticketDetails!['nomeAutore'] ?? 'N/A',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Cliente: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              Text(
                                _ticketDetails!['nomePersona'] ?? 'N/A',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Contenuto: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            _ticketDetails!['contenuto'] ?? 'N/A',
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),

                          Row(
                            children: [
                              Text(
                                "Stato: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              DropdownButtonExample(
                                dropdownValue: _selectedStato ?? stati.first,
                                list: stati,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedStato = newValue;
                                    });
                                    print("Stato selezionato: $newValue");
                                    
                                  }
                                },
                              ),
                            ],
                          ),
                          
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                "Responsabile: ",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              DropdownButtonExample(
                                dropdownValue:
                                    _selectedResponsabile ?? colleghi.first,
                                list: colleghi,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      _selectedResponsabile = newValue;
                                    });
                                    print(
                                      "Responsabile selezionato: $newValue",
                                    );
                                  }
                                },
                              ),
                              SizedBox(height: 50),
                            ],
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Data Ticket: ",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    _ticketDetails!['dataCreazione'].substring(
                                          0,
                                          10,
                                        ) ??
                                        'N/A',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              ElevatedButton.icon(
                                  icon: Icon(Icons.save),
                                  label: Text("Salva Modifiche"),
                                  onPressed: () {
                                    _updateTicket();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 24,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
        ),
        customfloat(),
      ],
    );
  }

  Future<void> _updateTicket() async {
    final url = '${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/${widget.ticketId}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'statoPratica': _selectedStato,
          'dipendenteResponsabile': _selectedResponsabile,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modifiche salvate con successo')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Errore durante il salvataggio: ${response.statusCode}',
            ),
          ),
        );
        print(response.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Errore di rete: $e')));
    }
  }
}

class DropdownButtonExample extends StatefulWidget {
  final String dropdownValue;
  final List<String>? list;
  final Function(String?)? onChanged;

  const DropdownButtonExample({
    super.key,
    required this.dropdownValue,
    required this.list,
    this.onChanged,
  });

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? dropdownValue;
  List<String>? list;

  @override
  void initState() {
    super.initState();
    list = widget.list;

    // Assicurati che il valore sia nella lista, altrimenti usa il primo elemento
    if (list != null && list!.contains(widget.dropdownValue)) {
      dropdownValue = widget.dropdownValue;
    } else if (list != null && list!.isNotEmpty) {
      dropdownValue = list!.first;
    }
    print("Dropdown value: $dropdownValue");
  }

  @override
  void didUpdateWidget(DropdownButtonExample oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dropdownValue != widget.dropdownValue) {
      setState(() {
        if (list != null && list!.contains(widget.dropdownValue)) {
          dropdownValue = widget.dropdownValue;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: TextStyle(color: Theme.of(context).colorScheme.primary),
      underline: Container(height: 2, color: Colors.deepPurpleAccent),
      onChanged: (String? value) {
        setState(() {
          dropdownValue = value;
        });
        // Chiama il callback del widget genitore
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }
      },
      items:
          list?.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
    );
  }
}
