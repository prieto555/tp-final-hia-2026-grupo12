# TP Integrador Final — HIA 2026 — Grupo 12

Práctica Integradora Final de **Herramientas Informáticas Avanzadas**, Analista
Programador Universitario, Facultad de Ingeniería — UNJu.

## Integrantes

| Integrante | LU |
|---|---|
| Aramayo, Gerardo Leonel | 4082 |
| Armella, Julián Enrique | 5435 |
| Cruz, Florencia Agustina | 6810 |
| Pol, Jaime Facundo | 5937 |
| Prieto, Gabriel Arturo | 5486 |

---

## La aplicación: RestoYa

**RestoYa** es un sistema de restaurante y *delivery*: carta, pedidos, estados
de cocina, pagos y reportes. Se desarrolló para la cátedra de Programación y
Servicios Web y acá es el punto de partida: sobre esta aplicación se montan los
contenedores, la optimización de la base, la replicación, el *pipeline*, la
publicación, el monitoreo, la gestión de incidencias, la automatización y el
informe de seguridad.

### Cómo está hecha

| | |
|---|---|
| **Backend** | API REST en Node.js con **Express 5** y **Sequelize 6** sobre **PostgreSQL 16** |
| **Frontend** | SPA en **Angular 21**, servida por **nginx**, que hace además de *proxy* de `/api/` |
| **Autenticación** | JWT con roles y funciones |
| **Documentación de la API** | OpenAPI, servida en `/api-docs` |
| **Métricas** | el backend expone `/metrics` en formato Prometheus |

El backend **no publica puerto propio**: se llega a él únicamente a través de
nginx. Es lo que permite que la aplicación se publique entera con una sola
regla, y que la API no quede alcanzable por un camino paralelo.

---

## Qué hay en el repositorio

```
backend/     API REST (Node.js + Express + Sequelize)
frontend/    SPA (Angular 21)
```

Cada una tiene su propio `README.md`, su `Dockerfile` y su `.env.example`.

---

## Estrategia de ramas

La que pide el **punto 3** de la consigna:

| Rama | Para qué |
|---|---|
| **`main`** | versión estable. Protegida: no se empuja directo, entra sólo por *pull request* con **una aprobación** |
| **`develop`** | rama de integración, y la rama por defecto |
| **`feature/*`** | una por frente de trabajo |
| **`fix/*`** | correcciones |

El trabajo se hace en una rama y entra a `develop` por *pull request*. **El PR
lo aprueba otro integrante, no el autor**: GitHub no permite autoaprobarse y,
sobre todo, la consigna pide expresamente *revisar el código antes de integrar
cambios*.

### Mensajes de commit

Formato `tipo(alcance): qué cambia`, en minúscula y en presente:

```
feat(infra): contenerizar la base con pgAdmin y copias
fix(ci): el .env del CI necesita las variables de todos los perfiles
docs(cluster): informe del punto 6 con la prueba de caída
```

Tipos: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `perf`.

---

## Qué no entra al repositorio

Contraseñas, *tokens*, claves privadas, archivos `.env` con secretos y copias
de la base de datos. El `.gitignore` ya los cubre; si agregás un archivo nuevo
que lleve un secreto, **sumalo ahí antes del primer commit**.

Lo que sí entra es el `.env.example`: los nombres de las variables, sin
valores.

### Y una advertencia sobre finales de línea

El `.gitattributes` no es relleno. Git en Windows suele venir con
`core.autocrlf=true`, que convierte los archivos a CRLF al clonarlos. Eso no
molesta hasta que el archivo se monta dentro de un contenedor Linux y lo
ejecuta `/bin/sh`:

```
/backup.sh: set: line 7: illegal option -
```

El *shell* lee `set -u\r` y el retorno de carro pasa a ser parte del
argumento. **Ya pasó una vez y dejó el servicio de copias reiniciándose en
bucle.** El `.gitattributes` fuerza LF en todo lo que se ejecuta o se
interpreta dentro de un contenedor, así que le funciona igual a cualquiera que
clone el repositorio.
