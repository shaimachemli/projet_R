---
title: "Kids Screen Time Analysis: Data Management and Statistical Analysis"
date: "2026-01-06"
format:
  html:
    theme: cosmo
    toc: true
webr:
  show-startup-message: false
  emulate-r: true
  packages: ["readr", "dplyr", "ggplot2", "effsize", "scales"]
filters:
  - webr


css: style.css
---



## Introduction

**Contexte :** L’usage des technologies numériques transforme profondément le quotidien des enfants, surtout dans les pays émergents.  
L’accès aux smartphones, tablettes et téléviseurs s’est fortement démocratisé ces 10 dernières années.

**Enjeux :** Cette transition soulève des préoccupations de santé publique, notamment chez les enfants et adolescents, population particulièrement vulnérable aux effets d’une **exposition prolongée aux écrans**.

---

## Étude et objectifs

- **Échantillon :** 9 668 enfants indiens
- **Variables clés :**
  - Temps d’écran quotidien
  - Type d’appareil utilisé
  - Indicateurs de santé physique et comportementale
- **Objectif :** Fournir une analyse fondée sur les données pour éclairer :
  - Décisions parentales
  - Stratégies éducatives
  - Politiques de santé publique

---

## Problématique

> Dans quelle mesure l’utilisation des écrans influence-t-elle la santé des enfants, et quels facteurs peuvent moduler ces effets ?

**Questions de recherche :**
- Combien de temps les enfants passent-ils sur les écrans ?
- Quels appareils sont les plus utilisés ?
- Quelles conséquences pour la santé ?
- Existe-t-il des facteurs de protection ?

---


## Exploration des données




```{webr-r}
url <- "https://raw.githubusercontent.com/shaimachemli/projet_R/refs/heads/main/data/screen_time_clean.csv"
screen_data <- read.csv(url)
dim(screen_data) # lignes / colonnes
summary(screen_data) # résumé des variables numériques
str(screen_data) # structure



```

---

## Données & aperçu du dataset

- **Observations :** 9 668 enfants
- **Variables :** 12 (ex. âge, sexe, temps d’écran, appareil principal, activité physique)
- **Types :** mix de numérique et catégoriel
- **Préparation :** valeurs manquantes traitées, variables harmonisées

---

## Distribution par groupe d’âge


---

```{webr-r}
age_group_stats <- screen_data %>%
  group_by(Age_Group) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(screen_data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Exceeded_Pct = round(sum(Exceeded_Recommended_Limit)/n()*100, 1),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  )

age_group_stats


```

💡 Les plus jeunes (8-10 ans) passent moins de temps sur les écrans, mais certains dépassent la limite.

---

##Distribution par sexe, appareil et localisation

```{webr-r}
gender_stats <- screen_data %>%
group_by(Gender) %>%
summarise(
Count=n(),
Mean_Screen_Time=round(mean(Avg_Daily_Screen_Time_hr),2),
Health_Impact_Pct=round(sum(Has_Health_Impact)/n()*100,1)
)
gender_stats
```

```{webr-r}
device_stats <- screen_data %>%
group_by(Primary_Device) %>%
summarise(
Count=n(),
Mean_Screen_Time=round(mean(Avg_Daily_Screen_Time_hr),2),
Health_Impact_Pct=round(sum(Has_Health_Impact)/n()*100,1)
) %>% arrange(desc(Count))
device_stats
```

```{webr-r}
location_stats <- screen_data %>%
group_by(Urban_or_Rural) %>%
summarise(
Count=n(),
Mean_Screen_Time=round(mean(Avg_Daily_Screen_Time_hr),2),
Health_Impact_Pct=round(sum(Has_Health_Impact)/n()*100,1)
)
location_stats
```

---

**Exercise 2:** Create a boxplot, and perform the tests. What is the effect size, i.e. by how many hours differs sleep duration?

```{webr-r}
boxplot(x1, x2, names = c("Drug 1", "Drug 2"), main = "Sleep Duration Comparison", col = c("lightblue", "lightgreen"))
```

```{webr-r}
# Effect size calculation
mean_diff <- mean(x2) - mean(x1)
pooled_sd <- sqrt((var(x1) + var(x2))/2)
effect_size <- mean_diff / pooled_sd
cat("Effect size (Cohen's d):", round(effect_size, 3))
```
---

## Paired t-test

