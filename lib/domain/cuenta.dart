/// Los datos que el usuario ingresa para dividir la cuenta.
class Cuenta {
  final double monto;
  final int personas;
  final double propina;

  const Cuenta({
    required this.monto,
    required this.personas,
    required this.propina,
  });
}
