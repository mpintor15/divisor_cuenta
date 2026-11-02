/// Convierte el texto de un campo en un número. Devuelve null si no es válido.
class LectorNumeros {
  const LectorNumeros();

  /// Acepta punto o coma como separador decimal ("10.50" y "10,50" valen igual).
  double? leerDecimal(String texto) {
    final limpio = texto.trim().replaceAll(',', '.');
    final valor = double.tryParse(limpio);
    if (valor == null || valor.isNaN || valor.isInfinite) return null;
    return valor;
  }

  /// Solo enteros: "2.5", "abc" y el texto vacío devuelven null.
  int? leerEntero(String texto) => int.tryParse(texto.trim());
}
