# Experimental Design and Data Analysis (EDDA)

Coursework for the Experimental Design and Data Analysis course at the University of Amsterdam. This repository contains R Markdown reports covering a range of statistical methods, including hypothesis testing (t-tests, ANOVA, chi-squared tests), linear and nonlinear regression, and mixed-effects models. Each assignment applies these techniques to real-world datasets, with reproducible analyses and visualisations throughout.

## Key Tools and Packages

- **R** with R Markdown for literate statistical programming
- **ggplot2** for data visualisation
- **lme4** for mixed-effects modelling
- **tidyverse** and **broom** for data wrangling and tidy model output
- **Nix flakes** for reproducible environment management

## Repository Structure

- `src/` — Assignment 1 R scripts and R Markdown reports
- `src2/` — Additional analyses (Assignment 2, nonlinear regression)
- `assignment2/` — Assignment 2 R Markdown source and compiled PDFs
- `data/` — Datasets used across assignments (Titanic, cholesterol, crops, coups)

## How to Run

1. Install [Nix](https://nixos.org/download.html) with flakes enabled.
2. Enter the development environment:
   ```bash
   nix develop
   ```
3. Open any `.Rmd` file in RStudio or render from the command line:
   ```bash
   Rscript -e "rmarkdown::render('src/exercise_2.rmd')"
   ```

## Course

Experimental Design and Data Analysis, MSc, University of Amsterdam
