import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../controllers/foto_controller.dart';

class FotosScreen extends StatefulWidget {
  const FotosScreen({super.key});

  @override
  State<FotosScreen> createState() => _FotosScreenState();
}

class _FotosScreenState extends State<FotosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FotoController>().carregarFotos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<FotoController>();

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
            const Text('Fotos Antes e Depois', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (controller.isLoading)
              const CircularProgressIndicator()
            else
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 300,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: controller.fotos.length,
                  itemBuilder: (context, index) {
                    final foto = controller.fotos[index];
                    return Card(
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: foto.caminhoFotoAntes.isNotEmpty
                                      ? Image.network('http://127.0.0.1:5118/${foto.caminhoFotoAntes}', fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image))
                                      : Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image))),
                                ),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: foto.caminhoFotoDepois.isNotEmpty
                                      ? Image.network('http://127.0.0.1:5118/${foto.caminhoFotoDepois}', fit: BoxFit.cover, errorBuilder: (c,e,s) => const Icon(Icons.broken_image))
                                      : Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image))),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text(foto.nomeCachorro, overflow: TextOverflow.ellipsis)),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.deletarFoto(foto.id!),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
          ],
        ),
      ),
    );
  }

  void _mostrarDialogAdicionar(BuildContext context) {
    final nomeController = TextEditingController();
    PlatformFile? arquivoAntes;
    PlatformFile? arquivoDepois;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Adicionar Nova Foto (Antes/Depois)'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome do Cachorro/Serviço')),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.image, withData: true);
                    if (result != null) {
                      setStateDialog(() {
                        arquivoAntes = result.files.first;
                      });
                    }
                  },
                  icon: const Icon(Icons.upload_file),
                  label: Text(arquivoAntes != null ? 'Antes: ${arquivoAntes!.name}' : 'Selecionar Foto Antes'),
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result = await FilePicker.pickFiles(type: FileType.image, withData: true);
                    if (result != null) {
                      setStateDialog(() {
                        arquivoDepois = result.files.first;
                      });
                    }
                  },
                  icon: const Icon(Icons.upload_file),
                  label: Text(arquivoDepois != null ? 'Depois: ${arquivoDepois!.name}' : 'Selecionar Foto Depois'),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
              ElevatedButton(
                onPressed: () {
                  if (arquivoAntes == null || arquivoDepois == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Selecione as DUAS imagens (Antes e Depois).')));
                    return;
                  }
                  context.read<FotoController>().adicionarFoto(nomeController.text, arquivoAntes!, arquivoDepois!);
                  Navigator.pop(context);
                }, 
                child: const Text('Salvar')
              ),
            ],
          );
        }
      ),
    );
  }
}