Given is a number of students that passed an examination in statistics. The examination was written two times, one time before and one time after an additional series of lectures. The values represent the numbers of points approached during the examination. Check whether the additional lectures had any positive effect:

```{webr-r}
x1 <- c(69,  77, 35, 34, 87, 45, 95, 83)
x2 <- c(100, 97, 67, 42, 75, 73, 92, 97)
```

---

**Exercise 3:** The test was conducted by the same individuals before and after the course, so one can use a paired t-test:

```{webr-r}
t.test(x1, x2, paired = TRUE)
```

Then compare the results with the ordinary two-sample t-test:

```{webr-r}
t.test(x1, x2)
```

---

## Wilcoxon test (optional)

The Mann-Whitney and Wilxon tests are nonparametric tests of location. "Nonparametric" means, that the general location of the distributions is compared and not a parameter like the mean. This makes the test independent of distributional assumptions, but can sometimes lead to a vague interpretations.

---

**Exercise 4:** Now repeat the comparison for the sleep study using the Wilcoxon test for unpaired and paired samples. Note that the unpaired test is often also called "Mann-Whitney U test".

In R both tests can be found as `wilcox.test`. Use the help system of R (`?wilcox.test`) and read the help page about the usage of these tests.

---

```{webr-r}
# Unpaired: Mann-Whitney U test
wilcox.test(x1, x2)
```

```{webr-r}
# Paired test
wilcox.test(x1, x2, paired = TRUE)
```

---

## Own project: Weight of Clementine fruits

Import the Clementines data set (fruits-2023-hse.csv)[^fruits-data].

  * Think about an appropriate data structure and use a suitable statistical test to compare the weights.

  * Check variance homogeneity and normal distribution graphically.

  * Can the weights from each brand be considered as independent samples?

---

### Perform a statistical test for the following hypotheses

$H_0$: The weight of the fruits bought on Friday (box2) and on Monday (box1) are the same.

$H_A$: The weight of the fruits is different.

Select a proper statistical test and interpret its results.

---

```{webr-r}
url <- "https://tpetzoldt.github.io/datasets/data/fruits-2023-hse.csv"
fruits <- read.csv(url)

# Extract data for box1 and box2
weights_box1 <- fruits$weight[fruits$brand == "box1"]
weights_box2 <- fruits$weight[fruits$brand == "box2"]

cat("Box1: n =", length(weights_box1), "mean =", round(mean(weights_box1), 2), "\n")
cat("Box2: n =", length(weights_box2), "mean =", round(mean(weights_box2), 2), "\n\n")

# Statistical test
t_test_result <- t.test(weights_box1, weights_box2)
print(t_test_result)
```

---

### Calculate absolute and relative effect sizes

1. Calculate the mean values of both samples $\bar{x}_{1}, \bar{x}_{2}$ and the **absolute effect size**: $\Delta=\bar{x}_{1}-\bar{x}_{2}$

2. Calculate the pooled standard deviation ($N_1, N_2$ = sample size, $s_1, s_2$= standard deviation):

$s_{1,2} = \sqrt{\frac{(N_1 - 1) s_1^2 + (N_2 - 1) s_2^2)}{N_1 + N_2 - 2}}$

3. Calculate the relative effect size as $\delta=\frac{|\bar{x}_{1}-\bar{x}_{2}|}{s_{1,2}}$

4. Read in Wikipedia about [Cohen's d](https://en.wikipedia.org/wiki/Effect_size#Cohen's_d) and other measures of effect size.

---

```{webr-r}
# Effect sizes calculation
mean_x1 <- mean(weights_box1)
mean_x2 <- mean(weights_box2)
n1 <- length(weights_box1)
n2 <- length(weights_box2)

# Absolute effect size
absolute_effect <- mean_x1 - mean_x2

# Pooled standard deviation
pooled_sd <- sqrt(((n1-1)*var(weights_box1) + (n2-1)*var(weights_box2)) / (n1 + n2 - 2))

# Relative effect size (Cohen's d)
cohens_d <- abs(absolute_effect) / pooled_sd

cat("Absolute effect size (Δ):", round(absolute_effect, 3), "\n")
cat("Pooled standard deviation:", round(pooled_sd, 3), "\n")
cat("Cohen's d (δ):", round(cohens_d, 3), "\n")
```

---

