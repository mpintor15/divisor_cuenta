# Data Model: Divisor de cuenta

Sin persistencia: todo vive en memoria durante el uso de la pantalla.

## Entidades (domain)

### Cuenta
| Campo | Tipo | Notas |
|---|---|---|
| `monto` | `double` | monto total; debe ser un número mayor que cero |
| `personas` | `int` | entero mayor o igual que 1 |
| `propina` | `double` | porcentaje; 0 es válido; no negativo |

### Resultado
| Campo | Tipo | Notas |
|---|---|---|
| `importePorPersona` | `double` | ya redondeado según la estrategia elegida |

## Interfaz (domain)

### EstrategiaRedondeo
Un solo método: `double redondear(double valor)`.

| Implementación | Capa | Comportamiento |
|---|---|---|
| `RedondeoExacto` | data | redondea a dos decimales |
| `RedondeoHaciaArriba` | data | sube al siguiente entero: `ceil(valor - 1e-9)`; el margen absorbe el ruido de coma flotante |

## Reglas de validación (ValidarEntrada)

Recibe `double? monto`, `int? personas`, `double? propina`; devuelve `String?`.
`null` y `NaN` cuentan como inválidos. Orden de evaluación: monto, personas, propina.

| Orden | Condición | Mensaje | FR |
|---|---|---|---|
| 1 | monto `null`, `NaN` o `<= 0` | `Monto inválido` | FR-007 |
| 2 | personas `== 0` | `Debe haber al menos una persona` | FR-006 |
| 2 | personas `null` o `< 0` | `Número de personas inválido` | FR-012 |
| 3 | propina `null`, `NaN` o `< 0` | `Propina inválida` | FR-011 |
| — | todo válido | `null` (se calcula) | — |

Las personas decimales (`2.5`) y el texto llegan como `null` desde `LectorNumeros`.

## Fórmula (CalcularDivision)

```text
importe = estrategia.redondear( monto * (1 + propina / 100) / personas )
```

## Ejemplos que cubren los escenarios

| Caso | Entrada | Resultado |
|---|---|---|
| 1 | 100.00, 4, 10 %, exacto | 27.50 |
| 2 | 90.00, 3, 0 %, exacto | 30.00 |
| 3 | 50.00, 0 personas | `Debe haber al menos una persona`, sin resultado |
| 4 | monto `NaN` | `Monto inválido`, sin resultado |
| 5 | 10.00, 3, 0 %, exacto | 3.33 |
| 6 | 10.00, 3, 0 %, hacia arriba | 4.00 |
