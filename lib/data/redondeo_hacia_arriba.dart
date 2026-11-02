import '../domain/estrategia_redondeo.dart';

/// Sube al siguiente entero (si ya es entero, se mantiene).
/// El margen de 1e-9 absorbe el ruido de coma flotante: 25 * 1.12 da
/// 28.000000000000004 y sin el margen subiría a 29.
class RedondeoHaciaArriba implements EstrategiaRedondeo {
  static const _margen = 1e-9;

  @override
  double redondear(double valor) => (valor - _margen).ceilToDouble();
}
