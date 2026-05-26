# Dupire Local Volatility Model

This repository contains a university project developed during my MSc in Mathematical Engineering, with a focus on quantitative finance and computational derivatives pricing.

The project implements and calibrates a Dupire local volatility model using market implied volatility data. The analysis includes finite-difference PDE solving, Monte Carlo simulation, implied volatility surface calibration and pricing of vanilla, digital and forward-starting options.

## Main objectives

- Build and calibrate a local volatility surface
- Solve the Dupire PDE using finite-difference methods
- Compare market implied volatilities and model-implied volatilities
- Simulate asset dynamics under the local volatility framework
- Price vanilla, digital and forward-starting options
- Analyse smile dynamics and forward smile flattening
- Detect arbitrage inconsistencies in market option data
- Compare Local Volatility and Black model pricing

## Repository structure

- `run_local_volatility_project.m` is the main script used to run the full project
- `calibrator.m` calibrates the local volatility matrix through an iterative fixed-point procedure :contentReference[oaicite:0]{index=0}
- `model_volatility.m` computes model implied volatilities from the calibrated local volatility surface :contentReference[oaicite:1]{index=1}
- `solve_dupire.m` solves the Dupire partial differential equation using finite-difference schemes including Crank-Nicolson :contentReference[oaicite:2]{index=2}
- `LocalVolatilityModel_Report.pdf` contains the final report and discussion of the results
- Additional MATLAB functions are used for simulation, interpolation and pricing routines

## Numerical methods

The project uses:

- Dupire local volatility framework
- Finite-difference PDE methods
- Crank-Nicolson discretisation
- Monte Carlo simulation
- Fixed-point calibration algorithms
- Black-Scholes implied volatility inversion

## Main analyses

The project includes:

### Local volatility calibration

Calibration of the local volatility surface to market implied volatilities, together with convergence analysis of the calibration error. :contentReference[oaicite:3]{index=3}

### Forward smile analysis

Study of forward smile flattening under the local volatility framework and comparison between spot and forward implied volatility smiles. :contentReference[oaicite:4]{index=4}

### Arbitrage detection

Analysis of arbitrage violations in option market data through convexity conditions on option prices. :contentReference[oaicite:5]{index=5}

### FX derivatives pricing

Calibration and pricing analysis on EUR/USD options, including vanilla and digital derivatives under both Local Volatility and Black models. :contentReference[oaicite:6]{index=6}

## How to run the code

Open MATLAB and set the working directory to the project folder.

Then run:

```matlab
run_local_volatility_project
