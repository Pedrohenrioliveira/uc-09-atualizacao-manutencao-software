import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/depoimento_model.dart';
import '../core/api/api_service.dart';

class DepoimentoController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Depoimento> depoimentos = [];
  bool isLoading = false;

  Future<void> carregarDepoimentos() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.client.get('/api/depoimentos');
      if (response.data != null) {
        depoimentos = (response.data as List).map((i) => Depoimento.fromJson(i)).toList();
      }
    } catch (e) {
      debugPrint("Erro ao carregar depoimentos: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarDepoimento(String nomeCliente, String texto, PlatformFile arquivo) async {
    try {
      final formData = FormData.fromMap({
        'NomeCliente': nomeCliente,
        'Texto': texto,
        'Arquivo': MultipartFile.fromBytes(
          arquivo.bytes!,
          filename: arquivo.name,
        ),
      });
      await _apiService.client.post('/api/depoimentos/upload', data: formData);
      await carregarDepoimentos(); // Recarrega a lista
    } catch (e) {
      debugPrint("Erro ao adicionar depoimento: $e");
    }
  }

  Future<void> editarDepoimento(String id, String nomeCliente, String texto) async {
    try {
      await _apiService.client.put('/api/depoimentos/$id', data: {
        'nomeCliente': nomeCliente,
        'texto': texto
      });
      await carregarDepoimentos(); // Recarrega a lista
    } catch (e) {
      debugPrint("Erro ao editar depoimento: $e");
    }
  }

  Future<void> deletarDepoimento(String id) async {
    try {
      await _apiService.client.delete('/api/depoimentos/$id');
      depoimentos.removeWhere((d) => d.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao deletar depoimento: $e");
    }
  }
}
