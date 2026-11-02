import 'cuenta.dart';
import 'estrategia_redondeo.dart';
import 'resultado.dart';

/// Calcula cuánto paga cada persona: (monto + propina) / personas.
/// El redondeo lo decide la estrategia que recibe; aquí no se pregunta de qué tipo es.
class CalcularDivision {
  final EstrategiaRedondeo _estrategia;

  const CalcularDivision(this._estrategia);

  Resultado call(Cuenta cuenta) {
    final total = cuenta.monto * (1 + cuenta.propina / 100);
    return Resultado(_estrategia.redondear(total / cuenta.personas));
  }
}
