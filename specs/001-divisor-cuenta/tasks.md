---

description: "Lista de tareas para implementar el divisor de cuenta"
---

# Tasks: Divisor de cuenta

**Input**: Documentos de diseño en `/specs/001-divisor-cuenta/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, quickstart.md

**Tests**: Las pruebas SÍ forman parte de esta lista (Fase 6), porque la constitución (principio IV) las exige.
`CLAUDE.md` prohíbe modificar `test/` sin que el usuario lo pida: el usuario las pide expresamente (guía, Parte 9) al
aprobar esta lista, y esa aprobación queda como la autorización para T001 y T021–T024.

**Organization**: Tareas agrupadas por historia de usuario.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: se puede ejecutar en paralelo (archivos distintos, sin dependencias)
- **[Story]**: historia a la que pertenece (US1, US2, US3)

## Path Conventions

Proyecto Flutter único: `lib/` en la raíz del repositorio, con `domain/`, `data/` y `presentation/`.

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Dejar el proyecto base listo para recibir el código

- [X] T001 Eliminar `test/widget_test.dart` (plantilla del contador: queda inválida al cambiar `lib/main.dart`). Autorizado por el usuario al aprobar esta lista (ver «Tests»)
- [X] T002 Crear las carpetas `lib/domain/`, `lib/data/` y `lib/presentation/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Entidades y contrato de los que dependen todas las historias

**⚠️ CRITICAL**: Ninguna historia puede empezar hasta terminar esta fase

- [X] T003 [P] Crear la entidad `Cuenta` (monto, personas, propina) en `lib/domain/cuenta.dart`
- [X] T004 [P] Crear la entidad `Resultado` (importePorPersona) en `lib/domain/resultado.dart`
- [X] T005 [P] Crear la interfaz `EstrategiaRedondeo` con un solo método `double redondear(double valor)` en `lib/domain/estrategia_redondeo.dart`

**Checkpoint**: `domain` básico listo, sin importar `package:flutter`

---

## Phase 3: User Story 1 - Calcular cuánto paga cada persona (Priority: P1) 🎯 MVP

**Goal**: Con monto, personas y propina válidos, mostrar el importe por persona con dos decimales, en modo exacto.

**Independent Test**: Ingresar 100, 4 personas y 10 % → 27.50; 90, 3, 0 % → 30.00; 10, 3, 0 % → 3.33; 10,50 con coma, 1 persona, 0 % → 10.50 (escenarios 1, 2, 5 y el de coma).

### Implementation for User Story 1

- [X] T006 [P] [US1] Implementar `RedondeoExacto` (redondea a dos decimales) en `lib/data/redondeo_exacto.dart`
- [X] T007 [US1] Implementar `CalcularDivision` (recibe una `EstrategiaRedondeo` por constructor; aplica `monto * (1 + propina / 100) / personas` y la estrategia) en `lib/domain/calcular_division.dart` (depende de T003, T004, T005)
- [X] T008 [P] [US1] Implementar `FormateadorMoneda` (dos decimales con punto, sin símbolo de moneda) en `lib/presentation/formateador_moneda.dart`
- [X] T009 [P] [US1] Implementar `LectorNumeros` (texto → `double?` / `int?`, acepta punto y coma, `null` si no es válido o si personas es decimal) en `lib/presentation/lector_numeros.dart`
- [X] T010 [US1] Implementar `DivisorController` (recibe sus dependencias por constructor; lee los campos, calcula y expone el resultado) en `lib/presentation/divisor_controller.dart` (depende de T007, T008, T009)
- [X] T011 [US1] Implementar `PantallaDivisor` (campos de monto, personas y propina, botón «Calcular» y el resultado en un `Text` propio que contiene solo el número, con «por persona» en otro `Text`) en `lib/presentation/pantalla_divisor.dart` (depende de T010)
- [X] T012 [US1] Componer en `lib/main.dart`: crear `CalcularDivision(RedondeoExacto())`, el controlador y `PantallaDivisor`; único lugar donde se instancian implementaciones concretas (depende de T006, T007, T011)

**Checkpoint**: La historia 1 funciona sola: calcula en modo exacto y entiende la coma decimal

---

## Phase 4: User Story 2 - Rechazar entradas inválidas con un mensaje claro (Priority: P1)

**Goal**: Ante entradas que no permiten calcular, mostrar el mensaje exacto y ningún resultado.

**Independent Test**: 50 y 0 personas → «Debe haber al menos una persona»; monto «abc», 0 o -50 → «Monto inválido»; propina vacía, -5 o «abc» → «Propina inválida»; personas vacío, -3, 2.5 o «abc» → «Número de personas inválido»; en todos, sin resultado.

### Implementation for User Story 2

- [X] T013 [US2] Implementar `ValidarEntrada` (recibe `double? monto`, `int? personas`, `double? propina`; devuelve `String?` con el mensaje exacto o `null`; orden: monto, personas, propina; `null` y `NaN` son inválidos) en `lib/domain/validar_entrada.dart` (depende de T003)
- [X] T014 [US2] Integrar `ValidarEntrada` en `DivisorController` en `lib/presentation/divisor_controller.dart`: si hay mensaje, se guarda y no se calcula; al recalcular con datos válidos el mensaje desaparece (depende de T010, T013)
- [X] T015 [US2] Mostrar el mensaje de error en `PantallaDivisor` y ocultar el resultado mientras haya error, en `lib/presentation/pantalla_divisor.dart` (depende de T011, T014)
- [X] T016 [US2] Pasar `ValidarEntrada` al controlador en la composición de `lib/main.dart` (depende de T012, T013)

