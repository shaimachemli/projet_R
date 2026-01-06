---
title: "Analyse du Temps d'Écran chez les Enfants"
subtitle: "Impact des appareils numériques sur la santé des enfants"
author: "Shaima Chemli"
date: '2026-01-03'
format: 
  revealjs:
    scrollable: true
    footer: '<a href="https://github.com/shaimachemli/projet_R" style="position: fixed; bottom: 10px; right: 10px; z-index: 1000;"><svg width="24" height="24" viewBox="0 0 24 24" fill="#0366d6"><path d="M10 20v-6h4v6h5v-8h3L12 3 2 12h3v8z"/></svg></a>'
    transition: fade
    background-transition: fade
    width: 1200
    height: 800
    theme: default
    highlight-style: github
    slide-number: c/t
webr:
  packages: ['ggplot2', 'dplyr', 'knitr']
filters:
  - webr
---

# 📱 Analyse du temps d'écran chez les enfants

## Introduction

**Contexte :** L'usage des technologies numériques transforme profondément le quotidien des enfants, surtout dans les pays émergents. L'accès aux smartphones, tablettes et téléviseurs s'est fortement démocratisé ces 10 dernières années.

**Enjeux :** Cette transition soulève des préoccupations de santé publique, notamment chez les enfants et adolescents, population particulièrement vulnérable aux effets d'une **exposition prolongée aux écrans**.

---

## 🎯 Étude et Objectifs

-   **Échantillon :** 9,668 enfants indiens (8-18 ans)
-   **Variables clés :**
    -   ⏰ Temps d'écran quotidien
    -   📱 Type d'appareil utilisé
    -   🏥 Indicateurs de santé physique et comportementale
-   **Objectif :** Fournir une analyse fondée sur les données pour éclairer :
    -   👨‍👩‍👧 Décisions parentales
    -   🎓 Stratégies éducatives
    -   🏛️ Politiques de santé publique

---

## ❓ Problématique

> Dans quelle mesure l'utilisation des écrans influence-t-elle la santé des enfants, et quels facteurs peuvent moduler ces effets ?

**Questions de recherche :**

- Combien de temps les enfants passent-ils sur les écrans ?
- Quels appareils sont les plus utilisés ?
- Quelles conséquences pour la santé ?
- Existe-t-il des facteurs de protection ?
- Comment les recommandations varient-elles par groupe d'âge ?

---

# 📊 Data Loading & Exploration

## Chargement et Structure des Données

```{webr-r}
library(ggplot2)
library(dplyr)

# Chargement des données
url <- "https://raw.githubusercontent.com/shaimachemli/projet_R/refs/heads/main/data/screen_time_clean.csv"
data <- read.csv(url, stringsAsFactors = FALSE)

cat("✅ DONNÉES CHARGÉES AVEC SUCCÈS\n\n")
cat("Dimensions : ", nrow(data), " lignes × ", ncol(data), " colonnes\n")
cat("Variables : ", paste(colnames(data), collapse=" | "), "\n\n")

# Structure
str(data)
```

---

## 📈 Statistiques Descriptives Globales

```{webr-r}
cat("═══════════════════════════════════════════════════════════\n")
cat("📊 STATISTIQUES GLOBALES\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# Calculer les statistiques
cat(sprintf("%-35s %s\n", "Population totale:", format(nrow(data), big.mark=",")))
cat(sprintf("%-35s %s\n", "Âge moyen:", paste0(round(mean(data$Age), 1), " ans")))
cat(sprintf("%-35s %s\n", "Âge min - max:", paste0(min(data$Age), " - ", max(data$Age), " ans")))
cat(sprintf("%-35s %s\n", "Temps écran moyen:", paste0(round(mean(data$Avg_Daily_Screen_Time_hr), 2), " h/jour")))
cat(sprintf("%-35s %s\n", "% Dépassement limite:", paste0(round(sum(data$Exceeded_Recommended_Limit=="True")/nrow(data)*100, 1), "%")))
cat(sprintf("%-35s %s\n", "% Impacts santé:", paste0(round(sum(data$Has_Health_Impact==TRUE)/nrow(data)*100, 1), "%")))
```

---

# 📍 PARTIE 1 : Résultats Descriptifs

## 1.1 Distribution par Groupe d'Âge

