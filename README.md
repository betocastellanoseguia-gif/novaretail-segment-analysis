# NovaRetail — Customer Behavior and Spending Analysis (R)

End-to-end statistical analysis of 300 online-retail customers in R: descriptive statistics, conditional probability, hypothesis tests (t-test and one-way ANOVA), correlation and multiple linear regression. Coursework project for **Probability and Statistics for Data Science** (Software Engineering, Universidad Tecmilenio).

---

## Key findings

- **Segment barely changes the odds of buying; behavior does.** Overall purchase probability is 0.687 (206 of 300 customers) and ranges only 0.65–0.71 across segments. A discount of 15% or more lifts it to 0.764 (vs 0.633 below 15%), and 12+ minutes on site lifts it to 0.749 (vs 0.613).
- **Buyers spend more time on the site:** 12.63 vs 11.35 minutes, t(298) = −2.699, p = 0.0073, so H₀ is rejected.
- **Average spending does not differ significantly across segments:** F(2, 297) = 2.671, p = 0.0708 (marginal). Premium has the lowest sample mean ($61.22).
- **Discount is the strongest correlate of spending** (r = 0.518), followed by time on site (0.396) and visits (0.315). Age is unrelated (−0.041).
- **A multiple regression explains 53.3% of the variance in spending** (adjusted R² = 0.529) using only visits, time on site and discount.

---

## Questions

1. Which customers are more likely to buy?
2. Do buyers spend more time on the site than non-buyers?
3. Does average spending differ between the three segments?
4. Which variables are most strongly related to spending?
5. Can spending be anticipated from behavior observed before the purchase?

---

## Dataset

`novaretail_dataset.csv` — 300 records, 8 variables, no missing values:

| Variable | Type | Description |
|---|---|---|
| `customer_id` | int | Unique customer identifier |
| `age` | int | Customer age |
| `segment` | factor | Nuevo (New, n = 138) / Frecuente (Frequent, n = 111) / Premium (n = 51) |
| `visits_last_month` | int | Visit count in the last month |
| `time_on_site_min` | num | Average session duration in minutes |
| `discount_percent` | int | Discount applied (0–20%) |
| `purchased` | int | Purchase flag (0/1) |
| `spending_usd` | num | Spending in USD — response variable |

Data note: the minimum recorded age is 2, which is implausible for an online customer. It was left as-is because age only enters the correlation table, not the tests or the regression.

---

## Method

1. Load the data and convert `segment` to a factor.
2. Descriptive statistics and a histogram of spending.
3. Basic and conditional probability of purchase by segment, discount, time on site and visits.
4. Two-sample t-test on time on site (buyers vs non-buyers) and one-way ANOVA (`aov`) on spending by segment, both at α = 0.05.
5. Pearson correlations with spending, plus a scatter plot with a simple regression line.
6. Multiple linear regression of spending on visits, time on site and discount (`lm`).

---

## Results

**Descriptive statistics**

| Variable | Mean | Median | SD | Min | Max |
|---|---|---|---|---|---|
| Age (years) | 34.41 | 35.00 | 9.87 | 2.00 | 73.00 |
| Visits per month | 7.91 | 8.00 | 2.70 | 2.00 | 15.00 |
| Time on site (min) | 12.23 | 12.43 | 3.87 | 1.26 | 20.88 |
| Discount (%) | 10.08 | 10.00 | 7.14 | 0.00 | 20.00 |
| Spending (USD) | 65.50 | 65.78 | 15.41 | 21.18 | 114.28 |

**Purchase probability by condition**

| Condition | P(purchase) |
|---|---|
| All customers | 0.6867 |
| Segment Nuevo / Frecuente / Premium | 0.7101 / 0.6486 / 0.7059 |
| Discount ≥ 15% / < 15% | 0.7642 / 0.6328 |
| Time on site ≥ 12 min / < 12 min | 0.7485 / 0.6131 |
| Visits ≥ 8 / < 8 per month | 0.7134 / 0.6544 |

**t-test: time on site, buyers vs non-buyers.** t(298) = −2.699, p = 0.0073, 95% CI of the difference 0.35 to 2.23 min. H₀ is rejected: buyers browse about 1.29 minutes longer.

**One-way ANOVA: spending by segment**

| Segment | n | Mean | SD | Min | Max |
|---|---|---|---|---|---|
| Nuevo | 138 | 67.02 | 15.38 | 25.98 | 98.31 |
| Frecuente | 111 | 65.57 | 15.03 | 31.05 | 114.28 |
| Premium | 51 | 61.22 | 15.81 | 21.18 | 88.80 |

F(2, 297) = 2.671, p = 0.0708. Since p ≥ 0.05, H₀ is **not rejected**: there is no evidence at the 5% level of a difference in average spending between segments.

**Correlation with spending**

| Variable | r |
|---|---|
| Discount (%) | 0.518 |
| Time on site | 0.396 |
| Visits per month | 0.315 |
| Age | −0.041 |

**Multiple linear regression**

`Spending = 20.04 + 2.16 · visits + 1.36 · time_on_site + 1.16 · discount`

| Term | Estimate | Std. error | t | p |
|---|---|---|---|---|
| Intercept | 20.04 | 2.84 | 7.05 | < 0.001 |
| Visits per month | 2.16 | 0.23 | 9.45 | < 0.001 |
| Time on site (min) | 1.36 | 0.16 | 8.60 | < 0.001 |
| Discount (%) | 1.16 | 0.09 | 13.36 | < 0.001 |

R² = 0.533 (adjusted 0.529), F(3, 296) = 112.8, p < 0.001, residual standard error $10.58. For an average customer, raising the discount from 10% to 15% adds about $5.80 of expected spending (5 × 1.16).

---

## Interpretation and limits

- The data are observational, so the results describe associations, not causal effects.
- The ANOVA p-value (0.0708) is marginal and the Premium group is small (n = 51). A larger sample could settle whether the lower Premium mean is real or noise.
- The regression leaves 46.7% of the variance unexplained and its typical error is about $10.6, so it suits aggregate estimates rather than exact individual predictions. Model checking is limited to a predicted-vs-observed plot.

---

## How to run

Requires R (4.x). No external packages — base R only. Put the CSV and the script in the same folder (or set the working directory to that folder):

```r
source("RetoFinal_NovaRetail.R")
```

The script prints every statistic above to the console and draws the plots with base R graphics. Code comments are in Spanish.

---

## Repository contents

- `RetoFinal_NovaRetail.R` — full analysis (all six steps)
- `novaretail_dataset.csv` — dataset (300 records)

---

## Techniques used

`factor()` · `tapply()` · conditional probabilities with logical subsetting · `t.test()` · `aov()` and `summary()` · `cor()` · `lm()` and `fitted()` · `hist()`, `boxplot()`, `barplot()` and `plot()` with `abline()`

---

## Author

**Roberto Yair Castellanos Eguia**
Software Engineering student, Universidad Tecmilenio