## Chi-squared test and Fisher's exact test (optional)

### Introduction

Taken from Agresti (2002), Fisher's Tea Drinker:

"A British woman claimed to be able to distinguish whether milk or tea was added to the cup first. To test, she was given 8 cups of tea, in four of which milk was added first. The null hypothesis is that there is no association between the true order of pouring and the woman's guess, the alternative that there is a positive association (that the odds ratio is greater than 1)."

---

The experiment revealed the following outcome: With tea first, the tea taster identified three times the correct answer and was one time wrong and the same occurred with milk first (3 true, 1 wrong).

For a TV show this would be sufficient, but how big was the probability to get such a result just by chance?

---

### Methods and Results

We put the data into a matrix:

```{webr-r}
x <- matrix(c(3, 1, 1, 3), nrow = 2)
colnames(x) <- c("Guess: Milk first", "Guess: Tea first")
rownames(x) <- c("Actual: Milk first", "Actual: Tea first")
x
```

```{webr-r}
fisher.test(x)
```

---

This tests for an association between truth and guess, but if we want only positive associations, we should perform a one-sided test:

```{webr-r}
fisher.test(x, alternative = "greater")
```

A similar test can be performed with the chi-squared test, but this is not precise for small data sets, so the Fisher test should be preferred.

```{webr-r}
chisq.test(x)
```

---

### Discussion

**Exercise 5:** Compare the results of Fisher's exact test with `alternative="two.sided"` (the default) with `alternative = "greater"` and `less` and discuss the differences and their meaning. Which option is the best in this case?

---

**Exercise 6:** How many trials would be necessary to get a significant statistical result with $p < 0.05$ for the tea taster experiment, given that we allow one wrong decision for tea first and milk first?

---

### Background