```{webr-r}
# Calcul des statistiques par groupe d'âge
age_group_stats <- data %>%
  group_by(Age_Group) %>%
  summarise(
    Count = n(),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Exceeded_Pct = round(sum(Exceeded_Recommended_Limit=="True")/n()*100, 1),
    Health_Impact_Pct = round(sum(Has_Health_Impact==TRUE)/n()*100, 1),
    .groups='drop'
  ) %>%
  arrange(match(Age_Group, c("8-10", "11-13", "14-16", "17-18")))

# Graphique
ggplot(age_group_stats, aes(x = Age_Group, y = Mean_Screen_Time, fill = Age_Group)) +
  geom_col(alpha = 0.8, color = "white", linewidth = 1.5) +
  geom_text(aes(label = paste0(Mean_Screen_Time, "h")), 
            vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("#FF6B6B", "#4ECDC4", "#45B7D1", "#FFA07A")) +
  labs(
    title = "Temps d'écran par groupe d'âge",
    subtitle = "11-13 ans: exposition la plus élevée",
    x = "Groupe d'âge",
    y = "Heures/jour"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face="bold", size=16),
    plot.subtitle = element_text(size=12, color="gray40")
  )
```

---

## 1.2 Conformité aux Limites Recommandées

```{webr-r}
# Calcul des pourcentages
exceeded_data <- data %>%
  group_by(Exceeded_Recommended_Limit) %>%
  summarise(Count = n(), .groups='drop') %>%
  mutate(
    Pct = round(Count/sum(Count)*100, 1),
    Label = ifelse(Exceeded_Recommended_Limit=="True", "Dépassement", "Conforme")
  )

# Graphique circulaire
ggplot(exceeded_data, aes(x = "", y = Count, fill = Label)) +
  geom_col(width = 1, color = "white", linewidth = 2) +
  coord_polar(theta = "y") +
  geom_text(aes(label = paste0(Pct, "%")), 
            position = position_stack(vjust = 0.5),
            fontface = "bold", size = 8, color = "white") +
  scale_fill_manual(values = c("#27AE60", "#E74C3C")) +
  labs(title = "Conformité aux limites recommandées") +
  theme_void(base_size = 14) +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    plot.title = element_text(face="bold", hjust=0.5, size=16)
  )
```

---

## 1.3 Distribution des Appareils Principaux

```{webr-r}
# Statistiques par appareil
device_stats <- data %>%
  group_by(Primary_Device) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 1),
    .groups='drop'
  ) %>%
  arrange(desc(Count))

# Graphique horizontal
ggplot(device_stats, aes(x = reorder(Primary_Device, Count), y = Count, fill = Primary_Device)) +
  geom_col(alpha = 0.85, color = "white", linewidth = 1.5) +
  geom_text(aes(label = paste0(Count, " (", Pct, "%)")), 
            hjust = -0.1, fontface = "bold", size = 4) +
  scale_fill_manual(values = c("#3498DB", "#E67E22", "#9B59B6", "#1ABC9C")) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Distribution de l'utilisation des appareils", 
    x = "Appareil", 
    y = "Nombre d'enfants"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face="bold", size=16)
  )
```

---

# 🏥 PARTIE 2 : Impacts Santé

## 2.1 Temps d'écran vs Impacts Santé

```{webr-r}
cat("📌 TEMPS D'ÉCRAN × IMPACTS SANTÉ\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# Création des catégories et statistiques
screen_impact <- data %>%
  mutate(
    Screen_Category = case_when(
      Avg_Daily_Screen_Time_hr < 2 ~ "Faible (<2h)",
      Avg_Daily_Screen_Time_hr < 4 ~ "Modéré (2-4h)",
      Avg_Daily_Screen_Time_hr < 6 ~ "Élevé (4-6h)",
      TRUE ~ "Très élevé (>6h)"
    )
  ) %>%
  group_by(Screen_Category) %>%
  summarise(
    Total = n(),
    Avec_Impact = sum(Has_Health_Impact==TRUE),
    Sans_Impact = sum(Has_Health_Impact==FALSE),
    Impact_Pct = round(sum(Has_Health_Impact==TRUE)/n()*100, 1),
    .groups='drop'
  ) %>%
  arrange(match(Screen_Category, c("Faible (<2h)", "Modéré (2-4h)", "Élevé (4-6h)", "Très élevé (>6h)")))

# Affichage formaté
cat(sprintf("%-20s | %-8s | %-13s | %-13s | %-10s\n", 
            "Catégorie", "Total", "Avec Impact", "Sans Impact", "Impact %"))
cat(strrep("-", 75), "\n")

for(i in 1:nrow(screen_impact)) {
  cat(sprintf("%-20s | %-8d | %-13d | %-13d | %-10s\n",
              screen_impact$Screen_Category[i],
              screen_impact$Total[i],
              screen_impact$Avec_Impact[i],
              screen_impact$Sans_Impact[i],
              paste0(screen_impact$Impact_Pct[i], "%")))
}

cat("\n🚨 CORRÉLATION CLAIRE:\n")
cat("   • <2h  : 0.0% impacts ✅\n")
cat("   • 2-4h : 55.9% impacts ⚠️\n")
cat("   • 4-6h : 81.4% impacts 🔴\n")
cat("   • >6h  : 81.8% impacts 🚨\n")
```

