import 'package:flutter/material.dart';
import '../models/agendamento_model.dart';
import '../core/api/api_service.dart';

class AgendamentoController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Agendamento> agendamentos = [];
  bool isLoading = false;

  Future<void> carregarAgendamentos() async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await _apiService.client.get('/api/agendamentos');
      if (response.data != null) {
        agendamentos = (response.data as List).map((i) => Agendamento.fromJson(i)).toList();
      }
    } catch (e) {
      debugPrint("Erro ao carregar agendamentos: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> deletarAgendamento(String id) async {
    try {
      await _apiService.client.delete('/api/agendamentos/$id');
      agendamentos.removeWhere((a) => a.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint("Erro ao deletar agendamento: $e");
    }
  }
}
