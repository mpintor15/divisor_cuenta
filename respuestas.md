# Respuestas — Vibe coding vs. SDD con GitHub Spec Kit

> **Antes de entregar, completar los puntos marcados «COMPLETAR»**: son las pruebas manuales en el
> teléfono, que no se pudieron ejecutar al redactar este documento.

## 1. Métricas, agente y decisiones

**Agente y configuración (la misma en las dos ramas):** Claude Code, modelo Sonnet 5.5, nivel de
razonamiento Medium. **Archivo de instrucciones:** `CLAUDE.md`. **Caso de Git (Parte 1.5):** caso A: no
había ningún repositorio por encima de `divisor_cuenta`, así que se hizo `git init` dentro del proyecto.
Las dos ramas salen del mismo commit inicial `3ce3bb7`.

| | rama vibe | rama sdd |
|---|---|---|
| Iteraciones | **0** (solo el prompt inicial) | **3** (ver regla de conteo abajo) |
| Casos de aceptación que cumple (0–6) | No ejecutado a mano. Por lectura del código: 3, 4 y 6 no tienen equivalente en su modelo; 1, 2 y 5 solo se reproducen de forma indirecta. COMPLETAR si se prueba | **6 de 6** en `flutter test`. Prueba manual en el teléfono: COMPLETAR |
| Pruebas automatizadas que pasan | 2 (las escribió el agente) | **10** (6 escenarios, 1 de LSP, 3 de widget) |
| Archivos en `lib/` | 3 | 12 |
| Líneas de código en `lib/` | 340 | 294 |
| ¿`domain/` depende de Flutter? | No aplica: `domain/` no existe (Flutter aparece en `main.dart` y `home_page.dart`) | No (`grep` sin resultados) |
| ¿Existe separación `presentation/domain/data`? | No | Sí |
| ¿El agente agregó algo que nadie pidió? | Sí: ítems por persona, IVA del 15 %, deslizadores, chips, tests propios | Sí, pero documentado en la spec y el plan (ver pregunta 5) |
| ¿Se puede agregar otra estrategia sin modificar el cálculo existente? | No: el cálculo está en la clase `Bill` (`models.dart`) | Sí: una clase nueva que implemente `EstrategiaRedondeo` y una línea en `main.dart` |

Tiempo aproximado hasta cumplir los 6 escenarios: no se registró.

**Regla de conteo de iteraciones.** Cada mensaje mío posterior a la solicitud inicial que pedía una
corrección, un cambio o una acción adicional sobre algo ya generado cuenta como una. En `sdd` fueron 3:
pedir las ediciones sugeridas por `analyze`, corregir FR-003 y aprobar la corrección del redondeo hacia
arriba. No cuentan los mensajes de avance («sí, sigue»). Tampoco cuento el archivo
`test/casos_de_prueba.dart`, porque la guía lo asigna al estudiante.

**¿Qué enfoque cumplió mejor los seis escenarios?** `sdd`, con evidencia ejecutable: los seis pasan como
pruebas automáticas. `vibe` necesitó 0 iteraciones, pero ese 0 mide otra cosa: cumplió su propia idea de
la app (reparto por ítems con IVA), no la de la spec, porque los seis escenarios no estaban en la frase
inicial.

**Decisiones explícitas y decisiones del agente.**
- En `vibe` el agente decidió todo: el modelo de reparto, el IVA (15 %), la propina por deslizador (10 %
  por defecto), la interfaz, que no hubiera redondeo ni validación de monto.
- En `sdd` quedaron explícitas por escrito: los 6 escenarios, los dos modos de redondeo, el uso sin
  conexión, las tres capas y SOLID en la constitución. El agente completó otras: que la propina se aplica
  sobre el monto total, el modo por defecto (exacto), el orden en que se validan los campos, que cambiar
  el modo no recalcula hasta tocar «Calcular», y la clase `LectorNumeros`.

