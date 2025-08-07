import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/homePage.dart';
import 'package:flutter_application_1/insertNode.dart';
import 'package:flutter_application_1/specific_ticket.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// GoRouter configuration
final ValueNotifier<bool> refreshNotifier = ValueNotifier<bool>(false);

final _router = GoRouter(
  refreshListenable: refreshNotifier,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(title: 'Pizzini',key: UniqueKey(),),
    ),
    GoRoute(
      path: '/insert',
      builder: (context, state) => InsertPage(refreshNotifier: refreshNotifier,),
    ),
    GoRoute(
      path: '/ticket/:ticketId',
      builder: (context, state) {
        final ticketId = state.pathParameters['ticketId']!;
        return SpecificTicket(ticketId: ticketId);
      },
    ),
  ],
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carica env file

  // Errori Flutter
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    print('FlutterError: ${details.exceptionAsString()}');
  };
  await dotenv.load();

  // Cattura anche errori asincroni o esterni
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    print('Zoned Error: $error');
    print('StackTrace: $stackTrace');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 255, 243, 222),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 174, 0),
        ),
      ),
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
