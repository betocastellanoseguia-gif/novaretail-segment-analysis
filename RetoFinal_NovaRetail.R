# ============================================================
# RETO FINAL — ANÁLISIS INTEGRADOR NOVARETAIL
# Curso:  LBMA2501 - Probabilidad y Estadística para Ciencia de Datos
# Alumno: Roberto Yair Castellanos Eguia
#
# Integra: descriptivos, probabilidad, inferencia (t y ANOVA),
# correlación y regresión lineal múltiple.
# ============================================================

# ---- 0. Cargar datos ---------------------------------------
datos <- read.csv("novaretail_dataset.csv")
datos$segment <- factor(datos$segment,
                        levels = c("Nuevo", "Frecuente", "Premium"))
str(datos)

# ---- 1. ANÁLISIS DESCRIPTIVO -------------------------------
vars <- c("age","visits_last_month","time_on_site_min",
          "discount_percent","spending_usd")
for (v in vars) {
  x <- datos[[v]]
  cat(sprintf("%s: media=%.2f mediana=%.2f sd=%.2f min=%.2f max=%.2f\n",
              v, mean(x), median(x), sd(x), min(x), max(x)))
}
table(datos$segment)

# Histograma del gasto
hist(datos$spending_usd, breaks = 20, col = "#7FB3AA", border = "white",
     main = "Distribución del gasto (USD) — 300 clientes",
     xlab = "Gasto (USD)", ylab = "Frecuencia")
abline(v = mean(datos$spending_usd), col = "#008E7E", lwd = 3, lty = 2)

# ---- 2. PROBABILIDAD BÁSICA Y CONDICIONAL ------------------
mean(datos$purchased)                                        # P(compra)
tapply(datos$purchased, datos$segment, mean)                 # P(compra|segmento)
mean(datos$purchased[datos$discount_percent >= 15])          # P(compra|desc>=15)
mean(datos$purchased[datos$discount_percent <  15])          # P(compra|desc<15)
mean(datos$purchased[datos$time_on_site_min >= 12])          # P(compra|tiempo>=12)
mean(datos$purchased[datos$time_on_site_min <  12])          # P(compra|tiempo<12)
mean(datos$purchased[datos$visits_last_month >= 8])          # P(compra|visitas>=8)
mean(datos$purchased[datos$visits_last_month <  8])          # P(compra|visitas<8)

# Gráfico de probabilidad por condición
probs <- c(mean(datos$purchased),
           mean(datos$purchased[datos$discount_percent >= 15]),
           mean(datos$purchased[datos$discount_percent <  15]),
           mean(datos$purchased[datos$time_on_site_min >= 12]),
           mean(datos$purchased[datos$time_on_site_min <  12]),
           mean(datos$purchased[datos$visits_last_month >= 8]),
           mean(datos$purchased[datos$visits_last_month <  8]))
nombres <- c("Global","Desc >=15%","Desc <15%","Tiempo >=12m",
             "Tiempo <12m","Visitas >=8","Visitas <8")
barplot(probs, names.arg = nombres, las = 2, ylim = c(0, 0.92),
        col = c("#4d4d4d","#008E7E","#B8D3CD","#008E7E",
                "#B8D3CD","#008E7E","#B8D3CD"),
        main = "Probabilidad de compra por condición", ylab = "P(compra)")

# ---- 3. INFERENCIA: PRUEBA T SOBRE MEDIAS ------------------
# H0: mu_tiempo(no compra) = mu_tiempo(compra) | alfa = 0.05
t.test(time_on_site_min ~ purchased, data = datos, var.equal = TRUE)
boxplot(time_on_site_min ~ purchased, data = datos,
        names = c("No compró","Sí compró"),
        col = c("#B8D3CD","#008E7E"),
        main = "Tiempo en sitio según decisión de compra",
        ylab = "Tiempo en sitio (min)")

# ---- 4. INFERENCIA: ANOVA DE UN FACTOR ---------------------
# H0: mu_Nuevo = mu_Frecuente = mu_Premium | alfa = 0.05
modelo_anova <- aov(spending_usd ~ segment, data = datos)
summary(modelo_anova)
boxplot(spending_usd ~ segment, data = datos,
        col = c("#B8D3CD","#7FB3AA","#008E7E"),
        main = "Gasto (USD) por segmento de cliente",
        xlab = "Segmento", ylab = "Gasto (USD)")

# ---- 5. CORRELACIÓN ----------------------------------------
cor(datos$visits_last_month, datos$spending_usd)
cor(datos$time_on_site_min,  datos$spending_usd)
cor(datos$discount_percent,  datos$spending_usd)
cor(datos$age,               datos$spending_usd)

# Dispersión con recta de regresión simple
plot(datos$discount_percent, datos$spending_usd, pch = 19,
     col = "#7FB3AACC",
     main = "Descuento (%) vs. Gasto (USD)",
     xlab = "Descuento (%)", ylab = "Gasto (USD)")
abline(lm(spending_usd ~ discount_percent, data = datos),
       col = "#008E7E", lwd = 3)

# ---- 6. REGRESIÓN LINEAL MÚLTIPLE --------------------------
modelo <- lm(spending_usd ~ visits_last_month + time_on_site_min +
             discount_percent, data = datos)
summary(modelo)

# Diagnóstico visual: predicho vs. observado
plot(fitted(modelo), datos$spending_usd, pch = 19, col = "#7FB3AACC",
     main = "Gasto predicho vs. observado (R2 = 0.533)",
     xlab = "Gasto predicho (USD)", ylab = "Gasto observado (USD)")
abline(0, 1, col = "#008E7E", lwd = 3, lty = 2)
