# Dupire Local Volatility Model

This repository contains a university project developed during my MSc in Mathematical Engineering, with a focus on quantitative finance and computational derivatives pricing.

The project implements and calibrates a Dupire local volatility model using market implied volatility data. The analysis combines finite-difference PDE methods, Monte Carlo simulation and volatility surface calibration for the pricing and analysis of derivative products.

## Main objectives

- Build and calibrate a local volatility surface from market implied volatilities
- Solve the Dupire partial differential equation using finite-difference methods
- Compare market implied volatilities and model-implied volatilities
- Simulate asset dynamics under the local volatility framework
- Price vanilla, digital and forward-starting options
- Analyse volatility smile dynamics and forward smile flattening
- Detect arbitrage inconsistencies in market option data
- Compare Local Volatility and Black model pricing approaches

## Repository structure

- `run_local_volatility_project.m`  
  Main script used to run the full project.

- `calibrator.m`  
  Calibrates the local volatility matrix through an iterative fixed-point calibration procedure.

- `model_volatility.m`  
  Computes model implied volatilities from the calibrated local volatility surface.

- `solve_dupire.m`  
  Solves the Dupire partial differential equation using finite-difference schemes, including Crank-Nicolson discretisation.

- `LocalVolatilityModel_Report.pdf`  
  Final report containing methodology, numerical results and discussion.

- Additional MATLAB functions  
  Used for simulation, interpolation, pricing and numerical routines.

## Numerical methods

The project uses several computational finance techniques, including:

- Dupire local volatility framework
- Finite-difference PDE solving
- Crank-Nicolson discretisation
- Monte Carlo simulation
- Fixed-point calibration algorithms
- Black-Scholes implied volatility inversion

## Main analyses

### Local volatility calibration

Calibration of the local volatility surface to market implied volatilities together with convergence analysis of the calibration error.

### Forward smile analysis

Study of forward smile flattening under the local volatility framework and comparison between spot and forward implied volatility smiles.

### Arbitrage detection

Analysis of arbitrage violations in option market data through convexity conditions on option prices.

### FX derivatives pricing

Calibration and pricing analysis on EUR/USD options, including vanilla and digital derivatives under both Local Volatility and Black models.

## How to run the code

Open MATLAB and set the working directory to the project folder.

Then run:

```matlab
run_local_volatility_project