---

## 2.2 Visualisation des Impacts Santé

```{webr-r}
# Graphique des impacts par catégorie
impact_plot_data <- data %>%
  mutate(
    Screen_Category = case_when(
      Avg_Daily_Screen_Time_hr < 2 ~ "Faible (<2h)",
      Avg_Daily_Screen_Time_hr < 4 ~ "Modéré (2-4h)",
      Avg_Daily_Screen_Time_hr < 6 ~ "Élevé (4-6h)",
      TRUE ~ "Très élevé (>6h)"
    )
  ) %>%
  group_by(Screen_Category) %>%
  summarise(Impact_Pct = round(sum(Has_Health_Impact==TRUE)/n()*100, 1), .groups='drop') %>%
  mutate(Screen_Category = factor(Screen_Category, 
                                  levels = c("Faible (<2h)", "Modéré (2-4h)", 
                                           "Élevé (4-6h)", "Très élevé (>6h)")))

ggplot(impact_plot_data, aes(x = Screen_Category, y = Impact_Pct, fill = Screen_Category)) +
  geom_col(alpha = 0.85, color = "white", linewidth = 1.5) +
  geom_text(aes(label = paste0(Impact_Pct, "%")), 
            vjust = -0.5, fontface = "bold", size = 6) +
  scale_fill_manual(values = c("#27AE60", "#F39C12", "#E74C3C", "#C0392B")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  labs(
    title = "Impact santé selon le temps d'écran",
    subtitle = "Corrélation forte entre temps d'écran et problèmes de santé",
    x = "Catégorie de temps d'écran",
    y = "% d'enfants avec problèmes de santé"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face="bold", size=16),
    plot.subtitle = element_text(size=12, color="gray40"),
    axis.text.x = element_text(angle = 15, hjust = 1)
  )
```

---

# 📈 PARTIE 3 : Analyses Comparatives

## 3.1 Comparaison par Genre

```{webr-r}
# Statistiques par genre
gender_stats <- data %>%
  group_by(Gender) %>%
  summarise(
    Count = n(),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Health_Impact_Pct = round(sum(Has_Health_Impact==TRUE)/n()*100, 1),
    .groups='drop'
  )

# Graphique
ggplot(gender_stats, aes(x = Gender, y = Mean_Screen_Time, fill = Gender)) +
  geom_col(alpha = 0.85, color = "white", linewidth = 1.5, width = 0.6) +
  geom_text(aes(label = paste0(Mean_Screen_Time, " h/jour")), 
            vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("#FF69B4", "#4169E1")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.15))) +
  labs(
    title = "Temps d'écran moyen selon le genre",
    subtitle = paste0("Garçons: ", gender_stats$Mean_Screen_Time[1], "h | Filles: ", 
                     gender_stats$Mean_Screen_Time[2], "h"),
    x = "Genre",
    y = "Heures/jour"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face="bold", size=16),
    plot.subtitle = element_text(size=12, color="gray40")
  )
```

---

## 3.2 Effet Protecteur du Contenu Éducatif

