# Feature Specification: Divisor de cuenta

**Feature Branch**: `sdd` (no se crea una rama por feature; se trabaja en la rama `sdd`)

**Created**: 2026-10-08

**Status**: Draft

**Input**: User description: "Una app de una sola pantalla para dividir la cuenta de un restaurante entre varias personas. El usuario ingresa el monto total, el número de personas y el porcentaje de propina, y al tocar "Calcular" ve cuánto paga cada persona con dos decimales. Hay dos modos de redondeo que el usuario elige: exacto, o hacia arriba al entero más cercano. La app funciona sin conexión: no hay red ni base de datos."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Calcular cuánto paga cada persona (Priority: P1)

El usuario ingresa el monto total de la cuenta, el número de personas y el porcentaje de propina,
elige el modo de redondeo y toca "Calcular". La app muestra cuánto paga cada persona con dos
decimales.

**Why this priority**: Es la razón de ser de la app. Sin este cálculo no hay producto.

**Independent Test**: Se prueba ingresando los valores de un caso conocido y comprobando el
importe mostrado. Entrega por sí sola el valor principal de la app.

**Acceptance Scenarios**:

1. **Given** monto 100.00, 4 personas, propina 10 % y modo exacto, **When** el usuario toca
   "Calcular", **Then** se muestra 27.50 por persona.
2. **Given** monto 90.00, 3 personas, propina 0 % y modo exacto, **When** el usuario toca
   "Calcular", **Then** se muestra 30.00 por persona.
3. **Given** monto 10.00, 3 personas, propina 0 % y modo exacto, **When** el usuario toca
   "Calcular", **Then** se muestra 3.33 por persona.

---

### User Story 2 - Rechazar entradas inválidas con un mensaje claro (Priority: P1)

Si el usuario ingresa datos que no permiten calcular, la app muestra un mensaje que explica el
problema y no muestra ningún resultado.

**Why this priority**: Un resultado incorrecto o un cierre inesperado de la app sería peor que no
calcular. Es parte del comportamiento esencial.

**Independent Test**: Se prueba ingresando cada entrada inválida y comprobando que aparece el
mensaje exacto y que no se muestra un importe.

**Acceptance Scenarios**:

1. **Given** monto 50.00 y 0 personas, **When** el usuario toca "Calcular", **Then** se muestra el
   mensaje "Debe haber al menos una persona" y NO se muestra ningún resultado.
2. **Given** el monto contiene el texto "abc", **When** el usuario toca "Calcular", **Then** se
   muestra el mensaje "Monto inválido".

---

### User Story 3 - Elegir el modo de redondeo (Priority: P2)

El usuario elige entre dos modos: **exacto** (el importe con dos decimales) o **hacia arriba**
(el importe sube al entero más cercano). El modo elegido determina el importe mostrado.

**Why this priority**: Amplía la utilidad del cálculo (pagar en billetes enteros), pero la app
sigue siendo útil con el modo exacto.

**Independent Test**: Se prueba un mismo caso con ambos modos y se comprueba que los importes
difieren según lo esperado.

**Acceptance Scenarios**:

1. **Given** monto 10.00, 3 personas, propina 0 % y modo hacia arriba, **When** el usuario toca
   "Calcular", **Then** se muestra 4.00 por persona.
2. **Given** monto 10.00, 3 personas, propina 0 % y modo exacto, **When** el usuario toca
   "Calcular", **Then** se muestra 3.33 por persona.

---

### Edge Cases

- ¿Qué pasa con 0 personas? Se muestra "Debe haber al menos una persona" y ningún resultado.
- ¿Qué pasa si el monto no es numérico (por ejemplo "abc")? Se muestra "Monto inválido" y ningún
  resultado.
- ¿Qué pasa si el usuario cambia el modo de redondeo después de calcular? El resultado mostrado
  solo se actualiza al volver a tocar "Calcular".
- ¿Qué pasa tras un error y un nuevo cálculo válido? El mensaje de error desaparece y se muestra
  el resultado.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: La app MUST tener una sola pantalla.
- **FR-002**: El usuario MUST poder ingresar el monto total, el número de personas y el
  porcentaje de propina.
- **FR-003**: El usuario MUST poder elegir entre dos modos de redondeo: exacto y hacia arriba al
  entero más cercano.
- **FR-004**: Al tocar "Calcular", la app MUST mostrar cuánto paga cada persona con dos decimales.
- **FR-005**: El importe por persona MUST ser el monto total más la propina aplicada sobre ese
  monto, dividido entre el número de personas.
- **FR-006**: Si el número de personas es 0, la app MUST mostrar el mensaje "Debe haber al menos
  una persona" y MUST NOT mostrar ningún resultado.
- **FR-007**: Si el monto no es un número válido, la app MUST mostrar el mensaje "Monto inválido"
  y MUST NOT mostrar ningún resultado.
- **FR-008**: En modo exacto la app MUST mostrar el importe redondeado a dos decimales.
- **FR-009**: En modo hacia arriba la app MUST mostrar el importe subido al entero más cercano
  hacia arriba, con dos decimales.
- **FR-010**: La app MUST funcionar sin conexión: no usa red ni base de datos.

### Key Entities

- **Cuenta**: la información que ingresa el usuario: monto total, número de personas, porcentaje
  de propina y modo de redondeo elegido.
- **Resultado**: el importe que paga cada persona, con dos decimales.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Los 6 escenarios de aceptación de esta spec producen exactamente el resultado o el
  mensaje indicado.
- **SC-002**: El usuario obtiene el importe por persona en un solo toque de "Calcular", sin pasos
  intermedios.
- **SC-003**: Ante cualquier entrada inválida de las contempladas, el usuario ve un mensaje
  explicativo y nunca un importe incorrecto.
- **SC-004**: La app completa su función con el dispositivo sin conexión a internet.

## Assumptions

- El porcentaje de propina se aplica sobre el monto total (por ejemplo, 10 % de 100.00 son 10.00).
- La propina se ingresa como un porcentaje numérico; el 0 % es un valor válido.
- El monto y los demás valores se ingresan en una sola moneda; no hay conversión de monedas.
- El modo de redondeo por defecto al abrir la app es exacto.
- Las entradas no contempladas en los escenarios (por ejemplo, monto negativo o propina vacía) no
  están definidas en esta spec y se resolverán en la etapa de clarificación.
- Los mensajes de error se muestran en español, tal como están escritos en los escenarios.
