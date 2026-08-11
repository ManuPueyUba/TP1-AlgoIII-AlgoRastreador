# AlgoRastreador Z 🛰️

First assignment ("TP1") for **Algoritmos y Programación III (75.07/95.02)** — School of Engineering, University of Buenos Aires (FIUBA). Implemented in **Smalltalk (Pharo)**, applying object-oriented design, polymorphism, and exception handling, validated with unit tests and **mutation testing**.

## Overview

`AlgoRastreadorZ` simulates the "scouter" system from the Dragon Ball universe: a device that measures a fighter's **power level** from their base ki, applying a **transformation** (Base, Kaio-Ken, Great Ape) and a **scouter model** (Old or New) that interprets that reading.

The system allows you to:

- Register a fighter's reading given their name, base ki, transformation, and the scouter model used.
- Query the power level of an already registered fighter.
- Retrieve, according to a configurable criterion, the **strongest** or **weakest** fighter among all registered ones.

### The domain problem

- **Old** scouters have a hardware flaw: they cannot read power levels above 9000, so anything exceeding that saturates at that value.
- **New** scouters have no such limitation and return the actual reading.
- A fighter can reach different transformations that modify their base ki before it's measured: `Base` (leaves it unchanged), `Kaio-Ken` (doubles it), or `Great Ape` (multiplies it and rounds up to the next power of two).

This combination of rules is what makes the modeling interesting: the same fighter can yield different results depending on which scouter measures them, which lends itself well to being solved with **polymorphism** instead of conditionals.

## Object-oriented design

The design avoids cascading `ifTrue:`/`ifFalse:` chains by applying **Inheritance + Polymorphism** (Strategy Pattern) across three independent hierarchies, each with a `deTipo:` (`ofType:`) class-side method acting as a *factory*:

| Hierarchy | Responsibility | Subclasses |
|---|---|---|
| `Criterio` (Criterion) | Pick a fighter from a list based on a comparison criterion | `CriterioFuerte` (Strongest), `CriterioDebil` (Weakest) |
| `Modelo` (Model) | Interpret a scouter's ki reading | `ModeloViejo` (Old), `ModeloNuevo` (New) |
| `Transformacion` (Transformation) | Modify a fighter's base ki | `Base`, `KaioKen`, `MonoGigante` (Great Ape) |

The central class `AlgoRastreadorZ` (AlgoTrackerZ) knows about and coordinates these hierarchies, but delegates all specific logic to them — so adding a new scouter model or a new transformation doesn't require touching existing code, only adding a subclass.

```
AlgoRastreadorZ
 ├─ criterio: Criterio            (Strongest | Weakest)
 └─ peleadores: OrderedCollection<Peleador>

Peleador (Fighter)
 ├─ modelo: Modelo                (Old | New)
 └─ transformacion: Transformacion (Base | Kaio-Ken | Great Ape)
```

### Exceptions

Custom domain exceptions were defined for each violated precondition, instead of letting generic Smalltalk errors surface:

- `CriterioNoValidoException` (invalid criterion)
- `ModeloNoValidoException` (invalid model)
- `TransformacionNoValidaException` (invalid transformation)
- `KiNoValidoException` (ki less than or equal to 0)
- `PeleadorNoRegistradoException` (fighter not registered)

### Design assumptions

- A fighter's ki must be strictly greater than 0.
- Fighter, criterion, and model names must be entered exactly as expected (case-sensitive).
- If two fighters have the same power level, the search criterion keeps the one registered first.

## Repository structure

```
TP1-AlgoIII-AlgoRastreador/
├── Re Entrega TP1/       # Final submitted version (recommended)
│   ├── TP1-Clases.st         # Domain model
│   ├── TP1-Casos-de-Uso.st   # Unit tests (SUnit)
│   ├── TP1-Mutalk.txt.txt    # Mutation testing configuration
│   └── 111014_tp.pdf         # Report: class diagrams, sequence diagrams, and design rationale
└── TP1/                  # Original first submission
    ├── TP1-Clases.st
    ├── TP1-Casos-de-Uso.st
    ├── Mutantes.txt
    └── 111014-tp1s.pdf.pdf
```

> The **`Re Entrega TP1`** folder contains the corrected, final version after the professor's feedback (improvements such as `Dictionary`-based factories instead of `ifTrue:` chains, and a simplified domain model that removes the intermediate `Rastreo` class). It best reflects the final design.

## Testing

The project was developed with **TDD** using SUnit, covering:

- Expected behavior of every model, transformation, and criterion.
- Edge cases (ki exactly at the 9000 threshold, empty lists, etc.).
- That each exception fires under its corresponding invalid precondition.

Additionally, a **mutation testing** analysis was run (using [Mutalk](https://github.com/Escuela-de-Programacion/Mutalk) on Pharo) to verify the actual quality of the test suite: variants ("mutants") of the production code are generated, and the existing tests are checked to confirm they catch the behavior change.

## How to run it

This project is meant to run on [Pharo](https://pharo.org/):

1. Download and install [Pharo Launcher](https://pharo.org/download) and create a new image.
2. Open a *Playground* and load the `.st` files (`TP1-Clases.st` and `TP1-Casos-de-Uso.st` inside `Re Entrega TP1/`), for example by dragging them into the Pharo window or using the *File Browser*.
3. Run the tests from Pharo's **Test Runner** on the `TP1-Casos-de-Uso` package.

### Usage example

```smalltalk
tracker := AlgoRastreadorZ conCriterioMas: 'Fuerte'. "with Strongest criterion"

tracker
    registrarRastreoConModelo: 'Nuevo'
    delPeleadorConNombre: 'Goku'
    KiBase: 5000
    yTransformacion: 'Kaio-Ken'.

tracker
    registrarRastreoConModelo: 'Viejo'
    delPeleadorConNombre: 'Napa'
    KiBase: 4000
    yTransformacion: 'Base'.

tracker nivelDePeleaDe: 'Goku'.         "10000"
tracker obtenerPeleadorSegunCriterio.   "'Goku'"
```

## Additional documentation

The report (`111014_tp.pdf`) includes the full class diagram and UML sequence diagrams documenting the flow of creating an `AlgoRastreadorZ`, registering a reading, and searching for a fighter by criterion.

## Author

**Manuel Pueyrredón** — Student ID 111014 — FIUBA
