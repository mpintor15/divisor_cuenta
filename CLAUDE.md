# divisor_cuenta

App Flutter de una sola pantalla para dividir una cuenta entre varias personas.

## Estructura

- `lib/presentation/`: pantalla y controlador (la interfaz).
- `lib/domain/`: entidades, reglas y contratos (Dart puro).
- `lib/data/`: implementaciones concretas de los contratos del domain.

Regla de dependencia: `presentation -> domain <- data`.
`lib/domain/` no importa nada de `package:flutter`.

## Estándares

- Null safety.
- Nombres en español.
- Sin paquetes externos.

## Qué NO tocar

- No modificar `test/` sin que se pida.
- No agregar dependencias al `pubspec.yaml` sin avisar.
- No tocar `android/` ni `ios/`.

## Comandos

- `flutter pub get`
- `flutter run`
- `flutter analyze`
- `flutter test`
