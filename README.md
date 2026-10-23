# Wraith — Fixed-Wing EDF UAV

Wraith is a fixed-wing, electric-ducted-fan UAV project exploring remote communications relay applications. The project also serves as a hands-on aircraft engineering effort, using analytical calculations, design studies, simulations and testing to justify design choices.

**Status:** Research and development. Analyses and results should be interpreted with their stated assumptions and validation status.

## Repository content

- **README.md:** Project overview and navigation.
- **analysis/:** Reproducible MATLAB and Python engineering scripts, organized by discipline.
- **docs/decisions/:** Individual design decision reports, added when a decision is documented.
- **results/:** Selected figures, tables, test measurements and simulation summaries, added alongside source scripts and reports.

This repository stores engineering artifacts, not personal checklists, process manuals, or empty templates. New directories will appear when they contain actual work.

## Available scripts

| File | Purpose | Status |
| --- | --- | --- |
| [CFD boundary calculations](analysis/propulsion/Wraith_CFD_Boundary_Calculations.m) | Estimates inlet freestream conditions and EDF mass flow for CFD boundary conditions at several altitudes | Preliminary; assumptions and fan operating-point model have not been independently validated |

The existing MATLAB script was relocated without changing its equations. Its mass-flow estimate should not be interpreted as a measured or validated EDF performance map.

## Engineering record

Each meaningful script, decision report or result should be self-contained enough to explain its assumptions, governing physics, units, inputs, interpretation and validation status. Report links should connect to the associated scripts and result files as those artifacts are added.
