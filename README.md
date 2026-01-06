

# Kids Screen Time Analysis - Projet R

## 📋 Aperçu du Projet

Analyse de l'impact du temps d'écran sur la santé des enfants - Une étude data-driven basée sur un échantillon de **9,668 enfants** âgés de 8 à 18 ans.

**Auteur :** Shaima Chemli  
**Date :** Janvier 2026  
**Technologies :** R, Quarto, reveal.js, WebR

---

## 📊 Résultats Clés

- **85.8%** des enfants dépassent les limites recommandées
- **67.1%** présentent des impacts sanitaires
- Groupe le plus à risque : **11-13 ans** (89.8% dépassement)
- Facteur protecteur : **contenu éducatif** (-20.6% d'impacts)
- Appareil le plus risqué : **Laptop** (73.5% impacts santé)
- Problème #1 : **Poor Sleep** (50.3% affectés)

---
## 🏗️ Structure du Projet

```
Kids-Screen-Time-Analysis/
│
├── data/
│   ├── screen_time_children.csv      # Données brutes originales
│   └── screen_time_clean.csv         # Données nettoyées et préparées
│
├── scripts/                          # Scripts R modulaires
│   ├── 01_load_explore.R             # Chargement et exploration initiale
│   ├── 02_nettoyage.R                # Nettoyage et préparation des données
│   ├── 03_descriptive_stats.R        # Statistiques descriptives globales
│   ├── 04_analysis.R                 # Analyses avancées et tests statistiques
│   ├── 05_visualizations.R           # Génération de graphiques
│   └── tableau_bord.R                # Tableau de bord interactif
│
├── slides/                           # Présentation Quarto
│   ├── presentation.qmd              # Slides principales avec WebR
│   └── presentation.html             # Version HTML compilée
│
├── outputs/                          # Résultats exportés
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
├── _quarto.yml                       # Configuration Quarto
├── .gitignore                        # Fichiers ignorés par Git
└── README.md                         # Ce fichier
```

---
