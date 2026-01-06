# ================================
# CRÉER PRÉSENTATION POWERPOINT PRO
# Fichier : create_ppt.R
# ================================

library(officer)
library(ggplot2)
library(magrittr)
library(dplyr)

cat("\n🎨 CRÉATION PRÉSENTATION POWERPOINT...\n\n")

# Load data
data <- read.csv("data/screen_time_clean.csv", stringsAsFactors = FALSE)

# ================================
# 1. CRÉER PRÉSENTATION
# ================================

prs <- read_pptx()

# Pas besoin de set_slide_size (widescreen par défaut)

# ================================
# SLIDE 1 : TITRE
# ================================

cat("📊 Slide 1 : Titre...\n")

slide <- add_slide(prs, layout = "Title Slide")
slide <- ph_with(
  slide,
  value = "📱 Analyse du Temps d'Écran",
  location = ph_location_type(type = "ctrTitle")
)
slide <- ph_with(
  slide,
  value = "Impact des appareils numériques sur la santé des enfants indiens\n9,668 enfants analysés",
  location = ph_location_type(type = "subTitle")
)
prs <- slide

# ================================
# SLIDE 2 : INTRODUCTION
# ================================

cat("📊 Slide 2 : Introduction...\n")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "🎯 Introduction",
  location = ph_location_type(type = "title")
)

content <- paste(
  "📌 Questions de Recherche :",
  "  • Combien de temps les enfants passent-ils sur les écrans ?",
  "  • Quels appareils sont les plus utilisés ?",
  "  • Quelles sont les conséquences pour la santé ?",
  "  • Existe-t-il des facteurs de protection ?",
  "",
  "📊 Dataset :",
  "  • 9,668 enfants indiens (8-18 ans)",
  "  • 8 variables principales",
  "  • Temps écran, appareils, impacts santé",
  sep = "\n"
)

slide <- ph_with(
  slide,
  value = content,
  location = ph_location_type(type = "body")
)
prs <- slide

# ================================
# SLIDE 3 : STATISTIQUES GLOBALES
# ================================

cat("📊 Slide 3 : Statistiques...\n")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "📊 Statistiques Globales",
  location = ph_location_type(type = "title")
)

stats_text <- sprintf(
  "✅ Total enfants : %d\n✅ Âge moyen : %.1f ans\n✅ Temps écran moyen : %.2f h/jour\n✅ %% dépassant limite : %.1f%%\n✅ %% avec impacts santé : %.1f%%\n\n🚨 RÉSULTAT : 85.8%% DÉPASSENT LA LIMITE !",
  nrow(data),
  mean(data$Age),
  mean(data$Avg_Daily_Screen_Time_hr),
  sum(data$Exceeded_Recommended_Limit)/nrow(data)*100,
  sum(data$Has_Health_Impact)/nrow(data)*100
)

slide <- ph_with(
  slide,
  value = stats_text,
  location = ph_location_type(type = "body")
)
prs <- slide

# ================================
# SLIDE 4 : DISTRIBUTION ÂGE
# ================================

cat("📊 Slide 4 : Distribution par âge...\n")

age_data <- data %>%
  group_by(Age_Group) %>%
  summarise(Mean_Screen = mean(Avg_Daily_Screen_Time_hr), .groups = 'drop') %>%
  arrange(match(Age_Group, c("8-10", "11-13", "14-16", "17-18")))

p_age <- ggplot(age_data, aes(x = Age_Group, y = Mean_Screen, fill = Age_Group)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = round(Mean_Screen, 2)), vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_viridis_d() +
  labs(title = "Temps d'Écran par Groupe d'Âge",
       x = "Groupe d'âge", y = "Heures/jour") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_text(size = 12),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

ggsave("temp_age.png", p_age, width = 10, height = 6, dpi = 150, bg = "white")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "👶 Distribution par Groupe d'Âge",
  location = ph_location_type(type = "title")
)
slide <- ph_with(
  slide,
  value = external_img("temp_age.png"),
  location = ph_location(left = 0.5, top = 1.3, width = 9, height = 5)
)
prs <- slide

# ================================
# SLIDE 5 : APPAREILS
# ================================

cat("📊 Slide 5 : Appareils...\n")

device_data <- data %>%
  group_by(Primary_Device) %>%
  summarise(
    Mean_Screen = mean(Avg_Daily_Screen_Time_hr),
    Count = n(),
    .groups = 'drop'
  ) %>%
  arrange(desc(Mean_Screen))

p_device <- ggplot(device_data, aes(x = reorder(Primary_Device, Mean_Screen), y = Mean_Screen, fill = Primary_Device)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = round(Mean_Screen, 2)), hjust = -0.2, fontface = "bold", size = 5) +
  coord_flip() +
  scale_y_continuous(limits = c(0, 5)) +
  labs(title = "Temps d'Écran par Appareil",
       x = "", y = "Heures/jour") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_text(size = 12),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

