import 'package:flutter_application_1/components/myinputform.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/customfloat.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  String? _selectedStato;
  
  final controllerAutore = TextEditingController();
  final controllerCliente = TextEditingController();
  final controllerContenuto = TextEditingController();
  final controllerTipologia = TextEditingController();



  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Scaffold(
          appBar: Navbar(title: "Insert"),
          body: Container(
            height: height > 400 ? height - height * 0.2 : 400,
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(54),
              child: Card(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    //FARE REFRACTORING DI QUESTO OGGETTO IMMEDIATAMENTE PERCHé POTREI IMPAZZIRE PER ORA NON LO FACCIO PERCHé C'è TROPPA CONFUSIONE :: Rendere "InputForm"
                    //nella versione migliorata tutto questo deve sparire e diventare dinamico perché c'è da ammazzarsi a starci appresso. Tanto gli cambierò tutta la grafica
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyInputForm(label: "Nome Autore",controller: controllerAutore,),
                      MyInputForm(label: "Nome Cliente",controller: controllerCliente),
                       MyInputForm(label: "Contenuto",controller: controllerContenuto,),
                       
                        DropdownButtonExample(
                              dropdownValue: _selectedStato ?? "Informazione",
                              
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedStato = newValue;
                                  });
                                  print("Stato selezionato: $newValue");
                                  
                                }
                              },
                            ),
                      Container(
                        margin: EdgeInsets.all(16),
                        child:
                      ElevatedButton(
                        
                        onPressed: () {
                          testControllers();
                        },
                        child: const Text("Pubblica Ticket"),
                      ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        customfloat(),
      ],
    );
  }
  void testControllers(){
    print("Autore: ${controllerAutore.text}");
    print("Cliente: ${controllerCliente.text}");
    print("Contenuto: ${controllerContenuto.text}");
    print("Tipologia: ${controllerTipologia.text}");
  }
  void _CallApi(){
    final url = Uri.parse("${dotenv.env['IP_ADDR']}/api/appunti");
    http.post(url,headers: {
    "Content-Type": "application/json",
  },
  body: jsonEncode({
    "nomeAutore": controllerAutore.text,
    "nomePersona": controllerCliente.text,
    "contenuto": controllerContenuto.text,
    "tipologia": _selectedStato ?? "Informazione",
  })).then((response) {
      if (response.statusCode == 200) {
        print("Ticket inserito con successo");
        print("-------------------------------");
        print(response);
      } else {
        print("Errore nell'inserimento del ticket");
        print(response.body);
      }
    });
    controllerAutore.clear();
    controllerCliente.clear();
    controllerContenuto.clear();
    controllerTipologia.clear();
    context.go('/');
  }

}

class DropdownButtonExample extends StatefulWidget {
  final String dropdownValue;
  
  final Function(String?)? onChanged;
  
  const DropdownButtonExample({
    super.key,
    required this.dropdownValue,
    
    this.onChanged,
  });

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String? dropdownValue;
  List<String>? list = [
    "Informazione",
    "Ordine",
  ];
  
  @override
  void initState() {
    super.initState();
    
    
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
      items: list?.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }
}