**El tiempo no basta para decidir.** Depende del equipo, la conexión, la experiencia previa y las
interrupciones, y no mide calidad ni mantenibilidad.

## 2. Pruebas de `sdd` sobre `vibe` (Parte 10)

**No compilaron.** El primer error:

```text
test/division_test.dart:3:8: Error: Error when reading 'lib/data/redondeo_exacto.dart': No such file or directory
import 'package:divisor_cuenta/data/redondeo_exacto.dart';
```

**No demuestra un fallo funcional, sino una diferencia de arquitectura y testabilidad.** La rama `vibe`
no tiene `domain/` ni `data/`, ni las clases `CalcularDivision`, `ValidarEntrada` ni `EstrategiaRedondeo`;
el cálculo está dentro de `Bill` y la interfaz formatea sus propios importes. Para que esas pruebas
corrieran habría que crear esas clases y mover el cálculo, es decir, reestructurar la rama entera.

**Los seis escenarios a mano en `vibe`:** COMPLETAR (ejecutar la app de la rama `vibe` y anotar qué
muestra en cada caso). Por lectura del código se espera que 3, 4 y 6 no sean posibles (no hay
validación de monto, ni campo de monto total, ni modo de redondeo), pero eso hay que comprobarlo
ejecutando la app.

## 3. Verificaciones de SOLID (Parte 9.5)

| Verificación | `sdd` | `vibe` |
|---|---|---|
| `grep -rn "package:flutter" lib/domain/` | Sin resultados | `lib/domain/` no existe; `package:flutter` aparece en `lib/main.dart` y `lib/home_page.dart` |
| Estrategias concretas solo en `main.dart` | `lib/main.dart:15` y `:16`, nada más | No hay estrategias de redondeo |
| `grep -n -E "is Redondeo\|as Redondeo" lib/domain/calcular_division.dart` | Sin resultados | El archivo no existe |
| `grep -n -E "toStringAsFixed\|inválido\|al menos una persona" lib/domain/calcular_division.dart` | Sin resultados | El archivo no existe; el formateo está en `home_page.dart` |

Además, en `sdd` pasan `flutter analyze` (sin problemas), `flutter test` (10 de 10) y
`flutter build apk --debug`.

**Qué regla de la constitución explica cada diferencia.** `sdd` pasa porque la constitución lo exige: el
principio I (SRP, OCP, LSP, ISP, DIP) y el principio II (capas, `domain` sin Flutter, `main.dart` como
único punto de composición). `vibe` no tenía ninguna regla escrita, así que el agente no tenía de dónde
sacar esa estructura: el cálculo, la regla de negocio y la interfaz conviven en el mismo lugar.

## 4. Preguntas de `/speckit-clarify`

Hizo 5 preguntas. Las dos más relevantes:

1. **¿Qué debe hacer la app si el monto es cero o negativo?** Destapó que la spec solo cubría el monto no
   numérico («abc»). Un monto negativo es un número válido y, sin una regla, habría producido un importe
   negativo en lugar de un error. Resolución: «Monto inválido» y ningún resultado.
2. **¿Cómo debe interpretar la app el separador decimal (`10.50` frente a `10,50`)?** Destapó que en
   Ecuador la coma decimal es habitual. Sin la regla, `10,50` se habría rechazado como «Monto inválido»
   aunque fuera un monto correcto. Resolución: se aceptan punto y coma.

**Quién tomó esas decisiones.** En `vibe` las tomó el agente solo, sin preguntarme. En `sdd` las
respondí aceptando la recomendación del agente («recommended»), así que quedaron registradas en la spec
pero no fueron una decisión propia mía. Lo anoto porque la diferencia con `vibe` está en que en `sdd`
la decisión es visible y quedó escrita, no en que sea más acertada.

## 5. Qué agregó cada rama sin que nadie lo pidiera

