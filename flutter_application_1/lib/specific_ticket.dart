import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/RoundedButton.dart';
import 'package:flutter_application_1/components/commentcard.dart';
import 'package:flutter_application_1/components/custRectanglebutton.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_application_1/components/takeResp.dart';
import 'package:flutter_application_1/infobox.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'palette.dart' as pals;

const List<String> stati = <String>[
  'Prendere in Carico',
  'In Lavorazione',
  'Attende Risposta',
  'Attendiamo Risposta',
  'Chiuso',
];
const List<String> colleghi = <String>[
  'Da Prendere In Carico',
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

  const SpecificTicket({required this.ticketId});

  @override
  State<SpecificTicket> createState() => _SpecificTicketState();
}

class _SpecificTicketState extends State<SpecificTicket> {
  final GlobalKey commentKey = GlobalKey<_SpecificTicketState>();
  Map<String, dynamic>? _ticketDetails;
  List<dynamic> _comments = [];
  final ScrollController mainScroll = ScrollController();

  String? _selectedStato;
  String? _selectedResponsabile;
  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
  }

  Future<void> _fetchTicketDetails() async {
    final response = await http.get(
      Uri.parse(
        '${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/${widget.ticketId}',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _ticketDetails = json.decode(response.body);
        print(_ticketDetails);
        // Inizializza i valori selezionati
        _selectedStato = _ticketDetails!['statoPratica'] ?? stati.first;
        _selectedResponsabile =
            _ticketDetails!['dipendenteResponsabile'] ?? colleghi.first;
      });
    } else {
      throw Exception('Failed to load ticket details');
    }
    print(widget.ticketId);
    String? finalUrl =
        dotenv.env['PROD'] == "true"
            ? '${dotenv.env['IP_ADDR']}'
            : dotenv.env['DEV'];
    final res2 = await http.get(
      Uri.parse("${finalUrl}/api/commenti/${widget.ticketId}"),
    );
    print("${finalUrl}/api/commenti/${widget.ticketId}");

    if (res2.statusCode == 200) {
      setState(() {
        _comments = json.decode(res2.body);
        print(_comments);
      });
    } else {
      throw Exception('Failed to load ticket details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: Navbar(title: "Ticket Details"),
            body:
                _ticketDetails == null
                    ? Center(child: CircularProgressIndicator())
                    : Scrollbar(
                      child: SingleChildScrollView(
                        controller: mainScroll,
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              Card(
                                color: Colors.white,

                                elevation: 5,

                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(18),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // ElevatedButton(onPressed: (){
                                      //   mainScroll.jumpTo(mainScroll.position.maxScrollExtent);
                                      //   // mainScroll.animateTo(mainScroll.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.easeInBack);
                                      // }, child: Icon(Icons.arrow_downward)),
                                      infobox(
                                        label: "Autore",
                                        value: _ticketDetails?["nomeAutore"],
                                        icon: Icon(
                                          Icons.person_outline,
                                          color: Color.fromARGB(
                                            255,
                                            46,
                                            142,
                                            211,
                                          ),
                                        ),
                                        avatarColor: Color.fromARGB(
                                          255,
                                          217,
                                          238,
                                          253,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      infobox(
                                        label: "Cliente",
                                        value: _ticketDetails?["nomePersona"],
                                        icon: Icon(
                                          Icons.work_outline_outlined,
                                          color: Color.fromARGB(
                                            255,
                                            25,
                                            197,
                                            34,
                                          ),
                                        ),
                                        avatarColor: Color.fromARGB(
                                          255,
                                          190,
                                          255,
                                          193,
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Text(
                                            "Stato: ",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                            ),
                                          ),
                                          DropdownButtonExample(
                                            dropdownValue:
                                                _selectedStato ?? stati.first,
                                            list: stati,
                                            onChanged: (String? newValue) {
                                              if (newValue != null) {
                                                setState(() {
                                                  _selectedStato = newValue;
                                                });
                                                print(
                                                  "Stato selezionato: $newValue",
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: 10),
                                      //TODO fare i dropdown stilizzandoli e rendendoli dinamici
                                      infobox(avatarColor: const Color.fromARGB(255, 146, 255, 244),icon: Icon(Icons.person_4_outlined),label: "Responsabile",value: _ticketDetails?['dipendenteResponsabile'] ?? "NA",),
                                      //TODO mettere nel footer
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          //Cimitero dei bottoni
                                          // ElevatedButton.icon(
                                          //   icon: Icon(Icons.save),
                                          //   label: Text(""),

                                          //   onPressed: () {
                                          //     _updateTicket();
                                          //   },
                                          //   style: ElevatedButton.styleFrom(
                                          //     iconSize: 12,
                                          //     backgroundColor:
                                          //         Theme.of(
                                          //           context,
                                          //         ).colorScheme.primary,
                                          //     foregroundColor: Colors.white,
                                          //     // padding: EdgeInsets.symmetric(
                                          //     //   horizontal: 24,
                                          //     //   vertical: 12,
                                          //     // ),
                                          //   ),
                                          // ),
                                          // Container(
                                          //   padding: EdgeInsets.all(0),
                                          //   decoration: BoxDecoration(
                                          //     borderRadius: BorderRadius.circular(
                                          //       50,
                                          //     ),
                                          //     boxShadow: [
                                          //       BoxShadow(
                                          //         color: const Color.fromARGB(
                                          //           113,
                                          //           0,
                                          //           0,
                                          //           0,
                                          //         ),
                                          //         blurRadius: 15,
                                          //         spreadRadius: 0,
                                          //       ),
                                          //     ],
                                          //     color:
                                          //         Theme.of(
                                          //           context,
                                          //         ).colorScheme.primary,
                                          //   ),
                                          //   child: IconButton(
                                          //     onPressed: _updateTicket,
                                          //     icon: Icon(
                                          //       Icons.save,
                                          //       color: Colors.white,
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Roundedbutton(
                                boxshadow: const Color.fromARGB(57, 0, 0, 0),
                                bgcolor: pals.roundedbuttonBGC,
                                border: BoxBorder.all(
                                  color: pals.dividerStroke,
                                  width: 0.9,
                                ),
                                ico: Icon(
                                  Icons.note_add_outlined,
                                  color: Colors.black,
                                ),
                                fun: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        child: Takeresp(ticketId:widget.ticketId,updateTickets: _fetchTicketDetails,)
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 12),

                              // Container(child: Column(children: [SingleChildScrollView(child:Column(children:[
                              //   Container(child:Text("BBBBBBBBbb"),decoration: BoxDecoration(color: const Color.fromARGB(255,247,187,76,),borderRadius: BorderRadius.only(
                              //                          bottomRight: Radius.circular(15),
                              //                          topRight: Radius.circular(15),
                              //                          bottomLeft: Radius.circular(15),
                              //                        ),
                              //                      ),)]))]))
                              Padding(
                                padding: EdgeInsets.all(0),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    mainScroll.animateTo(
                                      mainScroll.position.maxScrollExtent,
                                      duration: Duration(milliseconds: 190),
                                      curve: Curves.easeIn,
                                    );
                                  },
                                  child: commentcard(
                                    comments: _comments,
                                    ticketId: widget.ticketId,
                                    updateTickets: _fetchTicketDetails,
                                    content:
                                        _ticketDetails?['contenuto'] ?? "NA",
                                  ),
                                ),
                              ),
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
                            ],
                          ),
                        ),
                      ),
                    ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.all(8),

              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: const Color.fromARGB(61, 0, 0, 0),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Custrectanglebutton(
                    ico: Icon(Icons.save, color: Colors.white),
                    label: "Salva Modifiche",
                    fun: _updateTicket,
                    primaryColor: pals.navbarButtonPrimary,
                    textColor: pals.textWhite,
                  ),
                ],
              ),
            ),
          ),

          // customfloat(),
        ],
      ),
    );
  }

  Future<void> _updateTicket() async {
    final url =
        '${dotenv.env['PROD'] == "true" ? dotenv.env['IP_ADDR'] : dotenv.env['DEV']}/api/appunti/${widget.ticketId}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'statoPratica': _selectedStato,
          'dipendenteResponsabile': _selectedResponsabile,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Modifiche salvate con successo')),
        );
      } else if (response.statusCode == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Errore durante il salvataggio: ${response.body}'),
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
