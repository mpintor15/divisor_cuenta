# Implementation Plan: Divisor de cuenta

**Branch**: `sdd` | **Date**: 2026-10-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-divisor-cuenta/spec.md`

## Summary

App Flutter de una sola pantalla que calcula cuánto paga cada persona: (monto + propina sobre el
monto) ÷ personas, con dos modos de redondeo intercambiables (exacto y hacia arriba). El cálculo
vive en un `domain` de Dart puro; el redondeo es una interfaz de un solo método con dos
implementaciones; la pantalla recibe sus dependencias por constructor y `main.dart` es el único
punto de composición. Sin paquetes externos ni red.

## Technical Context

**Language/Version**: Dart / Flutter, SDK estable (instalado: Flutter 3.47.1)

**Primary Dependencies**: ninguna externa; solo el SDK de Flutter

**Storage**: N/A (sin red ni base de datos; FR-010)

**Testing**: `flutter_test` (pruebas de `domain` en Dart puro y pruebas de widget)

**Target Platform**: Android e iOS (la comprobación de construcción es `flutter build apk --debug`)

**Project Type**: mobile-app (una sola pantalla)

**Performance Goals**: N/A; un cálculo aritmético por toque

**Constraints**: offline; sin paquetes externos; estado local con `setState`; `lib/domain/` sin
`package:flutter`

**Scale/Scope**: 1 pantalla, 2 modos de redondeo, 13 requisitos funcionales

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principio | Cómo lo cumple el plan | Estado |
|---|---|---|
| I. SRP | `ValidarEntrada` solo valida; `CalcularDivision` solo calcula; `FormateadorMoneda` solo formatea; `LectorNumeros` solo convierte texto en números | Pasa |
| I. OCP | Un redondeo nuevo es una clase nueva que implementa `EstrategiaRedondeo` más una línea en `main.dart`; no se edita ninguna clase existente | Pasa |
| I. LSP | `CalcularDivision` usa la interfaz sin `is`/`as`; ambas estrategias son intercambiables | Pasa |
| I. ISP | `EstrategiaRedondeo` tiene un solo método | Pasa |
| I. DIP | `DivisorController` recibe abstracciones/`domain` por constructor; no nombra clases de `data` | Pasa |
| II. Capas | `presentation -> domain <- data`; `domain` sin `package:flutter` | Pasa |
| II. Composición | Solo `main.dart` instancia `RedondeoExacto()` y `RedondeoHaciaArriba()` | Pasa |
| III. Seguridad | No hay secretos, claves ni red | Pasa |
| IV. Pruebas | Los 6 escenarios son pruebas ejecutables; más pruebas de widget y de LSP | Pasa |
| V. Regla de la materia | Clases pequeñas con un propósito claro, explicables una a una | Pasa |

Sin violaciones; no se requiere la sección Complexity Tracking.

**Re-evaluación tras el diseño (Phase 1)**: sin cambios; todos los principios siguen cumpliéndose.

## Project Structure

### Documentation (this feature)

```text
specs/001-divisor-cuenta/
├── plan.md              # Este archivo
├── research.md          # Decisiones y alternativas
├── data-model.md        # Entidades, reglas de validación y la interfaz
├── quickstart.md        # Cómo ejecutar y verificar
└── tasks.md             # Lo genera /speckit-tasks (no este comando)
```

No hay `contracts/`: la app no expone interfaces externas (sin red ni API).

### Source Code (repository root)

```text
lib/
├── domain/
│   ├── cuenta.dart                    # entidad: monto, personas, propina
│   ├── resultado.dart                 # entidad: importe por persona
│   ├── estrategia_redondeo.dart       # interfaz de un método
│   ├── calcular_division.dart         # caso de uso: calcula
│   └── validar_entrada.dart           # caso de uso: valida y devuelve el mensaje
├── data/
│   ├── redondeo_exacto.dart           # implementación
│   └── redondeo_hacia_arriba.dart     # implementación
├── presentation/
│   ├── divisor_controller.dart        # recibe sus dependencias por constructor
│   ├── formateador_moneda.dart        # solo formatea (dos decimales, sin símbolo)
│   ├── lector_numeros.dart            # solo convierte texto en números (punto o coma)
│   └── pantalla_divisor.dart          # solo dibuja
└── main.dart                          # único punto de composición

test/
├── casos_de_prueba.dart               # los 6 casos de la spec (tabla de datos)
├── division_test.dart                 # recorre la tabla + prueba de LSP (sin widgets)
└── pantalla_test.dart                 # pruebas de widget
```

**Structure Decision**: tres capas como en la constitución. Se sigue el reparto de archivos del
plan del curso, con una clase adicional en `presentation` (`LectorNumeros`), necesaria para cumplir
FR-013 y las respuestas de clarificación sin darle al `domain` la responsabilidad de interpretar
texto. Ver `research.md`, decisión 3.

## Complexity Tracking

Sin violaciones de la constitución que justificar.
