import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/depoimento_controller.dart';
import '../../models/depoimento_model.dart';

class DepoimentosScreen extends StatefulWidget {
  const DepoimentosScreen({super.key});

  @override
  State<DepoimentosScreen> createState() => _DepoimentosScreenState();
}

class _DepoimentosScreenState extends State<DepoimentosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DepoimentoController>().carregarDepoimentos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<DepoimentoController>();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogAdicionar(context),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Depoimentos de Clientes', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (controller.isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                  itemCount: controller.depoimentos.length,
                  itemBuilder: (context, index) {
                    final depoimento = controller.depoimentos[index];
                    return Card(
                      child: ListTile(
                        leading: depoimento.caminhoFoto.isNotEmpty
                            ? Image.network('http://127.0.0.1:5118/${depoimento.caminhoFoto}', width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image))
                            : const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(depoimento.nomeCliente),
                        subtitle: Text('"${depoimento.texto}"'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _mostrarDialogEditar(context, depoimento),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deletarDepoimento(depoimento.id!),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _mostrarDialogAdicionar(BuildContext context) {
    final nomeController = TextEditingController();
    final textoController = TextEditingController();
    PlatformFile? arquivoSelecionado;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Adicionar Depoimento'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Cliente')),
                  TextField(controller: textoController, decoration: const InputDecoration(labelText: 'Depoimento'), maxLines: 3),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.pickFiles(type: FileType.image, withData: true);
                      if (result != null) {
                        setStateDialog(() {
                          arquivoSelecionado = result.files.first;
                        });
                      }
                    },
                    icon: const Icon(Icons.upload_file),
                    label: Text(arquivoSelecionado != null ? arquivoSelecionado!.name : 'Selecionar Foto'),
                  ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () {
                    if (arquivoSelecionado == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione uma imagem.')));
                      return;
                    }
                    context.read<DepoimentoController>().adicionarDepoimento(
                      nomeController.text,
                      textoController.text,
                      arquivoSelecionado!
                    );
                    Navigator.pop(context);
                  }, 
                  child: const Text('Salvar')
                ),
              ],
            );
          }
        );
      },
    );
  }

  void _mostrarDialogEditar(BuildContext context, Depoimento depoimento) {
    final nomeController = TextEditingController(text: depoimento.nomeCliente);
    final textoController = TextEditingController(text: depoimento.texto);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Depoimento (Sem Alterar Foto)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Cliente')),
            TextField(controller: textoController, decoration: const InputDecoration(labelText: 'Depoimento'), maxLines: 3),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              context.read<DepoimentoController>().editarDepoimento(depoimento.id!, nomeController.text, textoController.text);
              Navigator.pop(context);
            }, 
            child: const Text('Salvar')
          ),
        ],
      ),
    );
  }
}
