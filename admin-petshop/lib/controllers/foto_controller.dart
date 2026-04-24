import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/foto_antes_depois_model.dart';
import '../core/api/api_service.dart';

class FotoController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<FotoAntesDepois> fotos = [];
  bool isLoading = false;

  Future<void> carregarFotos() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.client.get('/api/fotos');
      if (response.data != null) {
        fotos = (response.data as List).map((i) => FotoAntesDepois.fromJson(i)).toList();
      }
    } catch (e) {
      debugPrint("Erro ao carregar fotos: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> adicionarFoto(String nomeCachorro, PlatformFile arquivoAntes, PlatformFile arquivoDepois) async {
    isLoading = true;
    notifyListeners();

    try {
      final formData = FormData.fromMap({
        'NomeCachorro': nomeCachorro,
        'ArquivoAntes': MultipartFile.fromBytes(
          arquivoAntes.bytes!,
          filename: arquivoAntes.name,
        ),
        'ArquivoDepois': MultipartFile.fromBytes(
          arquivoDepois.bytes!,
          filename: arquivoDepois.name,
        ),
      });

      await _apiService.client.post('/api/fotos/upload', data: formData);
      await carregarFotos();
    } catch (e) {
      debugPrint("Erro ao adicionar foto: $e");
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deletarFoto(int id) async {
    try {
      await _apiService.client.delete('/api/fotos/$id');
      fotos.removeWhere((f) => f.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao deletar foto: $e");
    }
  }
}
