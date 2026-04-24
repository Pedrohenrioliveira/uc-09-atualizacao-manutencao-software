import 'package:flutter/material.dart';
import '../models/contato_model.dart';
import '../core/api/api_service.dart';

class ContatoController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Contato> contatos = [];
  bool isLoading = false;

  Future<void> carregarContatos() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.client.get('/api/contatos');
      if (response.data != null) {
        contatos = (response.data as List).map((i) => Contato.fromJson(i)).toList();
      }
    } catch (e) {
      debugPrint("Erro ao carregar contatos: $e");
    }
    isLoading = false;
    notifyListeners();
  }
}
