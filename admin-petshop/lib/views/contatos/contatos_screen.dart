import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/contato_controller.dart';

class ContatosScreen extends StatefulWidget {
  const ContatosScreen({super.key});

  @override
  State<ContatosScreen> createState() => _ContatosScreenState();
}

class _ContatosScreenState extends State<ContatosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContatoController>().carregarContatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ContatoController>();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Contatos Recebidos (Somente Leitura)', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          if (controller.isLoading) 
            const CircularProgressIndicator()
          else
            Expanded(
              child: ListView.builder(
                itemCount: controller.contatos.length,
                itemBuilder: (context, index) {
                  final contato = controller.contatos[index];
                  return Card(
                    child: ListTile(
                      title: Text(contato.nome),
                      subtitle: Text('${contato.email} - ${contato.mensagem}\nRecebido em: ${contato.data.toString().substring(0, 16)}'),
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
