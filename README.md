
# projet_R
# Kids Screen Time Analysis - Projet R

## 📋 Aperçu du Projet
Analyse de l'impact du temps d'écran sur la santé des enfants - Une étude data-driven basée sur un échantillon de 9,668 enfants âgés de 8 à 18 ans.

**Auteur :** Shaima Chemli  
**Date :** Janvier 2026  
**Technologies :** R, Quarto, reveal.js, WebR

---

## 📊 Résultats Clés
- **85.8%** des enfants dépassent les limites recommandées
- **67.1%** présentent des impacts sanitaires
- Groupe le plus à risque : **11-13 ans** (89.8% dépassement)
- Facteur protecteur : **contenu éducatif** (-20.6% d'impacts)

---

## 🏗️ Structure du Projet

text
Kids-Screen-Time-Analysis/
│
├── data/
│   ├── screen_time_children.csv     # Données brutes originales
│   └── screen_time_clean.csv        # Données nettoyées et préparées
│
├── scripts/                         # Scripts R modulaires
│   ├── 01_load_explore.R            # Chargement et exploration initiale
│   ├── 02_nettoyage.R               # Nettoyage et préparation des données
│   ├── 03_descriptive_stats.R       # Statistiques descriptives globales
│   ├── 04_analysis.R                # Analyses avancées et tests statistiques
│   ├── 05_visualizations.R          # Génération de graphiques
│   └── tableau_bord.R               # Tableau de bord interactif
│
├── slides/                          # Présentation Quarto
│   ├── presentation.qmd             # Slides principales
│   ├── presentation.html            # Version HTML compilée
│   └── presentation_files/          # Assets de la présentation
│
├── outputs/                         # Résultats exportés
│   └── plots/                       # Visualisations sauvegardées
│       ├── 01_screen_time_distribution.png
│       ├── 02_screen_time_by_age.png
│       ├── 03_exceeded_limit.png
│       ├── 04_screen_time_by_device.png
│       ├── 05_health_impact_by_screen_time.png
│       ├── 06_education_level_protective.png
│       ├── 07_health_problems_top.png
│       └── 08_risk_profiles.png
│
├── _quarto.yml                      # Configuration Quarto
├── .gitignore                       # Fichiers ignorés par Git
├── README.md                        # Documentation du projet
└── extensions/                      # Extensions Quarto


---

## 🔍 Méthodologie d'Analyse

### 1. Préparation des Données
**Scripts :** `01_load_explore.R`, `02_nettoyage.R`
- Import des fichiers CSV bruts (`screen_time_children.csv`)
- Validation initiale : dimensions, types de variables, valeurs manquantes
- Nettoyage systématique : suppression des doublons, gestion des NA
- Création de variables dérivées :
  - `Age_Group` (8-10, 11-13, 14-16, 17-18)
  - `Screen_Category` (Faible, Modéré, Élevé, Très élevé)
  - `Education_Level` (Très peu, Peu, Équilibré, Très éducatif)
- Production du dataset final : `screen_time_clean.csv`

### 2. Analyse Descriptive
**Script :** `03_descriptive_stats.R`
- Statistiques globales : 9,668 enfants, âge moyen, temps écran moyen (4.3h/j)
- Distribution par groupes d'âge : les 11-13 ans = groupe le plus exposé (89.8% dépassement)
- Conformité aux limites : **85.8%** dépassent les recommandations
- Répartition par appareil : Smartphone #1, Laptop = plus risqué (73.5% impacts)

### 3. Analyse des Impacts Santé
**Script :** `04_analysis.R`
- Corrélation forte : temps écran → impacts santé (R = 0.42)
- Prévalence problèmes : Sommeil (50.3%) > Vue (24.6%) > Anxiété (16.6%)
- Appareils à risque : Laptop (73.5%) > Smartphone (68.2%) > TV (63.8%) > Tablette (62.3%)

### 4. Analyses Comparatives & Tests Statistiques
**Scripts :** `04_analysis.R`
- Genre : aucune différence significative (t-test, p > 0.05)
- Zone géographique : urbains > ruraux (Mann-Whitney, p < 0.001)
- Effet protecteur éducatif : contenu éducatif réduit impacts de 20.6%

### 5. Visualisations & Communication
**Script :** `05_visualizations.R`
- 8 graphiques stratégiques générés automatiquement
- Focus sur messages clés : dépassement limite, groupes à risque, effet protecteur
- Export PNG haute qualité pour rapports et présentations

---


