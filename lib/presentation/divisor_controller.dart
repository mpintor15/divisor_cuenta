import '../domain/calcular_division.dart';
import '../domain/cuenta.dart';
import 'formateador_moneda.dart';
import 'lector_numeros.dart';

/// Une lo que escribe el usuario con el cálculo. Recibe todo por constructor.
class DivisorController {
  final CalcularDivision _calcular;
  final FormateadorMoneda _formateador;
  final LectorNumeros _lector;

  DivisorController({
    required this._calcular,
    required this._formateador,
    required this._lector,
  });

  /// Importe por persona ya formateado; null si no hay nada que mostrar.
  String? resultado;

  void calcular({
    required String monto,
    required String personas,
    required String propina,
  }) {
    final m = _lector.leerDecimal(monto);
    final p = _lector.leerEntero(personas);
    final t = _lector.leerDecimal(propina);

    // Provisional: la validación con mensajes llega en la historia 2.
    if (m == null || p == null || t == null || m <= 0 || p < 1 || t < 0) {
      resultado = null;
      return;
    }

    final r = _calcular(Cuenta(monto: m, personas: p, propina: t));
    resultado = _formateador.formatear(r.importePorPersona);
  }
}
