import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/agendamento_controller.dart';

class AgendamentosScreen extends StatefulWidget {
  const AgendamentosScreen({super.key});

  @override
  State<AgendamentosScreen> createState() => _AgendamentosScreenState();
}

class _AgendamentosScreenState extends State<AgendamentosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AgendamentoController>().carregarAgendamentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AgendamentoController>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Agendamentos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (controller.isLoading) 
            const CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: controller.agendamentos.length,
                itemBuilder: (context, index) {
                  final agendamento = controller.agendamentos[index];
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.event)),
                      title: Text('${agendamento.nomeTutor} - Pet: ${agendamento.nomePet}'),
                      subtitle: Text('Serviço: ${agendamento.servico} | Tel: ${agendamento.telefone}\nData: ${agendamento.dataAgendamento.toString().substring(0, 16)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deletarAgendamento(agendamento.id!),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