Read the Wikipedia articles ["Lady tasting tea"](https://en.wikipedia.org/wiki/Lady_tasting_tea) about Fisher's experiment and Fisher's exact test and ["The Lady Tasting Tea"](https://en.wikipedia.org/wiki/The_Lady_Tasting_Tea) about a popular science book on the "statistical revolution" in the 20th century.

The odds ratio describes the strength of association in a two-by-two table, see explanation of ["Odds ratio"](https://en.wikipedia.org/wiki/Odds_ratio) in Wikipedia or a statistics text book.

---

## Exercise Solutions

---

### Exercise 1 - Solution

```{webr-r}
# Second drug data
x2 <- c(9.9, 8.8, 9.1, 8.1, 7.9, 12.4, 13.5, 9.6, 12.6, 11.4)

# One sample t-test with mu = 8
result_ex1 <- t.test(x2, mu = 8)
cat("=== EXERCISE 1 SOLUTION ===\n")
cat("Second drug test against 8 hours sleep:\n")
cat("p-value =", round(result_ex1$p.value, 4), "\n")
cat("Mean difference =", round(mean(x2) - 8, 2), "hours\n")

# Interpretation
if(result_ex1$p.value < 0.05) {
  cat("Conclusion: Reject H₀ - the drug significantly changes sleep duration\n")
} else {
  cat("Conclusion: Insufficient evidence to reject H₀\n")
}
```

---

### Exercise 2 - Solution

```{webr-r}
# Detailed effect size calculations
x1 <- c(8.7, 6.4, 7.8, 6.8, 7.9, 11.4, 11.7, 8.8, 8, 10)
x2 <- c(9.9, 8.8, 9.1, 8.1, 7.9, 12.4, 13.5, 9.6, 12.6, 11.4)

mean_x1 <- mean(x1)
mean_x2 <- mean(x2)
sd_x1 <- sd(x1)
sd_x2 <- sd(x2)

cat("=== EXERCISE 2 SOLUTION ===\n")
cat("Mean Drug 1:", round(mean_x1, 2), "hours\n")
cat("Mean Drug 2:", round(mean_x2, 2), "hours\n")
cat("Absolute difference:", round(mean_x2 - mean_x1, 2), "hours\n")

# Manual Cohen's d
n1 <- length(x1)
n2 <- length(x2)
pooled_sd <- sqrt(((n1-1)*sd_x1^2 + (n2-1)*sd_x2^2)/(n1+n2-2))
cohens_d <- (mean_x2 - mean_x1)/pooled_sd

cat("Cohen's d:", round(cohens_d, 3), "\n")
cat("Interpretation:", 
    ifelse(abs(cohens_d) < 0.2, "very small effect",
    ifelse(abs(cohens_d) < 0.5, "small effect",
    ifelse(abs(cohens_d) < 0.8, "medium effect", "large effect"))), "\n")
```

---

### Exercise 3 - Solution

```{webr-r}
# Paired vs unpaired comparison
x1 <- c(69, 77, 35, 34, 87, 45, 95, 83)
x2 <- c(100, 97, 67, 42, 75, 73, 92, 97)

cat("=== EXERCISE 3 SOLUTION ===\n")
cat("Paired t-test results:\n")
paired_test <- t.test(x1, x2, paired = TRUE)
print(paired_test)

cat("\nUnpaired t-test results:\n")
unpaired_test <- t.test(x1, x2)
print(unpaired_test)

cat("\nKey comparison:\n")
cat("Paired test p-value:", round(paired_test$p.value, 4), "\n")
cat("Unpaired test p-value:", round(unpaired_test$p.value, 4), "\n")
cat("Conclusion: Paired test is more appropriate for repeated measures\n")
```

---

### Exercise 4 - Solution

```{webr-r}
# Wilcoxon tests comparison
x1 <- c(69, 77, 35, 34, 87, 45, 95, 83)
x2 <- c(100, 97, 67, 42, 75, 73, 92, 97)

cat("=== EXERCISE 4 SOLUTION ===\n")
cat("Unpaired Wilcoxon test (Mann-Whitney):\n")
unpaired_wilcox <- wilcox.test(x1, x2)
print(unpaired_wilcox)

cat("\nPaired Wilcoxon test:\n")
paired_wilcox <- wilcox.test(x1, x2, paired = TRUE)
print(paired_wilcox)

cat("\nComparison with parametric tests:\n")
cat("Paired t-test p-value:", round(t.test(x1, x2, paired = TRUE)$p.value, 4), "\n")
cat("Paired Wilcoxon p-value:", round(paired_wilcox$p.value, 4), "\n")
cat("Non-parametric tests are more robust to outliers and distribution assumptions\n")
```

---

### Exercise 5 - Solution

```{webr-r}
# Fisher's exact test alternatives
x <- matrix(c(3, 1, 1, 3), nrow = 2)

cat("=== EXERCISE 5 SOLUTION ===\n")
cat("Two-sided test (default):\n")
fisher_two <- fisher.test(x)
cat("p-value =", round(fisher_two$p.value, 4), "\n")

cat("\nOne-sided test (greater):\n")
fisher_greater <- fisher.test(x, alternative = "greater")
cat("p-value =", round(fisher_greater$p.value, 4), "\n")

cat("\nOne-sided test (less):\n")
fisher_less <- fisher.test(x, alternative = "less")
cat("p-value =", round(fisher_less$p.value, 4), "\n")

cat("\nInterpretation:\n")
cat("The 'greater' alternative is most appropriate here\n")
cat("as we're testing if she can distinguish better than chance\n")
```

---

### Exercise 6 - Solution

```{webr-r}
# Sample size consideration for tea tasting
cat("=== EXERCISE 6 SOLUTION ===\n")
cat("With the current results (3 correct, 1 wrong for each type):\n")
x_current <- matrix(c(3, 1, 1, 3), nrow = 2)
fisher_current <- fisher.test(x_current, alternative = "greater")
cat("Current p-value =", round(fisher_current$p.value, 4), "\n")

cat("\nTo achieve p < 0.05 with one error allowed:\n")
cat("We would need perfect discrimination (4 correct, 0 wrong)\n")
x_perfect <- matrix(c(4, 0, 0, 4), nrow = 2)
fisher_perfect <- fisher.test(x_perfect, alternative = "greater")
cat("Perfect discrimination p-value =", round(fisher_perfect$p.value, 4), "\n")

cat("\nConclusion: 8 trials are sufficient with perfect performance\n")
cat("but with one error, more trials would be needed\n")
```

---


## References

[^fruits-data]: `fruits.csv` available from: [https://tpetzoldt.github.io/datasets/data/fruits-2023-hse.csv](https://tpetzoldt.github.io/datasets/data/fruits-2023-hse.csv)

- Student (1908) - The probable error of a mean
- Delacre et al. (2017) - Why psychologists should by default use Welch's t-test instead of Student's t-test