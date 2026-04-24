import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/contato_controller.dart';
import 'controllers/dashboard_controller.dart';
import 'controllers/foto_controller.dart';
import 'controllers/depoimento_controller.dart';
import 'controllers/agendamento_controller.dart';

import 'views/layout/main_layout.dart';
import 'views/dashboard/dashboard_screen.dart';
import 'views/contatos/contatos_screen.dart';
import 'views/fotos/fotos_screen.dart';
import 'views/depoimentos/depoimentos_screen.dart';
import 'views/agendamentos/agendamentos_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DashboardController()),
        ChangeNotifierProvider(create: (_) => ContatoController()),
        ChangeNotifierProvider(create: (_) => FotoController()),
        ChangeNotifierProvider(create: (_) => DepoimentoController()),
        ChangeNotifierProvider(create: (_) => AgendamentoController()),
      ],
      child: const PatasFelizesAdminApp(),
    ),
  );
}

class PatasFelizesAdminApp extends StatelessWidget {
  const PatasFelizesAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patas Felizes Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainLayout(child: DashboardScreen()),
        '/agendamentos': (context) => const MainLayout(child: AgendamentosScreen()),
        '/contatos': (context) => const MainLayout(child: ContatosScreen()),
        '/fotos': (context) => const MainLayout(child: FotosScreen()),
        '/depoimentos': (context) => const MainLayout(child: DepoimentosScreen()),
      },
    );
  }
}
