# Analysis inventory

This folder contains reproducible engineering calculations. Create subdirectories *when work exists* rather than filling the repository with empty placeholders.

| Analysis | Method | Current status | Known review needs |
| --- | --- | --- | --- |
| [CFD boundary calculations](propulsion/Wraith_CFD_Boundary_Calculations.m) | MATLAB | Legacy script preserved unchanged; **not independently validated** | Check atmospheric consistency, EDF thrust-to-flow assumptions, inlet/exit control-volume interpretation, and scenario applicability |

## New analysis checklist

- [ ] Equation(s) and definitions are documented
- [ ] Input values, units and source are documented
- [ ] Adjustable parameters are separated from solver logic
- [ ] Run instructions and dependencies are given
- [ ] Sanity check and model limitations are documented
- [ ] Figure/data output has labels and provenance
- [ ] Result is connected to a documented engineering decision

## Legacy script review notes

The existing script uses a prescribed 300 mph freestream, altitude scenarios at 0/300/10000 m, an assumed room-temperature lapse model, and a manufacturer-derived static thrust value to estimate mass flow. It is useful as a starting point for understanding boundary conditions, **not a verified EDF performance model**.

In particular, the momentum relationship and idealized streamtube area assumptions need careful physical review before being used to set CFD fan-face boundaries. The static-thrust-derived mass-flow estimate should not be treated as valid at the stated flight speed without a fan performance map or appropriate operating-point model. Temperature and standard-atmosphere assumptions also need reconciliation. No numerical changes were made during this organizational pass.
