# ================================
# 03 - DESCRIPTIVE STATISTICS
# ================================

library(tidyverse)

# Load cleaned data
data <- read.csv("data/screen_time_clean.csv", stringsAsFactors = FALSE)

cat("\n📊 ANALYSES STATISTIQUES DESCRIPTIVES...\n\n")

# ================================
# 1. GLOBAL STATISTICS
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🎯 STATISTIQUES GLOBALES\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat("Total enfants :", nrow(data), "\n")
cat("Âge moyen :", round(mean(data$Age), 1), "ans\n")
cat("Temps écran moyen :", round(mean(data$Avg_Daily_Screen_Time_hr), 2), "h/jour\n")
cat("Ratio éducatif moyen :", round(mean(data$Educational_to_Recreational_Ratio), 3), "\n\n")

# ================================
# 2. DISTRIBUTION BY AGE GROUP
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("👶 DISTRIBUTION PAR GROUPE D'ÂGE\n")
cat("═══════════════════════════════════════════════════════════\n\n")

age_group_stats <- data %>%
  group_by(Age_Group) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3),
    Exceeded_Pct = round(sum(Exceeded_Recommended_Limit)/n()*100, 1),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Age_Group, c("8-10", "11-13", "14-16", "17-18")))

print(age_group_stats)
cat("\n💡 Les plus jeunes (8-10) vs plus vieux (17-18) ?\n\n")

# ================================
# 3. DISTRIBUTION BY GENDER
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("👥 DISTRIBUTION PAR SEXE\n")
cat("═══════════════════════════════════════════════════════════\n\n")

gender_stats <- data %>%
  group_by(Gender) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3),
    Exceeded_Pct = round(sum(Exceeded_Recommended_Limit)/n()*100, 1),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  )

print(gender_stats)
cat("\n💡 Différences entre garçons et filles ?\n\n")

# ================================
# 4. DISTRIBUTION BY DEVICE
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("📱 DISTRIBUTION PAR APPAREIL\n")
cat("═══════════════════════════════════════════════════════════\n\n")

device_stats <- data %>%
  group_by(Primary_Device) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3),
    Exceeded_Pct = round(sum(Exceeded_Recommended_Limit)/n()*100, 1),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(desc(Count))

print(device_stats)
cat("\n💡 Quel appareil = plus de temps écran ?\n\n")

# ================================
# 5. URBAN vs RURAL
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🏙️ URBAIN vs RURAL\n")
cat("═══════════════════════════════════════════════════════════\n\n")

location_stats <- data %>%
  group_by(Urban_or_Rural) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3),
    Exceeded_Pct = round(sum(Exceeded_Recommended_Limit)/n()*100, 1),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  )

print(location_stats)
cat("\n💡 Différences entre villes et campagnes ?\n\n")

# ================================
# 6. SCREEN TIME CATEGORIES
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("⏰ CATÉGORIES TEMPS D'ÉCRAN\n")
cat("═══════════════════════════════════════════════════════════\n\n")

screen_cat_stats <- data %>%
  group_by(Screen_Category) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Screen_Category, c("Faible (< 2h)", "Modéré (2-4h)", "Élevé (4-6h)", "Très élevé (> 6h)")))

print(screen_cat_stats)
cat("\n💡 Plus d'heures = plus d'impacts santé ?\n\n")

# ================================
# 7. EDUCATION LEVEL
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("📚 NIVEAUX ÉDUCATION (RATIO)\n")
cat("═══════════════════════════════════════════════════════════\n\n")

edu_stats <- data %>%
  group_by(Education_Level) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Education_Level, c("Très peu", "Peu", "Équilibré", "Très éducatif")))

print(edu_stats)
cat("\n💡 Plus éducatif = moins d'impacts santé ?\n\n")

# ================================
# 8. HEALTH IMPACTS
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🏥 IMPACTS SANTÉ (TOP 10)\n")
cat("═══════════════════════════════════════════════════════════\n\n")

health_stats <- data %>%
  count(Health_Impacts) %>%
  mutate(Pct = round(n/sum(n)*100, 2)) %>%
  arrange(desc(n)) %>%
  slice(1:10)

print(health_stats)
cat("\n💡 'Poor Sleep' est le problème #1 ?\n\n")

# ================================
# 9. EXCEEDED LIMIT ANALYSIS
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🚨 DÉPASSEMENT LIMITE RECOMMANDÉE\n")
cat("═══════════════════════════════════════════════════════════\n\n")

exceeded_stats <- data %>%
  group_by(Exceeded_Recommended_Limit) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 1),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  )

print(exceeded_stats)
cat("\n💡 85.8% des enfants dépassent la limite !\n\n")

# ================================
# 10. CORRELATIONS
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🔗 CORRÉLATIONS NUMÉRIQUES\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cor_data <- data %>%
  select(Age, Avg_Daily_Screen_Time_hr, Educational_to_Recreational_Ratio, Has_Health_Impact) %>%
  cor(use = "complete.obs")

print(round(cor_data, 3))
cat("\n💡 Temps écran vs impacts santé ? Age vs temps écran ?\n\n")

