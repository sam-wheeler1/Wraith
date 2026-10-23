# Wraith — Fixed-Wing EDF UAV

**Project goal:** Develop a fixed-wing, electric-ducted-fan UAV concept for remote communications relay applications while building a rigorous, reproducible understanding of aircraft engineering.

> **Status: Research and development.** This repository is an engineering notebook and design record, not evidence that a complete aircraft has been built or flight-qualified.

## Start here

- [Project status and evidence](docs/project-status.md) — what is in GitHub, what is reported but not yet archived, and what still needs verification.
- [Engineering workflow](docs/engineering-workflow.md) — expectations for calculations, units, assumptions, validation, and commit history.
- [Analysis index](analysis/README.md) — MATLAB/Python calculation inventory.
- [Design decision log](docs/decisions/README.md) — why configurations are selected or rejected.
- [Analysis report template](docs/templates/analysis-report.md) — a consistent record for calculations, simulations, and tests.

## Engineering areas

| Workstream | Intended questions | Current repository evidence |
| --- | --- | --- |
| Aircraft configuration & aerodynamics | Wing sizing, airfoils, stability, controls, performance | Not yet committed |
| Propulsion & inlet | EDF operating point, pressure recovery, duct/nozzle design | [CFD boundary calculation](analysis/propulsion/Wraith_CFD_Boundary_Calculations.m) |
| Structures | Wing loads, spars, deflection, stress, vibration | Not yet committed |
| Controls & instrumentation | DAQ, safety interlocks, sensors, flight control | Not yet committed |
| Testing & verification | Bench measurements, uncertainty, CFD/FEA correlation | Not yet committed |

## Repository layout

- `analysis/`: executable scripts, derived models, and their documentation.
- `docs/`: project status, decision records, methods, and templates.
- `data/`: small, documented input measurements or reference datasets (create as needed).
- `cad/`: versioned design exports or links to controlled CAD releases (create as needed).
- `simulation/`: solver setup descriptions, small configuration files, and result summaries (create as needed).
- `tests/`: test plans, logs, scripts, and measured-versus-predicted comparisons (create as needed).

Do **not** commit large solver caches, generated meshes, or untraceable binary exports. Store a reproducible setup plus selected results; link to external artifact storage when files are too large.

## Current code

The existing MATLAB calculation was moved **without changing its equations or numerical behavior** to [analysis/propulsion/Wraith_CFD_Boundary_Calculations.m](analysis/propulsion/Wraith_CFD_Boundary_Calculations.m). Its existing assumptions require verification before results are used as design inputs. See the [analysis index](analysis/README.md).

## Guiding principle

The result alone is not the deliverable. Record the physics, equations, assumptions, code, verification, and design conclusion, so another engineer can understand and reproduce the work.
