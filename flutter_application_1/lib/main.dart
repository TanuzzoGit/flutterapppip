import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 174, 0),
        ),
      ),
      home: const MyHomePage(title: 'Lista '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<_ListaState> listaKey = GlobalKey<_ListaState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            shape: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Expanded(child: Lista(key: listaKey))],
          ),
        ),

        // These widgets will appear above the AppBar and everything else
        Positioned(
          top: 20,
          left: 0,
          right: 0,
          child: Center(
            child: FloatingActionButton(
              tooltip: "Aggiunti Un Nuovo Ticket",
              onPressed: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  listaKey.currentState?._getTickets();
                });
              },
              backgroundColor: Theme.of(context).colorScheme.surface,
              elevation: 1,
              shape: CircleBorder(
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 2,
                ),
              ),
              child: const Icon(Icons.refresh, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class Appunto {
  String? nomeAutore;
  String? nomeCliente;
  String? contenuto;
  DateTime? dataCreazione;
  String? statoPratica;
  Appunto({
    this.nomeAutore,
    this.nomeCliente,
    this.contenuto,
    this.statoPratica,
    this.dataCreazione,
  });
}

class fetchAppunto {
  Future<List<Appunto>> getAppunti() async {
    final temp = await http.get(
      Uri.parse('http://192.168.1.26:3000/api/appunti'),
    );
    final List<Appunto> appunti =
        (json.decode(temp.body) as List)
            .map(
              (data) => Appunto(
                nomeAutore: data['nomeAutore'],
                nomeCliente: data['nomePersona'],
                contenuto: data['contenuto'],
                statoPratica: data['statoPratica'],
                dataCreazione: DateTime.parse(data['dataCreazione']),
              ),
            )
            .toList();
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
  fetchAppunto fetcher = fetchAppunto();

  @override
  void initState() {
    super.initState();
    _getTickets();
  }

  void _getTickets() async {
    print("Fetching tickets...");
    final result = await fetcher.getAppunti();
    setState(() {
      _tickets = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children:
          (_tickets ?? []).map((ticket) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 1.0,
                ),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(
                      context,
                      label: "Autore",
                      value: ticket.nomeAutore ?? "Autore sconosciuto",
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      label: "Cliente",
                      value: ticket.nomeCliente ?? "Cliente sconosciuto",
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      label: "Contenuto",
                      value: ticket.contenuto ?? "Niente da mostrare",
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
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
