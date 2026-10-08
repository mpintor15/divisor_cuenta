import 'package:flutter_test/flutter_test.dart';

import 'package:divisor_cuenta/data/redondeo_exacto.dart';
import 'package:divisor_cuenta/data/redondeo_hacia_arriba.dart';
import 'package:divisor_cuenta/domain/calcular_division.dart';
import 'package:divisor_cuenta/domain/cuenta.dart';
import 'package:divisor_cuenta/domain/estrategia_redondeo.dart';
import 'package:divisor_cuenta/domain/validar_entrada.dart';

import 'casos_de_prueba.dart';

EstrategiaRedondeo _estrategiaDe(String modo) =>
    modo == 'arriba' ? RedondeoHaciaArriba() : RedondeoExacto();

void main() {
  const validar = ValidarEntrada();

  group('escenarios de la spec', () {
    for (final caso in casos) {
      test(caso.nombre, () {
        final error = validar(
          monto: caso.monto,
          personas: caso.personas,
          propina: caso.propina,
        );

        if (caso.errorEsperado != null) {
          // Debe dar exactamente ese mensaje y no se calcula nada.
          expect(error, caso.errorEsperado);
          return;
        }

        expect(error, isNull);
        final resultado = CalcularDivision(_estrategiaDe(caso.modo))(
          Cuenta(
            monto: caso.monto,
            personas: caso.personas,
            propina: caso.propina,
          ),
        );
        expect(resultado.importePorPersona, closeTo(caso.esperado!, 0.001));
      });
    }
  });

  test('LSP: el mismo CalcularDivision funciona con cualquier estrategia', () {
    const cuenta = Cuenta(monto: 10.00, personas: 3, propina: 0);

    // Se recorre una lista de EstrategiaRedondeo sin if ni cast.
    final estrategias = <EstrategiaRedondeo>[
      RedondeoExacto(),
      RedondeoHaciaArriba(),
    ];
    final importes = [
      for (final e in estrategias)
        CalcularDivision(e)(cuenta).importePorPersona,
    ];

    expect(importes[0], closeTo(3.33, 0.001));
    expect(importes[1], closeTo(4.00, 0.001));
  });
}
