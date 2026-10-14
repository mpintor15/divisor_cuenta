# Respuestas — Deber 3

## 1. Rojo antes de verde

`flutter test` mostró: `Expected: 'La propina no puede superar el 100%'  Actual: <null>`.
La validación devolvía `null` porque la regla todavía no existía.

Era importante verla fallar primero porque así sé que la prueba realmente detecta el
problema. Si la hubiera escrito después del código y pasara de inmediato, no sabría si
prueba algo o si pasaría siempre.

## 2. Linter vs. IA

- **Aviso del linter:** `unused_local_variable` (variable local que no se usa) y `avoid_print`,
  que provoqué a propósito porque mi código no tenía avisos.
- **Code smell de la IA:** número mágico, el `100` suelto en `validar_entrada.dart`.

El linter no lo encontró porque solo comprueba reglas fijas y mecánicas (variables sin uso,
imports, estilo). Un `100` suelto no rompe ninguna regla: el código es válido. Entender que
ese número es "la propina máxima" y que conviene darle nombre requiere interpretar la
intención del código.

## 3. Mi refactorización

- **Smell elegido:** número mágico.
- **Qué cambió:** en `validar_entrada.dart` agregué la constante `_propinaMaxima = 100` y la
  condición pasó de `propina > 100` a `propina > _propinaMaxima`.
- **Cómo sé que hace lo mismo:** corrí `flutter test` después del cambio y las 12 pruebas
  siguieron en verde, incluidas la de propina 150 (error) y la de propina 100 (permitida), que
  protegen justo ese límite. Además `git diff` mostró que solo cambió ese archivo y no toqué `test/`.

## 4. Coverage

El archivo con menor porcentaje es `lib/main.dart`, con 45.5 % (5 de 11 líneas).

No significa que tenga errores. El coverage solo mide qué líneas ejecutaron las pruebas, no si
están bien. En `main.dart` está el arranque de la app (`main()` y `DivisorApp`), y mis pruebas
construyen la pantalla directamente, así que esas líneas nunca se ejecutan en los tests.