`git diff vibe sdd --stat` da 58 archivos cambiados, +6.493 / −353, dominado por `.specify/` y `specs/`.
Solo en `lib/` y `test/` son 18 archivos, +457 / −353.

- **`vibe`:** sí. Ejemplos concretos: un modelo de ítems por persona (cada plato se reparte entre quienes
  lo consumieron), un IVA del 15 % con deslizador de 0 a 25 %, personas como chips con reajuste al
  borrarlas, y dos tests propios. Terminó ofreciendo compartir, redondear y guardar la cuenta.
- **`sdd`:** también agregó cosas que la descripción original no mencionaba, pero todas están escritas
  y justificadas: la clase `LectorNumeros` (decisión 3 de `research.md`, necesaria para aceptar la coma
  decimal), los mensajes «Propina inválida» y «Número de personas inválido» (respuestas de clarify) y la
  corrección del redondeo hacia arriba. La diferencia es que en `sdd` cada adición se puede rastrear a un
  artefacto.

**Un error mío, detectado en la implementación.** Mi diseño original de `RedondeoHaciaArriba` redondeaba
al centavo y luego aplicaba `ceil`. Eso daba 1.00 para `6 / 7 personas / 17 %`, que en realidad es
`1.0028…`, y no cubría la cuenta. Además, mi ejemplo documentado era falso. Un `ceil` directo tampoco
sirve: `25 × (1 + 12/100)` da `28.000000000000004` y subiría a 29. Quedó como `ceil(valor − 1e-9)`,
corregido en `research.md`, `data-model.md`, `tasks.md` y el código, y comprobado contra 12.240.000
combinaciones sin discrepancias. Ni `analyze` ni los seis escenarios lo habrían detectado.

## 6. Otras herramientas de SDD y cuándo elegir `vibe`

**Herramienta elegida: OpenSpec.** La diferencia principal con Spec Kit: Spec Kit guarda una spec por
feature y sigue una secuencia fija (constitución, specify, clarify, plan, tasks, analyze, implement).
OpenSpec mantiene una especificación consolidada del estado actual del sistema en `openspec/specs/` y
expresa cada cambio como una propuesta en `openspec/changes/`, descrita como diferencias (deltas) sobre
lo existente. Esto le da menos ceremonia y lo hace más natural para extender proyectos que ya existen;
las comparaciones lo describen como más ligero. Prefiero OpenSpec en un proyecto existente al que le voy
agregando funciones. Prefiero Spec Kit en un proyecto nuevo que parte de cero, como este.

Aviso: estas diferencias salen de blogs y comparaciones de terceros, no de la documentación oficial, y
no probé OpenSpec. Fuentes:
[OpenSpec vs Spec Kit](https://codemyspec.com/blog/openspec-vs-spec-kit),
[Spec Kit vs OpenSpec](https://intent-driven.dev/knowledge/spec-kit-vs-openspec/),
[Brownfield: Spec Kit, OpenSpec y BMAD](https://medium.com/@mathivananmani/reviving-brownfield-projects-with-ai-a-comparative-look-at-github-spec-kit-openspec-and-bmad-a7bc5116dd9a).

**Cuándo elegiría `vibe`:** un script de un solo uso o un prototipo desechable, por ejemplo una
herramienta que convierte un CSV una vez y se descarta. Se entiende completo de un vistazo, nadie más lo
va a mantener y no tiene riesgos que justifiquen la ceremonia de constitución, spec, plan y tareas.

## Desviaciones de método (para que el resultado se lea con contexto)

- Los skills `/speckit-*` no se pudieron invocar como comandos en la sesión de trabajo. Se leyó cada
  `SKILL.md` y se aplicó a mano, con los mismos artefactos como resultado.
- La sesión de `sdd` ya conocía la especificación de la guía; la de `vibe` fue una sesión limpia.
- `/speckit-converge` y la tarea T028 (recorrer los escenarios a mano) no se ejecutaron.
