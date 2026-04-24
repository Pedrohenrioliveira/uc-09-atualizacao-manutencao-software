import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/dashboard_controller.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardController>().carregarMetricas();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DashboardController>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (controller.isLoading)
            const Center(child: CircularProgressIndicator())
          else
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildCard('Agendamentos', '${controller.totalAgendamentos}', Icons.event, Colors.blue),
                _buildCard('Novos Contatos', '${controller.totalContatos}', Icons.contact_mail, Colors.green),
                _buildCard('Fotos na Galeria', '${controller.totalFotos}', Icons.photo, Colors.orange),
                _buildCard('Depoimentos', '${controller.totalDepoimentos}', Icons.star, Colors.amber),
              ],
            ),
          const SizedBox(height: 40),
          const Center(child: Text("Integração com Google Analytics/Clarity virá aqui.", style: TextStyle(color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