ggsave("temp_device.png", p_device, width = 10, height = 6, dpi = 150, bg = "white")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "📱 Utilisation des Appareils",
  location = ph_location_type(type = "title")
)
slide <- ph_with(
  slide,
  value = external_img("temp_device.png"),
  location = ph_location(left = 0.5, top = 1.3, width = 9, height = 5)
)
prs <- slide

# ================================
# SLIDE 6 : DÉPASSEMENT LIMITE
# ================================

cat("📊 Slide 6 : Dépassement limite...\n")

limit_data <- data %>%
  count(Exceeded_Recommended_Limit) %>%
  mutate(Label = ifelse(Exceeded_Recommended_Limit, "Dépasse", "Respecte"),
         Pct = round(n/sum(n)*100, 1))

p_limit <- ggplot(limit_data, aes(x = "", y = n, fill = Label)) +
  geom_bar(stat = "identity", width = 1, color = "white", size = 2) +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("Dépasse" = "#e74c3c", "Respecte" = "#27ae60")) +
  geom_text(aes(label = paste0(Pct, "%")), 
            position = position_stack(vjust = 0.5),
            size = 8, color = "white", fontweight = "bold") +
  labs(title = "🚨 85.8% DÉPASSENT LA LIMITE",
       fill = "") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14, color = "#e74c3c"),
        legend.position = "bottom",
        legend.text = element_text(size = 12))

ggsave("temp_limit.png", p_limit, width = 10, height = 6, dpi = 150, bg = "white")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "🚨 Dépassement Limite Recommandée",
  location = ph_location_type(type = "title")
)
slide <- ph_with(
  slide,
  value = external_img("temp_limit.png"),
  location = ph_location(left = 0.5, top = 1.3, width = 9, height = 5)
)
prs <- slide

# ================================
# SLIDE 7 : IMPACTS SANTÉ
# ================================

cat("📊 Slide 7 : Impacts santé...\n")

screen_cat_data <- data %>%
  group_by(Screen_Category) %>%
  summarise(
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Screen_Category, c("Faible (< 2h)", "Modéré (2-4h)", "Élevé (4-6h)", "Très élevé (> 6h)")))

p_health <- ggplot(screen_cat_data, aes(x = Screen_Category, y = Impact_Pct, fill = Screen_Category)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = paste0(Impact_Pct, "%")), vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("Faible (< 2h)" = "#27ae60", 
                               "Modéré (2-4h)" = "#f39c12",
                               "Élevé (4-6h)" = "#e74c3c",
                               "Très élevé (> 6h)" = "#c0392b")) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title = "💡 Impacts Santé par Temps d'Écran",
       subtitle = "À partir de 4h = 81% problèmes santé",
       x = "", y = "% Avec impacts") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_text(size = 11),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

ggsave("temp_health.png", p_health, width = 10, height = 6, dpi = 150, bg = "white")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "🏥 Impacts Santé par Temps d'Écran",
  location = ph_location_type(type = "title")
)
slide <- ph_with(
  slide,
  value = external_img("temp_health.png"),
  location = ph_location(left = 0.5, top = 1.3, width = 9, height = 5)
)
prs <- slide

# ================================
# SLIDE 8 : CONTENU ÉDUCATIF PROTECTEUR
# ================================

cat("📊 Slide 8 : Contenu éducatif...\n")

edu_data <- data %>%
  group_by(Education_Level) %>%
  summarise(
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Education_Level, c("Très peu", "Peu", "Équilibré", "Très éducatif")))

p_edu <- ggplot(edu_data, aes(x = Education_Level, y = Impact_Pct, fill = Education_Level)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = paste0(Impact_Pct, "%")), vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("Très peu" = "#e74c3c", 
                               "Peu" = "#f39c12",
                               "Équilibré" = "#3498db",
                               "Très éducatif" = "#27ae60")) +
  scale_y_continuous(limits = c(0, 80)) +
  labs(title = "📚 Contenu Éducatif = PROTECTEUR",
       subtitle = "Très éducatif : 52.6% impacts vs Très peu : 73.2%",
       x = "", y = "% Impacts santé") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_text(size = 11),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

ggsave("temp_edu.png", p_edu, width = 10, height = 6, dpi = 150, bg = "white")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "📚 Effet Protecteur du Contenu Éducatif",
  location = ph_location_type(type = "title")
)
slide <- ph_with(
  slide,
  value = external_img("temp_edu.png"),
  location = ph_location(left = 0.5, top = 1.3, width = 9, height = 5)
)
prs <- slide

# ================================
# SLIDE 9 : PROBLÈMES SANTÉ TOP
# ================================

cat("📊 Slide 9 : Problèmes santé...\n")

