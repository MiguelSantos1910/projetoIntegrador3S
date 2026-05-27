import '../models/esp.dart';
import '../services/esp_service.dart';

class EspController {
  final EspService _service = EspService();

  Future<Esp> carregarDados() async {
    return await _service.buscarUltimoDado();
  }
}