```{webr-r}
# Analyse du ratio éducatif
edu_stats <- data %>%
  mutate(
    Education_Level = case_when(
      Educational_to_Recreational_Ratio < 0.37 ~ "Très faible",
      Educational_to_Recreational_Ratio < 0.43 ~ "Faible",
      Educational_to_Recreational_Ratio < 0.48 ~ "Équilibré",
      TRUE ~ "Très élevé"
    )
  ) %>%
  group_by(Education_Level) %>%
  summarise(
    Count = n(),
    Impact_Pct = round(sum(Has_Health_Impact==TRUE)/n()*100, 1),
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3),
    .groups='drop'
  ) %>%
  mutate(Education_Level = factor(Education_Level, 
                                  levels = c("Très faible", "Faible", "Équilibré", "Très élevé")))

# Graphique
ggplot(edu_stats, aes(x = Education_Level, y = Impact_Pct, fill = Education_Level)) +
  geom_col(alpha = 0.85, color = "white", linewidth = 1.5) +
  geom_text(aes(label = paste0(Impact_Pct, "%")), 
            vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("#E74C3C", "#F39C12", "#FFC107", "#27AE60")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Effet protecteur du contenu éducatif",
    subtitle = "Plus le contenu est éducatif, moins d'impacts santé",
    x = "Niveau de contenu éducatif",
    y = "% Impact santé"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    plot.title = element_text(face="bold", size=16),
    plot.subtitle = element_text(size=12, color="gray40"),
    axis.text.x = element_text(angle = 15, hjust = 1)
  )
```

---

# 🔬 PARTIE 4 : Tests Statistiques

## 4.1 Test t: Garçons vs Filles

```{webr-r}
cat("════════════════════════════════════════════════════════════\n")
cat("TEST T - TEMPS D'ÉCRAN : GARÇONS vs FILLES\n")
cat("════════════════════════════════════════════════════════════\n\n")

# Préparation des données
boys <- data$Avg_Daily_Screen_Time_hr[data$Gender == "Male"]
girls <- data$Avg_Daily_Screen_Time_hr[data$Gender == "Female"]

# Statistiques descriptives
cat("STATISTIQUES DESCRIPTIVES:\n")
cat(sprintf("  Garçons (n=%d)  : Moyenne = %.3f h/jour\n", length(boys), mean(boys)))
cat(sprintf("  Filles  (n=%d) : Moyenne = %.3f h/jour\n\n", length(girls), mean(girls)))

# Test t
t_result <- t.test(boys, girls, var.equal = TRUE)

cat("RÉSULTATS DU TEST T:\n")
cat(sprintf("  Statistique t = %.4f\n", t_result$statistic))
cat(sprintf("  Valeur-p      = %.4f\n", t_result$p.value))
cat(sprintf("  IC 95%%        = [%.4f ; %.4f]\n\n", t_result$conf.int[1], t_result$conf.int[2]))

# Interprétation
if(t_result$p.value < 0.05) {
  cat("✓ RÉSULTAT: DIFFÉRENCE SIGNIFICATIVE (p < 0.05)\n")
  cat("   Les garçons et les filles ont un temps d'écran différent.\n")
} else {
  cat("✗ RÉSULTAT: PAS DE DIFFÉRENCE SIGNIFICATIVE (p ≥ 0.05)\n")
  cat("   Les garçons et les filles ont un temps d'écran similaire.\n")
}

# Cohen's d pour taille d'effet
n1 <- length(boys)
n2 <- length(girls)
pooled_sd <- sqrt(((n1-1)*var(boys) + (n2-1)*var(girls))/(n1+n2-2))
cohens_d <- abs(mean(boys) - mean(girls))/pooled_sd

cat(sprintf("\nTAILLE D'EFFET (Cohen's d) = %.4f ", cohens_d))
if(cohens_d < 0.2) cat("(Négligeable)\n")
else if(cohens_d < 0.5) cat("(Petit)\n")
else if(cohens_d < 0.8) cat("(Moyen)\n")
else cat("(Grand)\n")
```

---

## 4.2 Test Chi-carré: Appareil vs Dépassement Limite

