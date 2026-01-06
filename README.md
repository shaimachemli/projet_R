# projet_R
# projet_R
Kids Screen Time Analysis - Projet R
📋 Aperçu du Projet
Analyse de l'impact du temps d'écran sur la santé des enfants  - Une étude data-driven basée sur un échantillon de 9,668 enfants âgés de 8 à 18 ans.

Auteur : Shaima Chemli
Date : Janvier 2026
Technologies : R, Quarto, reveal.js, WebR

🎯 Objectifs du Projet
Ce projet vise à analyser scientifiquement les effets de l'exposition aux écrans numériques sur la santé physique et comportementale des enfants, avec pour finalités :

Éclairer les décisions parentales concernant l'usage des technologies

Guider les stratégies éducatives dans les écoles

Informer les politiques publiques de santé

📊 Données Utilisées
Source : Dataset original et nettoyé

Échantillon : 9,668 enfants  (8-18 ans)

Fichiers disponibles :

data/screen_time_children.csv - Données brutes

data/screen_time_clean.csv - Données nettoyées et préparées

Variables clés :

Temps d'écran quotidien moyen

Type d'appareil principal

Impacts sanitaires documentés

Ratio contenu éducatif/récréatif

Démographie (âge, genre, localisation)

🏗️ Structure du Projet
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
🔍 Méthodologie d'Analyse
1. Préparation des Données
Scripts : 01_load_explore.R, 02_nettoyage.R

Import des fichiers CSV bruts (screen_time_children.csv)

Validation initiale : dimensions, types de variables, valeurs manquantes

Nettoyage systématique : suppression des doublons, gestion des NA

Création de variables dérivées :

Age_Group (8-10, 11-13, 14-16, 17-18)

Screen_Category (Faible, Modéré, Élevé, Très élevé)

Education_Level (Très peu, Peu, Équilibré, Très éducatif)

Production du dataset final : screen_time_clean.csv

2. Analyse Descriptive
Script : 03_descriptive_stats.R

Statistiques globales : 9,668 enfants, âge moyen, temps écran moyen (4.3h/j)

Distribution par groupes d'âge : les 11-13 ans = groupe le plus exposé (89.8% dépassement)

Conformité aux limites : 85.8% dépassent les recommandations

Répartition par appareil : Smartphone #1, Laptop = plus risqué (73.5% impacts)

Analyse urbain vs rural : différences significatives d'accès et d'usage

Catégorisation temps écran : 4 niveaux avec impacts santé progressifs

3. Analyse des Impacts Santé
Script : 04_analysis.R

Corrélation forte : temps écran → impacts santé (R = 0.42)

Prévalence problèmes : Sommeil (50.3%) > Vue (24.6%) > Anxiété (16.6%)

Appareils à risque : Laptop (73.5%) > Smartphone (68.2%) > TV (63.8%) > Tablette (62.3%)

Identification profils extrêmes :

1,106 enfants en danger (>6h + impacts)

792 enfants sains (<2h + 0 impacts)

4. Analyses Comparatives & Tests Statistiques
Scripts : 04_analysis.R

Genre : aucune différence significative (t-test, p > 0.05)

Zone géographique : urbains > ruraux (Mann-Whitney, p < 0.001)

Effet protecteur éducatif : contenu éducatif réduit impacts de 20.6% (Chi² significatif)

Tests de validation :

Chi² appareil vs dépassement limite : association forte (p < 0.001)

T-test genre : non significatif (cohen's d = 0.02)

Corrélations multiples : temps écran ↔ impacts santé confirmée

5. Visualisations & Communication
Script : 05_visualizations.R

8 graphiques stratégiques générés automatiquement

Focus sur messages clés : dépassement limite, groupes à risque, effet protecteur

Format standardisé pour présentation Quarto

Export PNG haute qualité pour rapports et présentations

6. Présentation Interactive
Fichier : slides/presentation.qmd

Synthèse complète des analyses

Intégration directe des résultats et visualisations

Format reveal.js pour navigation interactive
