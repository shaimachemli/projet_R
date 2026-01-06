# Kids Screen Time Analysis - Projet R

---

## 📌 Présentation du Projet

Analyse de l'impact du temps d'écran sur la santé des enfants - Une étude data-driven basée sur un échantillon de **9,668 enfants** âgés de 8 à 18 ans.

L'usage des technologies numériques transforme profondément le quotidien des enfants, surtout dans les pays émergents. Ce projet quantifie les risques et propose des recommandations basées sur des données empiriques.

**Auteur :** Shaima Chemli  
**Date :** Janvier 2026  
**Technologies :** R, Quarto, reveal.js, WebR

---

## 🎯 Objectifs du Projet

- ✅ Analyser l'exposition aux écrans par groupe d'âge
- ✅ Identifier les appareils les plus risqués pour la santé
- ✅ Évaluer les impacts sanitaires réels (sommeil, vision, anxiété)
- ✅ Identifier les facteurs de protection (contenu éducatif)
- ✅ Proposer des recommandations basées sur les données
- ✅ Créer une présentation interactive et pédagogique

---

## 📊 Description du Dataset

### Source et Taille
- **Population :** 9,668 enfants indiens
- **Âge :** 8-18 ans
- **Format :** CSV (données nettoyées)

### Variables Clés

| Variable | Description |
|----------|-------------|
| `Age` | Âge de l'enfant (8-18) |
| `Age_Group` | Groupe d'âge (8-10, 11-13, 14-16, 17-18) |
| `Gender` | Sexe (Male/Female) |
| `Avg_Daily_Screen_Time_hr` | Temps écran moyen/jour en heures |
| `Primary_Device` | Appareil principal (Smartphone, Laptop, TV, Tablet) |
| `Exceeded_Recommended_Limit` | Dépasse limite recommandée (TRUE/FALSE) |
| `Has_Health_Impact` | Impacts santé documentés (TRUE/FALSE) |
| `Health_Impacts` | Détails des impacts (Poor Sleep, Eye Strain, Anxiety, Obesity) |
| `Educational_to_Recreational_Ratio` | Ratio contenu éducatif/récréatif |
| `Urban_or_Rural` | Zone géographique (Urban/Rural) |

### Statistiques Principales

- **85.8%** dépassent les limites recommandées
- **67.1%** présentent des impacts sanitaires
- **Temps moyen :** 4.37 h/jour
- **Âge moyen :** 12.98 ans

---

## 🧪 Méthodologie

### Préparation des Données
- ✓ Import et validation des données brutes
- ✓ Suppression des doublons et valeurs manquantes
- ✓ Création de variables dérivées (Age_Group, Screen_Category, Education_Level)
- ✓ Production du dataset final nettoyé

### Analyse Descriptive
- ✓ Statistiques globales (moyennes, distributions, pourcentages)
- ✓ Distribution par groupes d'âge
- ✓ Analyse par type d'appareil
- ✓ Conformité aux limites recommandées

### Analyse des Impacts Santé
- ✓ Corrélation temps d'écran ↔ impacts santé
- ✓ Prévalence des problèmes spécifiques (sommeil, vision, anxiété)
- ✓ Analyse par appareil et risque associé
- ✓ Identification de groupes vulnérables

### Tests Statistiques
- ✓ **T-test** : comparaisons de moyennes (Genre, Urbain/Rural)

### Analyses Comparatives
- ✓ Genre (garçons vs filles)
- ✓ Zone géographique (urbain vs rural)
- ✓ Effet protecteur du contenu éducatif
- ✓ Profils à risque vs profils sains

### Visualisations
- ✓ 8 graphiques stratégiques générés avec ggplot2
- ✓ Distributions, corrélations, comparaisons
- ✓ Export PNG haute qualité

---

## 🛠️ Technologies et Outils Utilisés

### Langage & Environnement
- **R** 4.0+ : analyse statistique et visualisation
- **RStudio** : environnement de développement
- **Quarto** : présentation interactive avec WebR

### Packages R Utilisés
- **ggplot2** : visualisations professionnelles
- **dplyr** : manipulation et transformation de données
- **knitr** : génération de tables formatées
- **tidyr** : nettoyage des données
- **effsize** : tailles d'effet (Cohen's d)

### Frameworks & Outils
- **WebR** : exécution R interactive dans le navigateur
- **reveal.js** : présentation en slides
- **Git/GitHub** : versioning et collaboration

---

## 📁 Structure du Projet

```
Kids-Screen-Time-Analysis/
│
├── data/
│   ├── screen_time_children.csv      # Données brutes
│   └── screen_time_clean.csv         # Données nettoyées
│
├── scripts/
│   ├── 01_load_explore.R             # Chargement et exploration
│   ├── 02_nettoyage.R                # Nettoyage des données
│   ├── 03_descriptive_stats.R        # Statistiques descriptives
│   ├── 04_analysis.R                 # Tests statistiques
│   ├── 05_visualizations.R           # Génération graphiques
│   └── tableau_bord.R                # Dashboard interactif
│
├── slides/
│   ├── presentation.qmd              # Slides avec WebR
│   └── presentation.html             # Version compilée
│
├── outputs/
│   └── plots/
│       ├── 01_screen_time_distribution.png
│       ├── 02_screen_time_by_age.png
│       ├── 03_exceeded_limit.png
│       ├── 04_screen_time_by_device.png
│       ├── 05_health_impact_by_screen_time.png
│       ├── 06_education_level_protective.png
│       ├── 07_health_problems_top.png
│       └── 08_risk_profiles.png
│
├── _quarto.yml
├── .gitignore
└── README.md
```

---
