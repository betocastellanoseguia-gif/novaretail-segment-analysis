# NovaRetail — Customer Segment Spending Analysis

One-way ANOVA testing whether average spending differs across customer segments, using R. Coursework project for **Probability and Statistics for Data Science** (Software Engineering, Universidad Tecmilenio).

---

## Research question

Is there a statistically significant difference in average spending (`spending_usd`) between the three customer segments — New, Frequent, and Premium?

- **H₀:** μ_New = μ_Frequent = μ_Premium
- **H₁:** at least one segment mean differs
- **Significance level:** α = 0.05

---

## Dataset

`novaretail_dataset.csv` — 300 records, 8 variables:

| Variable | Type | Description |
|---|---|---|
| `customer_id` | int | Unique customer identifier |
| `age` | int | Customer age |
| `segment` | factor | New / Frequent / Premium |
| `visits_last_month` | int | Visit count in the last month |
| `time_on_site_min` | num | Average session duration in minutes |
| `discount_percent` | int | Discount applied |
| `purchased` | int | Purchase flag (0/1) |
| `spending_usd` | num | Spending in USD — response variable |

---

## Method

1. Load data and convert `segment` to a factor with three levels
2. Compute descriptive statistics by group (n, mean, standard deviation, min, max)
3. Visualize: boxplot by segment and mean plot with ±1 SD error bars
4. Fit a one-way ANOVA (`aov`) with `spending_usd ~ segment`
5. Extract the p-value and evaluate against α = 0.05

---

## Results

**Descriptive statistics by segment**

| Segment | n | Mean | SD | Min | Max |
|---|---|---|---|---|---|
| New | 138 | 67.02 | 15.38 | 25.98 | 98.31 |
| Frequent | 111 | 65.57 | 15.03 | 31.05 | 114.28 |
| Premium | 51 | 61.22 | 15.81 | 21.18 | 88.80 |

**ANOVA:** p = 0.0708

Since p ≥ 0.05, the null hypothesis is **not rejected**. At the 5% significance level there is no evidence of a difference in average spending between the three segments. The observed differences — roughly six dollars between the highest and lowest group means — fall within what sampling variation alone would produce, and the boxplots show substantially overlapping distributions.

Worth noting: p = 0.0708 sits close to the threshold. A larger sample, particularly for the Premium segment (n = 51), might resolve whether the pattern is real or noise.

---

## How to run

Requires R (4.x). No external packages — base R only.

```r
source("Act5_NovaRetail.R")
```

Place the CSV in the same folder as the script, or set the working directory to the file location.

---

## Techniques used

`factor()` for categorical encoding · `aggregate()` with a custom summary function · `tapply()` for grouped means · `boxplot()` and `barplot()` with error bars via `arrows()` · `aov()` and `summary()` for hypothesis testing · conditional decision logic on the extracted p-value

---

## Author

**Roberto Yair Castellanos Eguia**
Software Engineering student, Universidad Tecmilenio
