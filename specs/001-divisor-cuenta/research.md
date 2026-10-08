# Research: Divisor de cuenta

No quedaron `NEEDS CLARIFICATION` en el contexto técnico; este documento deja constancia de las
decisiones de diseño que no estaban escritas en la spec.

## Decisión 1: el redondeo hacia arriba se aplica sobre el valor ya redondeado a centavos

- **Decisión**: `RedondeoHaciaArriba` primero redondea el importe a dos decimales y luego aplica
  `ceil`. `RedondeoExacto` solo redondea a dos decimales.
- **Razón**: en `double`, `30 * 1.10 / 3` da `11.000000000000002`. Un `ceil` directo daría 12, y el
  usuario esperaría 11. Redondear primero a centavos elimina ese ruido de coma flotante.
- **Alternativas**: `ceil` directo (descartada: falla con ruido de coma flotante); trabajar en
  enteros de centavos (descartada: más complejo de lo que pide una pantalla con una división).

## Decisión 2: la validación devuelve el mensaje, y el orden de las reglas es fijo

- **Decisión**: `ValidarEntrada` devuelve `String?` (el mensaje exacto, o `null` si todo es
  válido). Orden de evaluación: monto, personas, propina.
- **Razón**: las pruebas de la guía verifican «exactamente ese mensaje» y que no se calcula nada.
  Con varios errores a la vez, el orden fijo hace el resultado predecible y comprobable.
- **Alternativas**: lanzar excepciones (descartada: complica la prueba y el flujo); devolver una
  lista de todos los errores (descartada: la spec muestra un solo mensaje).

## Decisión 3: el texto se convierte en números en `presentation`, con una clase propia

- **Decisión**: `LectorNumeros` (presentation) convierte el texto de los campos en `double?` e
  `int?`, aceptando punto y coma (FR-013). Si no se puede (vacío, texto, decimal en personas),
  devuelve `null`. `ValidarEntrada` recibe `double?`/`int?` y trata `null` y `NaN` como inválido.
- **Razón**: el `domain` debe ser Dart puro y no interpretar cómo se escribe un número en la
  pantalla. Las pruebas de la guía le pasan números directamente (`monto: double.nan` para
  «abc»), así que la validación recibe números y no texto. Es una clase más que el plan del
  curso, justificada por SRP.
- **Alternativas**: que `ValidarEntrada` reciba `String` (descartada: choca con la tabla de
  pruebas, que usa `double` e `int`); parsear dentro de `DivisorController` (descartada: mezcla
  orquestación con interpretación de texto).

## Decisión 4: composición de los modos de redondeo

- **Decisión**: `main.dart` construye un `CalcularDivision` por modo (cada uno con su estrategia)
  y se los pasa al `DivisorController` junto con `ValidarEntrada`. El controlador no conoce las
  estrategias concretas.
- **Razón**: cumple DIP y la regla de que solo `main.dart` instancia `RedondeoExacto()` y
  `RedondeoHaciaArriba()`. Agregar un redondeo nuevo = una clase nueva + una línea en `main.dart`.
- **Alternativas**: que el controlador cree las estrategias (descartada: viola II); un `switch`
  sobre el modo dentro de `CalcularDivision` (descartada: viola OCP y LSP).

## Decisión 5: dónde viven las estrategias de redondeo

- **Decisión**: `RedondeoExacto` y `RedondeoHaciaArriba` van en `lib/data/`, como en el reparto
  de archivos del curso.
- **Razón**: la interfaz está en `domain` y las implementaciones en `data`, lo que cumple la regla
  de dependencia `presentation -> domain <- data`.
- **Nota**: redondear no es acceso a datos; la ubicación sigue la estructura del curso, no una
  necesidad técnica.

## Decisión 6: formato del resultado

- **Decisión**: `FormateadorMoneda` devuelve el número con dos decimales y punto, sin símbolo
  (FR-004, clarificación 5). La pantalla lo muestra en un `Text` propio que contiene solo ese
  número, con la etiqueta «por persona» en otro `Text`.
- **Razón**: las pruebas de widget usan `find.text('27.50')`, que solo encuentra un `Text` cuyo
  contenido sea exactamente ese texto.
- **Alternativas**: «$27.50» en un solo `Text` (descartada: contradice la clarificación 5 y
  rompería la prueba).
