import 'package:app_glpi/login_page.dart';
import 'package:app_glpi/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lista_chamados.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final userProvider = await UserProvider.create();
  runApp(
    ChangeNotifierProvider.value(
      value: userProvider,
      child: const SafeArea(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => const LoginPage(),
        '/ticket_list': (context) => TicketListScreen(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(0, 165, 243, 1)),
        useMaterial3: true,
      ),
      home: const SafeArea(child: LoginPage()),
    );
  }
}
