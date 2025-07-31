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
                      TextFormField(
                        controller: controllerAutore,
                        decoration: const InputDecoration(
                          labelText: "Nome Autore",
                        ),
                        
                      ),
                      TextFormField(
                        controller: controllerCliente,
                        decoration: const InputDecoration(
                          labelText: "Nome Cliente",
                        ),
                      ),
                       TextFormField(
                        controller: controllerContenuto,
                        decoration: const InputDecoration(
                          labelText: "Contenuto Ticket",
                        ),
                       ),
                        TextFormField(
                        controller: controllerTipologia,
                        decoration: const InputDecoration(
                          labelText: "Tipologia Richiesta",
                        ),
                       ),
                      Container(
                        margin: EdgeInsets.all(16),
                        child:
                      ElevatedButton(
                        
                        onPressed: () {
                          _CallApi();
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

  void _CallApi(){
    final url = Uri.parse("${dotenv.env['IP_ADDR']}:${dotenv.env['PORT']}/api/appunti");
    http.post(url,headers: {
    "Content-Type": "application/json",
  },
  body: jsonEncode({
    "nomeAutore": controllerAutore.text,
    "nomePersona": controllerCliente.text,
    "contenuto": controllerContenuto.text,
    "tipologia": controllerTipologia.text,
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
