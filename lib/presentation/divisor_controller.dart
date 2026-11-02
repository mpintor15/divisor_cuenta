import '../domain/calcular_division.dart';
import '../domain/cuenta.dart';
import '../domain/validar_entrada.dart';
import 'formateador_moneda.dart';
import 'lector_numeros.dart';

/// Une lo que escribe el usuario con el cálculo. Recibe todo por constructor.
class DivisorController {
  /// Un cálculo por modo de redondeo, con el nombre que ve el usuario.
  final Map<String, CalcularDivision> _calculadoras;
  final ValidarEntrada _validar;
  final FormateadorMoneda _formateador;
  final LectorNumeros _lector;

  DivisorController({
    required Map<String, CalcularDivision> calculadoras,
    required String modoInicial,
    required this._validar,
    required this._formateador,
    required this._lector,
  })  : _calculadoras = calculadoras,
        modo = modoInicial,
        assert(calculadoras.containsKey(modoInicial));

  /// Nombres de los modos de redondeo disponibles.
  List<String> get modos => _calculadoras.keys.toList();

  /// Modo elegido. Cambiarlo no recalcula: el resultado se actualiza al calcular de nuevo.
  String modo;

  /// Importe por persona ya formateado; null si no hay nada que mostrar.
  String? resultado;

  /// Mensaje de error de la última validación; null si no hubo error.
  String? error;

  void calcular({
    required String monto,
    required String personas,
    required String propina,
  }) {
    final m = _lector.leerDecimal(monto);
    final p = _lector.leerEntero(personas);
    final t = _lector.leerDecimal(propina);

    resultado = null;
    error = _validar(monto: m, personas: p, propina: t);
    if (error != null) return;

    final r = _calculadoras[modo]!(Cuenta(monto: m!, personas: p!, propina: t!));
    resultado = _formateador.formatear(r.importePorPersona);
  }
}
