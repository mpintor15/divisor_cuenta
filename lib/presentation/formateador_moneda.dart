/// Convierte un importe en texto con dos decimales y punto, sin símbolo de moneda.
class FormateadorMoneda {
  const FormateadorMoneda();

  String formatear(double importe) => importe.toStringAsFixed(2);
}
