# TP Integrador Final — HIA 2026 — Grupo 12

Práctica Integradora Final de **Herramientas Informáticas Avanzadas**,
Facultad de Ingeniería, UNJu. Aplicación: **RestoYa**.

| Integrante | LU | Rama | Frente |
|---|---|---|---|
| Aramayo, Gerardo Leonel | 4082 | `feature/base-de-datos` | Base de datos (puntos 4 y 5) |
| Armella, Julián Enrique | 5435 | `feature/cluster-replicacion` | Clúster y replicación (punto 6) |
| Cruz, Florencia Agustina | 6810 | `feature/app-contenedores-cicd` | Aplicación, contenedores y CI/CD (puntos 1, 7 y 8) |
| Pol, Jaime Facundo | 5937 | `feature/publicacion-monitoreo` | Publicación y monitoreo (puntos 9 y 10) |
| Prieto, Gabriel Arturo | 5486 | `feature/procesos-seguridad` | Procesos, incidencias, n8n y seguridad (puntos 2, 3, 11, 12, 13 y 14) |

---

## Cómo trabajamos

La estrategia de ramas es la que pide el punto 3 de la consigna:

- **`main`** — versión estable. Protegida: no se empuja directo, entra sólo por
  pull request con **una aprobación de otro integrante**.
- **`develop`** — integración. Es la rama por defecto.
- **`feature/*`** — una por integrante, la de la tabla de arriba.
- **`fix/*`** — correcciones.

**Cada uno trabaja en su rama y abre un pull request contra `develop`.** El PR
lo aprueba **otro** integrante, no el autor: GitHub no permite autoaprobarse y,
sobre todo, la consigna pide expresamente *revisar el código antes de integrar
cambios*.

### Orden de integración

Importa, porque hay dependencias reales:

```
base-de-datos  →  app-contenedores-cicd  →  cluster-replicacion
                                         →  publicacion-monitoreo
                                         →  procesos-seguridad
```

La base va primera porque el resto monta sobre su `docker-compose.yml` y su
red interna. Procesos va última porque sus herramientas se integran con el
monitoreo y con la aplicación ya publicada.

### Mensajes de commit

Formato `tipo(alcance): qué cambia`, y el **identificador de la tarjeta de
Trello** adentro para poder vincular cada cambio con su tarea:

```
feat(infra): contenerizar la base con pgAdmin y copias (E4-01)
fix(ci): el .env del CI necesita las variables de todos los perfiles (E8-04)
docs(cluster): informe del punto 6 con la prueba de caída (E6-05)
```

### Qué no entra al repositorio

Contraseñas, *tokens*, claves privadas, archivos `.env` con secretos y copias
de la base. El `.gitignore` ya los cubre; si agregás un archivo nuevo que lleve
un secreto, sumalo ahí **antes** del primer commit.

---

## Qué sube cada uno

Cada frente trae su código, su configuración y su informe. El informe no es un
anexo: es la mitad del entregable.

**Base de datos — Aramayo.** La base en Docker con su volumen, la red interna,
el cliente de administración y el servicio de copias. El conjunto de datos de
prueba de 6.000.000 de filas por tabla y cómo se genera. Los índices, las
vistas materializadas y las ocho consultas optimizadas con su medición antes y
después.

**Clúster y replicación — Armella.** El nodo réplica, la configuración de los
dos nodos, la evidencia de que replica, la prueba de caída y el procedimiento
de recuperación. Y el informe tiene que decir en la primera línea si hay o no
*failover* automático: la consigna avisa que, si se afirma, hay que demostrarlo.

**Aplicación, contenedores y CI/CD — Cruz.** El diagnóstico de la aplicación,
el inventario del stack con versiones exactas, el diagrama de arquitectura, los
`Dockerfile` del backend y del frontend, y el *pipeline* con las validaciones,
la publicación de imágenes y el procedimiento de vuelta atrás.

**Publicación y monitoreo — Pol.** El túnel, qué se publica y qué no, HTTPS y
la evidencia de acceso desde fuera de la red. Prometheus, Grafana, los
exportadores, el tablero con las métricas que la consigna lista como mínimas, y
las alertas con una prueba de que disparan de verdad.

**Procesos, incidencias, n8n y seguridad — Prieto.** El tablero y el registro
de seguimiento, la gestión de incidencias con el ciclo completo, la gestión
documental con su matriz de permisos, los tres flujos de automatización, y el
informe de seguridad con la matriz de amenazas y el procedimiento de respuesta.

---

## Dónde está el trabajo ya hecho

El sistema está construido, corriendo y documentado en el repositorio de
trabajo:

**https://github.com/prieto555/tp-integrador-hia-grupo12** (rama `develop`)

Antes de subir tu parte, leé de ahí:

| Archivo | Para qué |
|---|---|
| `docs/README.md` | El índice: cuál de los 16 documentos obligatorios está en qué archivo |
| `INSTALACION.md` | Levantar el sistema desde cero |
| `PROBAR.md` | Comprobar punto por punto que cada cosa funciona, con el comando y lo que tiene que dar |
| `docs/01-descripcion.md` y `docs/02-arquitectura.md` | Entender el sistema antes de meterte en un punto |
| `docs/scrum/seguimiento.md` | Qué pasó día por día: impedimentos y cambios de alcance, con el porqué |
| `docs/16-limitaciones.md` | Lo que **no** anda y lo que quedó afuera a propósito |
| `docs/capturas/` | 19 capturas, y al lado de cada una qué prueba |

Y el informe de tu punto, que es el que vas a tener que defender.

---

## Dos cosas que todos tenemos que saber

Están documentadas y hay que contestarlas de frente si las preguntan:

- **D-01 — diecinueve endpoints sin autenticación.** Lo encontró el diagnóstico
  del punto 1. Está documentado y **sin corregir a propósito**: son cinco
  líneas, pero tocan pantallas que hoy funcionan sin token y no hay pruebas
  para verificar que no se rompe nada. Por eso el túnel se baja después de
  presentar.
- **Hallazgo 17 — pgAdmin entra sin credencial.** Lo único que lo contiene es
  que el puerto está en `127.0.0.1` y fuera del túnel.

---

## La nota es individual

De las condiciones finales de la consigna, textual:

> La calificación será individual, aun cuando el proyecto se desarrolle en
> equipo. (…) La cátedra podrá tomar un examen individual, teórico y/o
> práctico, cuando lo considere necesario, a fin de verificar la participación
> efectiva de cada estudiante. (…) Cada integrante deberá acreditar el dominio
> de los componentes implementados.

Para tu frente tenés que poder decir, sin leer: **qué se configuró y con qué
valores**, **por qué eso y no otra cosa** (incluida la alternativa que se
descartó), **el número que lo respalda**, y **qué no resuelve**. Las cuatro
están escritas en el informe de cada punto.
