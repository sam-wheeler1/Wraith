# Engineering workflow and repository standards

## For every meaningful calculation

1. **Question:** State the engineering decision and physical quantity being estimated.
2. **Derivation:** Name the governing equations and give a short derivation or source.
3. **Inputs:** Define each variable, unit, source, range, and uncertainty if relevant.
4. **Assumptions:** Identify steady/unsteady, incompressible/compressible, idealizations, environmental conditions and operating point.
5. **Implementation:** Keep MATLAB (`.m`) or Python (`.py`) code readable and version controlled. Make adjustable design parameters obvious.
6. **Validation:** Compare with an independent hand calculation, analytical limiting case, measurement, or an appropriately characterized solver.
7. **Interpretation:** Record sensitivity, limitations and the resulting design decision.
8. **Traceability:** Link code, source data, output plots and design-decision record.

## Practical conventions

- Prefer SI units internally; print units on all output and graph axes.
- Keep source data separate from derived outputs. Do not overwrite original test logs.
- Give every analysis a short README or report with run commands, tool/version, prerequisites, and expected outputs.
- Record all engineering constants and cite their source; do not silently use convenient assumed values.
- Preserve original scripts when restructuring. Put model corrections in separate, reviewed commits with before/after verification.
- Distinguish *estimated*, *simulated*, *measured*, and *validated*. They are not interchangeable.
- Use descriptive commit messages (e.g. `analysis: add wing-loading sweep and assumptions`).
- Use a branch + pull request for substantial modifications. Preserve main as a readable baseline.
- Review generated datasets, giant files, licenses, sensitive details, and simulation exports before committing.

## Suggested report fields

Copy [the report template](templates/analysis-report.md). Include version/revision, author, objective, equations, inputs/units, assumptions, method, verification, plots/tables, limitations, decision and follow-up.

## MATLAB and Python

Keep scripts in an engineering-domain subdirectory under `analysis/`. Add a `requirements.txt` or MATLAB toolbox note only when the script actually needs those dependencies. Prefer scripts that can be run independently with an obvious entry point.