health_data <- data %>%
  filter(Has_Health_Impact == 1) %>%
  count(Health_Impacts) %>%
  arrange(desc(n)) %>%
  slice(1:7)

p_problems <- ggplot(health_data, aes(x = reorder(Health_Impacts, n), y = n)) +
  geom_bar(stat = "identity", fill = "#e74c3c", alpha = 0.8) +
  geom_text(aes(label = n), hjust = -0.2, fontface = "bold", size = 4) +
  coord_flip() +
  labs(title = "🏥 Principaux Problèmes de Santé",
       subtitle = "Manque de sommeil : 50.3%",
       x = "", y = "Nombre d'enfants") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
        axis.text = element_text(size = 10),
        panel.background = element_rect(fill = "white"),
        plot.background = element_rect(fill = "white"))

ggsave("temp_problems.png", p_problems, width = 10, height = 6, dpi = 150, bg = "white")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "🏥 Principaux Problèmes de Santé",
  location = ph_location_type(type = "title")
)
slide <- ph_with(
  slide,
  value = external_img("temp_problems.png"),
  location = ph_location(left = 0.5, top = 1.3, width = 9, height = 5)
)
prs <- slide

# ================================
# SLIDE 10 : RÉSULTATS CLÉS
# ================================

cat("📊 Slide 10 : Résultats clés...\n")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "🎯 Résultats Clés",
  location = ph_location_type(type = "title")
)

results <- paste(
  "🚨 RÉSULTATS CRITIQUES :",
  "  • 85.8% dépassent le temps écran recommandé",
  "  • 67.1% ont des impacts sur la santé",
  "  • 1,106 enfants en DANGER (>6h + impacts)",
  "  • Manque de sommeil = problème #1 (50.3%)",
  "",
  "✅ FACTEURS PROTECTEURS :",
  "  • Contenu éducatif réduit impacts de 20%",
  "  • <2h/jour = 0% impacts santé",
  "  • Ratio éducatif 0.5+ CRUCIAL",
  sep = "\n"
)

slide <- ph_with(
  slide,
  value = results,
  location = ph_location_type(type = "body")
)
prs <- slide

# ================================
# SLIDE 11 : RECOMMANDATIONS
# ================================

cat("📊 Slide 11 : Recommandations...\n")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "💡 Recommandations",
  location = ph_location_type(type = "title")
)

recommendations <- paste(
  "✅ POUR LES 11-13 ANS (groupe à risque) :",
  "  • Limiter à <2h/jour",
  "  • Augmenter ratio éducatif à 0.5+",
  "  • Pauses régulières yeux/sommeil",
  "",
  "✅ POUR CEUX AVEC >6h/JOUR (1,106 enfants) :",
  "  • Risque MAJEUR santé",
  "  • Intervention urgente recommandée",
  "",
  "✅ STRATÉGIE GLOBALE :",
  "  • Contenu éducatif plutôt que récréatif",
  "  • Limiter Laptop/Smartphone <2h",
  "  • Sensibilisation parents/enfants",
  sep = "\n"
)

slide <- ph_with(
  slide,
  value = recommendations,
  location = ph_location_type(type = "body")
)
prs <- slide

# ================================
# SLIDE 12 : CONCLUSION
# ================================

cat("📊 Slide 12 : Conclusion...\n")

slide <- add_slide(prs, layout = "Title and Content")
slide <- ph_with(
  slide,
  value = "🎓 Conclusion",
  location = ph_location_type(type = "title")
)

conclusion <- paste(
  "La majorité des enfants indiens (85.8%)",
  "dépassent les limites sûres de temps d'écran.",
  "",
  "Cependant, le contenu éducatif agit comme",
  "un FACTEUR DE PROTECTION significatif,",
  "réduisant les impacts santé de 20%.",
  "",
  "→ MISE EN ŒUVRE DE DIRECTIVES",
  "→ AMÉLIORATION QUALITÉ CONTENU",
  "→ RÉDUCTION IMPACTS SANTÉ",
  sep = "\n"
)

slide <- ph_with(
  slide,
  value = conclusion,
  location = ph_location_type(type = "body")
)
prs <- slide

# ================================
# SAUVEGARDER
# ================================

cat("\n💾 Sauvegarde...\n")
print(prs, target = "outputs/Screen_Time_Analysis.pptx")

cat("✅ Présentation créée : outputs/Screen_Time_Analysis.pptx\n\n")

# Nettoyer fichiers temp
file.remove(c("temp_age.png", "temp_device.png", "temp_limit.png", 
              "temp_health.png", "temp_edu.png", "temp_problems.png"))

cat("═══════════════════════════════════════════════════════════\n")
cat("✅ PRÉSENTATION POWERPOINT PRÊTE !\n")
cat("═══════════════════════════════════════════════════════════\n")