**Checkpoint**: Las historias 1 y 2 funcionan juntas; nunca se muestra un importe con una entrada inválida

---

## Phase 5: User Story 3 - Elegir el modo de redondeo (Priority: P2)

**Goal**: Que el usuario elija entre exacto y hacia arriba, y el modo determine el importe.

**Independent Test**: 10, 3 personas, 0 % → 3.33 en exacto y 4.00 en hacia arriba (escenarios 5 y 6).

### Implementation for User Story 3

- [ ] T017 [P] [US3] Implementar `RedondeoHaciaArriba` (redondea a dos decimales y luego aplica `ceil`, para evitar ruido de coma flotante) en `lib/data/redondeo_hacia_arriba.dart`
- [ ] T018 [US3] Hacer que `DivisorController` reciba un `CalcularDivision` por modo y exponga el modo elegido (por defecto, exacto) en `lib/presentation/divisor_controller.dart` (depende de T014)
- [ ] T019 [US3] Agregar a `PantallaDivisor` el selector de modo de redondeo; cambiarlo no recalcula hasta tocar «Calcular», en `lib/presentation/pantalla_divisor.dart` (depende de T015, T018)
- [ ] T020 [US3] Componer los dos modos en `lib/main.dart` (un `CalcularDivision` por estrategia) y pasarlos al controlador (depende de T016, T017, T018)

**Checkpoint**: Las tres historias funcionan; agregar otro redondeo no exige editar clases existentes, salvo una línea en `main.dart`

---

## Phase 6: Pruebas (autorizadas por el usuario)

**Purpose**: Convertir los 6 escenarios de la spec en pruebas ejecutables (constitución, principio IV)

- [ ] T021 Verificar que existe `test/casos_de_prueba.dart` con los 6 casos de la spec (lo escribe el usuario a mano; el agente NO lo genera)
- [ ] T022 Crear `test/division_test.dart`: recorre `casos` con un bucle, valida con `ValidarEntrada` y calcula con `CalcularDivision` + la estrategia del modo (`closeTo(esperado, 0.001)`); más una prueba de LSP (el mismo `CalcularDivision` con `RedondeoExacto` y con `RedondeoHaciaArriba`, sin `if` ni cast). Sin widgets (depende de T013, T017, T021)
- [ ] T023 Crear `test/pantalla_test.dart` con tres pruebas de widget: 100/4/10 → «27.50»; 50 y 0 personas → «Debe haber al menos una persona» sin resultado; «abc» en el monto → «Monto inválido» (depende de T011, T015)
- [ ] T024 Ejecutar `flutter test` y corregir lo que falle en `lib/`, nunca en `test/` (depende de T022, T023)

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Verificar que lo construido cumple la constitución

- [ ] T025 Ejecutar `flutter analyze` y dejarlo sin problemas (depende de T001 y de T021–T023)
- [ ] T026 Ejecutar las cuatro verificaciones por `grep` de `quickstart.md` (principios I y II de la constitución) y confirmar que dan el resultado esperado
- [ ] T027 Ejecutar `flutter build apk --debug`
- [ ] T028 Recorrer a mano la tabla de escenarios de `quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: sin dependencias
- **Foundational (Phase 2)**: depende de Setup; bloquea las historias
- **User Stories (Phase 3+)**: dependen de Foundational. Comparten `divisor_controller.dart`, `pantalla_divisor.dart` y `main.dart`, así que se hacen en orden de prioridad: US1 → US2 → US3
- **Pruebas (Phase 6)**: depende de las tres historias
- **Polish (Phase 7)**: depende de las pruebas y de T001: sin T001 `flutter analyze` falla

### User Story Dependencies

- **US1 (P1)**: tras Foundational; sin dependencias de otras historias
- **US2 (P1)**: tras US1 (amplía controlador, pantalla y composición)
- **US3 (P2)**: tras US2 (amplía los mismos archivos)

### Within Each User Story

- Entidades y contratos antes que los casos de uso
- Casos de uso antes que el controlador
- Controlador antes que la pantalla
- Pantalla antes que la composición en `main.dart`

### Parallel Opportunities

- T003, T004 y T005 (Phase 2) en paralelo
- Dentro de US1: T006, T008 y T009 en paralelo (archivos distintos)
- T017 (US3) es independiente y puede hacerse en cualquier momento después de T005

---

## Parallel Example: User Story 1

```bash
# Tareas de US1 que no dependen entre sí:
Task: "Implementar RedondeoExacto en lib/data/redondeo_exacto.dart"
Task: "Implementar FormateadorMoneda en lib/presentation/formateador_moneda.dart"
Task: "Implementar LectorNumeros en lib/presentation/lector_numeros.dart"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Phase 1: Setup
2. Phase 2: Foundational
3. Phase 3: User Story 1
4. **PARAR y validar**: 100/4/10 % → 27.50, 90/3/0 % → 30.00, 10/3/0 % → 3.33, 10,50 → 10.50

### Incremental Delivery

1. Setup + Foundational
2. US1 → validar (MVP)
3. US2 → validar
4. US3 → validar
5. Polish

---

## Notes

- [P] = archivos distintos, sin dependencias
- Las pruebas se hacen en la Fase 6 con autorización explícita del usuario (ver «Tests»).
- Hacer commit después de cada tarea o grupo lógico
- `divisor_controller.dart`, `pantalla_divisor.dart` y `main.dart` se editan en varias historias; no marcar esas tareas como [P]
