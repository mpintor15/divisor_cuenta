# Quickstart: Divisor de cuenta

## Ejecutar

```bash
flutter pub get
flutter run
```

## Verificar los escenarios a mano

| Monto | Personas | Propina | Modo | Debe mostrar |
|---|---|---|---|---|
| 100 | 4 | 10 | Exacto | 27.50 |
| 90 | 3 | 0 | Exacto | 30.00 |
| 50 | 0 | 0 | Exacto | «Debe haber al menos una persona» y ningún resultado |
| abc | 4 | 0 | Exacto | «Monto inválido» y ningún resultado |
| 10 | 3 | 0 | Exacto | 3.33 |
| 10 | 3 | 0 | Hacia arriba | 4.00 |
| 10,50 | 1 | 0 | Exacto | 10.50 |

## Verificar con comandos

```bash
flutter analyze
flutter test
flutter build apk --debug

grep -rn "package:flutter" lib/domain/
grep -rn -E "RedondeoExacto\(\)|RedondeoHaciaArriba\(\)" lib/
grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart
grep -n -E "toStringAsFixed|inválido|al menos una persona" lib/domain/calcular_division.dart
```

Las cuatro últimas deben devolver nada, salvo la segunda, que solo debe aparecer en `lib/main.dart`.
