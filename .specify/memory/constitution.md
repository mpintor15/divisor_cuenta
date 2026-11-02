# divisor_cuenta Constitution

## Core Principles

### I. Calidad de código: SOLID
El código MUST respetar los cinco principios SOLID, y cada uno MUST poder comprobarse:

- **SRP**: una clase, una razón de cambio. El cálculo MUST NOT validar ni formatear.
  Verificación: `grep -n -E "toStringAsFixed|inválido|al menos una persona" lib/domain/calcular_division.dart`
  no devuelve nada.
- **OCP**: agregar una nueva regla de redondeo MUST NOT obligar a editar las clases que ya existen;
  basta con crear una clase nueva que implemente la interfaz.
- **LSP**: cualquier implementación de una interfaz MUST poder sustituir a otra sin que quien la
  usa pregunte de qué tipo es.
  Verificación: `grep -n -E "is Redondeo|as Redondeo" lib/domain/calcular_division.dart` no devuelve nada.
- **ISP**: las interfaces MUST ser pequeñas; nadie depende de métodos que no usa.
- **DIP**: `presentation` MUST depender de abstracciones del `domain`, nunca de clases concretas
  de `data`.

### II. Arquitectura en tres capas
El proyecto MUST organizarse en `lib/presentation`, `lib/domain` y `lib/data`, con la regla de
dependencia `presentation -> domain <- data`.

- `lib/domain/` MUST ser Dart puro: no importa `package:flutter`.
  Verificación: `grep -rn "package:flutter" lib/domain/` no devuelve nada.
- `main.dart` MUST ser el ÚNICO lugar donde se instancian implementaciones concretas.
  Verificación: `grep -rn -E "RedondeoExacto\(\)|RedondeoHaciaArriba\(\)" lib/` solo aparece en
  `lib/main.dart`.

### III. Seguridad
Los secretos y las API keys MUST NOT guardarse en el repositorio.

### IV. Calidad y pruebas
Toda funcionalidad crítica MUST tener pruebas. Los criterios de aceptación de cada spec MUST
convertirse en pruebas ejecutables.

### V. Regla de la materia
Toda función generada por el agente MUST poder ser explicada por el estudiante: qué hace, por qué
existe, qué recibe, qué devuelve y qué errores produce.

## Governance

Esta constitución prevalece sobre cualquier otra práctica del proyecto. Una enmienda MUST
registrarse en este archivo con una nueva versión (MAJOR: se elimina o redefine un principio;
MINOR: se agrega un principio o se amplía materialmente; PATCH: aclaraciones de redacción).
Antes de dar por terminado un cambio MUST ejecutarse `flutter analyze` y `flutter test`, y las
verificaciones por `grep` descritas en los principios I y II. La guía de trabajo del agente en
tiempo de ejecución está en `CLAUDE.md`.

**Version**: 1.0.0 | **Ratified**: 2026-10-08 | **Last Amended**: 2026-10-08
