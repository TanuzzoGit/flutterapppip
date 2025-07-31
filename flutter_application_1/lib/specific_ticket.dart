
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/customfloat.dart';
import 'package:flutter_application_1/components/navbar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SpecificTicket extends StatefulWidget{
  final String ticketId;

  const SpecificTicket({super.key, required this.ticketId});

  @override
  State<SpecificTicket> createState() => _SpecificTicketState();
}

class _SpecificTicketState extends State<SpecificTicket> {
  Map<String, dynamic>? _ticketDetails;

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
  }

  Future<void> _fetchTicketDetails() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['IP_ADDR']}:3000/api/appunti/${widget.ticketId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        _ticketDetails = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load ticket details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack( children: [Scaffold(
      appBar: Navbar(title: "Ticket Details"),
      body: _ticketDetails == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Autore: ${_ticketDetails!['autore']}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Cliente: ${_ticketDetails!['cliente']}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Contenuto: ${_ticketDetails!['contenuto']}", style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text("Tipologia: ${_ticketDetails!['tipologia']}", style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
      
    )
    , customfloat()],
    );
  }
}