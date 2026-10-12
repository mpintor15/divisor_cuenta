/// Decide si los datos permiten calcular. Devuelve el mensaje de error, o null si todo es válido.
/// Orden de las reglas: monto, personas, propina. Un valor null o NaN cuenta como inválido.
class ValidarEntrada {
  const ValidarEntrada();

  String? call({
    required double? monto,
    required int? personas,
    required double? propina,
  }) {
    if (monto == null || monto.isNaN || monto <= 0) return 'Monto inválido';
    if (personas == null || personas < 0) return 'Número de personas inválido';
    if (personas == 0) return 'Debe haber al menos una persona';
    if (propina == null || propina.isNaN || propina < 0) {
      return 'Propina inválida';
    }
    if (propina > 100) return 'La propina no puede superar el 100%';
    return null;
  }
}
