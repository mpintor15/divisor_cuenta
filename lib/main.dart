import 'package:flutter/material.dart';

import 'data/redondeo_exacto.dart';
import 'data/redondeo_hacia_arriba.dart';
import 'domain/calcular_division.dart';
import 'domain/validar_entrada.dart';
import 'presentation/divisor_controller.dart';
import 'presentation/formateador_moneda.dart';
import 'presentation/lector_numeros.dart';
import 'presentation/pantalla_divisor.dart';

void main() {
  final controlador = DivisorController(
    calculadoras: {
      'Exacto': CalcularDivision(RedondeoExacto()),
      'Hacia arriba': CalcularDivision(RedondeoHaciaArriba()),
    },
    modoInicial: 'Exacto',
    validar: const ValidarEntrada(),
    formateador: const FormateadorMoneda(),
    lector: const LectorNumeros(),
  );

  runApp(DivisorApp(controlador: controlador));
}

class DivisorApp extends StatelessWidget {
  final DivisorController controlador;

  const DivisorApp({super.key, required this.controlador});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Divisor de cuenta',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: PantallaDivisor(controlador: controlador),
    );
  }
}
