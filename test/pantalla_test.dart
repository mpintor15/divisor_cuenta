import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';
import 'package:divisor_cuenta/main.dart';
import 'package:divisor_cuenta/presentation/divisor_controller.dart';
import 'package:divisor_cuenta/presentation/formateador_moneda.dart';
import 'package:divisor_cuenta/presentation/lector_numeros.dart';

DivisorApp _app() {
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
  return DivisorApp(controlador: controlador);
}

Future<void> _calcular(
  WidgetTester tester, {
  required String monto,
  required String personas,
  required String propina,
}) async {
  await tester.enterText(find.byKey(const Key('monto')), monto);
  await tester.enterText(find.byKey(const Key('personas')), personas);
  await tester.enterText(find.byKey(const Key('propina')), propina);
  await tester.tap(find.text('Calcular'));
  await tester.pump();
}

void main() {
  testWidgets('100, 4 personas y 10 % muestra 27.50', (tester) async {
    await tester.pumpWidget(_app());
    await _calcular(tester, monto: '100', personas: '4', propina: '10');

    expect(find.text('27.50'), findsOneWidget);
  });

  testWidgets('0 personas muestra el mensaje y ningún resultado', (tester) async {
    await tester.pumpWidget(_app());
    await _calcular(tester, monto: '50', personas: '0', propina: '0');

    expect(find.text('Debe haber al menos una persona'), findsOneWidget);
    expect(find.byKey(const Key('resultado')), findsNothing);
  });

  testWidgets('monto "abc" muestra "Monto inválido"', (tester) async {
    await tester.pumpWidget(_app());
    await _calcular(tester, monto: 'abc', personas: '4', propina: '0');

    expect(find.text('Monto inválido'), findsOneWidget);
  });
}