```{webr-r}
cat("════════════════════════════════════════════════════════════\n")
cat("TEST CHI-CARRÉ - APPAREIL vs DÉPASSEMENT DE LIMITE\n")
cat("════════════════════════════════════════════════════════════\n\n")

# Table de contingence
contingency <- table(data$Primary_Device, data$Exceeded_Recommended_Limit)

cat("TABLE DE CONTINGENCE:\n")
cat(sprintf("%-12s | %-10s | %-10s\n", "Appareil", "Conforme", "Dépassement"))
cat(strrep("-", 40), "\n")
for(i in 1:nrow(contingency)) {
  cat(sprintf("%-12s | %-10d | %-10d\n", 
              rownames(contingency)[i],
              contingency[i, 1],
              contingency[i, 2]))
}
cat("\n")

# Test chi-carré
chi_result <- chisq.test(contingency)

cat("RÉSULTATS DU CHI-CARRÉ:\n")
cat(sprintf("  Chi-carré          = %.2f\n", chi_result$statistic))
cat(sprintf("  Valeur-p           = %.6f\n", chi_result$p.value))
cat(sprintf("  Degrés de liberté  = %d\n\n", chi_result$parameter))

# Interprétation
if(chi_result$p.value < 0.001) {
  cat("✓ RÉSULTAT: ASSOCIATION HAUTEMENT SIGNIFICATIVE (p < 0.001)\n")
  cat("   → Le type d'appareil influence fortement le dépassement.\n")
} else if(chi_result$p.value < 0.05) {
  cat("✓ RÉSULTAT: ASSOCIATION SIGNIFICATIVE (p < 0.05)\n")
  cat("   → Le type d'appareil influence le dépassement.\n")
} else {
  cat("✗ RÉSULTAT: PAS D'ASSOCIATION SIGNIFICATIVE (p ≥ 0.05)\n")
  cat("   → Le type d'appareil n'influence pas le dépassement.\n")
}
```

---

## 4.3 Test t: Ratio Éducatif vs Impact Santé

```{webr-r}
cat("════════════════════════════════════════════════════════════\n")
cat("TEST T - RATIO ÉDUCATIF vs IMPACT SANTÉ\n")
cat("════════════════════════════════════════════════════════════\n\n")

# Préparation des données
with_impact <- data$Educational_to_Recreational_Ratio[data$Has_Health_Impact == TRUE]
without_impact <- data$Educational_to_Recreational_Ratio[data$Has_Health_Impact == FALSE]

# Statistiques descriptives
cat("STATISTIQUES DESCRIPTIVES:\n")
cat(sprintf("  Avec impact (n=%d)    : Ratio moyen = %.4f\n", length(with_impact), mean(with_impact)))
cat(sprintf("  Sans impact (n=%d)   : Ratio moyen = %.4f\n\n", length(without_impact), mean(without_impact)))

# Test t (Welch pour variances différentes)
t_result_edu <- t.test(without_impact, with_impact, var.equal = FALSE)

cat("RÉSULTATS DU TEST T (Welch):\n")
cat(sprintf("  Statistique t = %.4f\n", t_result_edu$statistic))
cat(sprintf("  Valeur-p      = %.2e\n", t_result_edu$p.value))
cat(sprintf("  IC 95%%        = [%.4f ; %.4f]\n\n", t_result_edu$conf.int[1], t_result_edu$conf.int[2]))

# Interprétation
if(t_result_edu$p.value < 0.001) {
  cat("✓ RÉSULTAT: DIFFÉRENCE HAUTEMENT SIGNIFICATIVE (p < 0.001)\n")
  cat("   → Le ratio éducatif a un effet protecteur majeur sur la santé.\n")
  cat("   → Plus de contenu éducatif = moins de problèmes de santé.\n")
} else if(t_result_edu$p.value < 0.05) {
  cat("✓ RÉSULTAT: DIFFÉRENCE SIGNIFICATIVE (p < 0.05)\n")
  cat("   → Le ratio éducatif influence la santé.\n")
} else {
  cat("✗ RÉSULTAT: PAS DE DIFFÉRENCE SIGNIFICATIVE (p ≥ 0.05)\n")
}
```

---

# 🎯 PARTIE 5 : Résultats Clés & Recommandations

## Résultats Critiques

