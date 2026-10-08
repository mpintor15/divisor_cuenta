import '../domain/estrategia_redondeo.dart';

/// Redondea al centavo más cercano (dos decimales).
class RedondeoExacto implements EstrategiaRedondeo {
  @override
  double redondear(double valor) => (valor * 100).round() / 100;
}
