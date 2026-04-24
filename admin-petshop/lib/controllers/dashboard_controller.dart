import 'package:flutter/material.dart';
import '../core/api/api_service.dart';

class DashboardController extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool isLoading = false;
  int totalAgendamentos = 0;
  int totalContatos = 0;
  int totalFotos = 0;
  int totalDepoimentos = 0;

  Future<void> carregarMetricas() async {
    isLoading = true;
    notifyListeners();

    try {
      final resAgendamentos = await _apiService.client.get('/api/agendamentos');
      if (resAgendamentos.data != null) {
        totalAgendamentos = (resAgendamentos.data as List).length;
      }

      final resContatos = await _apiService.client.get('/api/contatos');
      if (resContatos.data != null) {
        totalContatos = (resContatos.data as List).length;
      }

      final resFotos = await _apiService.client.get('/api/fotos');
      if (resFotos.data != null) {
        totalFotos = (resFotos.data as List).length;
      }

      final resDepoimentos = await _apiService.client.get('/api/depoimentos');
      if (resDepoimentos.data != null) {
        totalDepoimentos = (resDepoimentos.data as List).length;
      }
    } catch (e) {
      debugPrint("Erro ao carregar metricas: \$e");
    }

    isLoading = false;
    notifyListeners();
  }
}