```{webr-r}
cat("═══════════════════════════════════════════════════════════\n")
cat("🚨 RÉSULTATS CLÉS DE L'ÉTUDE\n")
cat("═══════════════════════════════════════════════════════════\n\n")


data$Exceeded_Recommended_Limit <- as.logical(data$Exceeded_Recommended_Limit)
data$Has_Health_Impact <- as.logical(data$Has_Health_Impact)

# --- Calculs des statistiques clés ---
exceeded_pct <- round(sum(data$Exceeded_Recommended_Limit)/nrow(data)*100, 1)
health_impact_pct <- round(sum(data$Has_Health_Impact)/nrow(data)*100, 1)

# Troubles du sommeil
poor_sleep_pct <- round(sum(grepl("Poor Sleep", data$Health_Impacts))/nrow(data)*100, 1)

# 11-13 ans
age_11_13 <- data %>% filter(Age_Group == "11-13")
age_11_13_exceed <- round(sum(age_11_13$Exceeded_Recommended_Limit)/nrow(age_11_13)*100, 1)

# Effet éducatif
edu_low <- data %>% filter(Educational_to_Recreational_Ratio < 0.4)
edu_high <- data %>% filter(Educational_to_Recreational_Ratio >= 0.48)
edu_diff <- round(sum(edu_low$Has_Health_Impact)/nrow(edu_low)*100, 1) - 
            round(sum(edu_high$Has_Health_Impact)/nrow(edu_high)*100, 1)

# --- Affichage ---
cat("═══════════════════════════════════════════════════════════\n")
cat("🚨 RÉSULTATS CLÉS DE L'ÉTUDE\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat(sprintf("%-2s. %-60s %s\n", "1", 
            paste0(exceeded_pct, "% des enfants dépassent les limites recommandées"),
            "🔴 CRITIQUE"))
cat(sprintf("%-2s. %-60s %s\n", "2", 
            paste0("11-13 ans: groupe à risque le plus élevé (", age_11_13_exceed, "% dépassent)"),
            "🔴 CRITIQUE"))
cat(sprintf("%-2s. %-60s %s\n", "3", 
            paste0("Corrélation claire: + temps d'écran → + problèmes santé (", health_impact_pct, "% impactés)"),
            "⚠️  SÉVÈRE"))
cat(sprintf("%-2s. %-60s %s\n", "4", 
            paste0("Troubles du sommeil affectent ", poor_sleep_pct, "% de la population"),
            "⚠️  MAJEUR"))
cat(sprintf("%-2s. %-60s %s\n", "5", 
            paste0("Contenu éducatif réduit les impacts de ~", edu_diff, "%"),
            "✅ PROTECTEUR"))
cat(sprintf("%-2s. %-60s %s\n", "6", 
            "Laptop & Smartphone = appareils à risque élevé",
            "⚠️  RISQUE"))

```

---

## 💡 Recommandations par Groupe d'Âge

::: columns
::: {.column width="33%"}
### **8-10 ans**

- ⏰ Max: **2h/jour**
- 📚 ≥50% éducatif
- 📱 TV/Tablette préféré
- ⏸️ Pause 15min/30min
- 👨‍👩‍👧 Supervision parentale
:::

::: {.column width="33%"}
### **11-13 ans** 🚨

- ⏰ Max: **3h/jour**
- 📚 Ratio ≥0.5
- 🔒 Contrôle strict
- 😴 Surveiller sommeil
- 👥 Activités sociales
:::

::: {.column width="33%"}
### **14-18 ans**

- ⏰ Max: **3-4h/jour**
- 🌙 Filtre bleu >20h
- 📚Priorité à l'éducation
- 😴Hygiène de sommeil
:::
:::

---

## Seuils d'Intervention

| Temps d'écran | Risque santé | Action        | Urgence  |
|---------------|--------------|---------------|----------|
| < 2h/jour     | 0%           | ✅ Maintenir  | Aucun    |
| 2-4h/jour     | 56%          | ⚠️ Surveiller | Faible   |
| 4-6h/jour     | 81%          | 🔴 Intervenir | Élevé    |
| > 6h/jour     | 82%          | 🚨 URGENT     | Critique |

---




## Conclusion

> **Les données montrent une réelle préoccupation de santé publique :** 85,8% des enfants indiens dépassent les recommandations de temps d'écran, avec 67,1% présentant des impacts sur la santé.

**Actions prioritaires :**

1. 🎯 Cibler les 11-13 ans (groupe à risque le plus élevé)
2. 📚 Promouvoir le contenu éducatif (effet protecteur ~20%)
3. 👨‍👩‍👧 Sensibilisation parentale
4. 🏥 Suivi médical pour les enfants exposés >6h/jour

---

## Merci pour votre attention 