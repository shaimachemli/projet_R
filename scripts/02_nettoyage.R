# ================================
# 02 - DATA CLEANING
# ================================

library(tidyverse)

# Load raw data
data <- read.csv("data/screen_time_children.csv", stringsAsFactors = FALSE)

cat("\n🧹 NETTOYAGE DONNÉES...\n")
cat("Avant :", nrow(data), "lignes\n\n")

# ================================
# 1. REMOVE OUTLIERS
# ================================

cat("🔍 Suppression outliers :\n")

# Age (8-18)
before_age <- nrow(data)
data <- data %>% filter(Age >= 8 & Age <= 18)
cat("  Age :", before_age - nrow(data), "lignes supprimées\n")

# Screen time (0-24h)
before_screen <- nrow(data)
data <- data %>% filter(Avg_Daily_Screen_Time_hr >= 0 & Avg_Daily_Screen_Time_hr <= 24)
cat("  Screen time :", before_screen - nrow(data), "lignes supprimées\n")

# Ratio (0-1)
before_ratio <- nrow(data)
data <- data %>% filter(Educational_to_Recreational_Ratio >= 0 & Educational_to_Recreational_Ratio <= 1)
cat("  Ratio :", before_ratio - nrow(data), "lignes supprimées\n\n")

# ================================
# 2. FIX DATA TYPES
# ================================

cat("📝 Correction types données :\n")

# Convert Exceeded_Recommended_Limit to logical
data <- data %>%
  mutate(Exceeded_Recommended_Limit = as.logical(
    ifelse(Exceeded_Recommended_Limit == "True", TRUE, FALSE)
  ))

cat("  ✅ Exceeded_Recommended_Limit → logical\n")

# Trim spaces
data <- data %>%
  mutate(
    Gender = str_trim(Gender),
    Primary_Device = str_trim(Primary_Device),
    Urban_or_Rural = str_trim(Urban_or_Rural),
    Health_Impacts = str_trim(Health_Impacts)
  )

cat("  ✅ Espaces supprimés\n\n")

# ================================
# 3. CREATE NEW VARIABLES
# ================================

cat("📐 Création nouvelles variables :\n")

data <- data %>%
  mutate(
    # Age group
    Age_Group = case_when(
      Age >= 8 & Age <= 10 ~ "8-10",
      Age >= 11 & Age <= 13 ~ "11-13",
      Age >= 14 & Age <= 16 ~ "14-16",
      Age >= 17 & Age <= 18 ~ "17-18"
    ),
    
    # Screen time category
    Screen_Category = case_when(
      Avg_Daily_Screen_Time_hr < 2 ~ "Faible (< 2h)",
      Avg_Daily_Screen_Time_hr >= 2 & Avg_Daily_Screen_Time_hr < 4 ~ "Modéré (2-4h)",
      Avg_Daily_Screen_Time_hr >= 4 & Avg_Daily_Screen_Time_hr < 6 ~ "Élevé (4-6h)",
      Avg_Daily_Screen_Time_hr >= 6 ~ "Très élevé (> 6h)"
    ),
    
    # Education level (ratio)
    Education_Level = case_when(
      Educational_to_Recreational_Ratio < 0.35 ~ "Très peu",
      Educational_to_Recreational_Ratio >= 0.35 & Educational_to_Recreational_Ratio < 0.42 ~ "Peu",
      Educational_to_Recreational_Ratio >= 0.42 & Educational_to_Recreational_Ratio < 0.50 ~ "Équilibré",
      Educational_to_Recreational_Ratio >= 0.50 ~ "Très éducatif"
    ),
    
    # Binary: has health impact
    Has_Health_Impact = ifelse(Health_Impacts == "None", 0, 1)
  )

cat("  ✅ Age_Group créé\n")
cat("  ✅ Screen_Category créé\n")
cat("  ✅ Education_Level créé\n")
cat("  ✅ Has_Health_Impact créé\n\n")

# ================================
# 4. CHECK DUPLICATES
# ================================

cat("🔄 Vérification doublons :\n")
dup <- sum(duplicated(data))
cat("  Doublons trouvés :", dup, "\n")

if(dup > 0) {
  data <- data %>% distinct()
  cat("  ✅ Doublons supprimés\n\n")
} else {
  cat("  ✅ Aucun doublon\n\n")
}

# ================================
# 5. CHECK MISSING VALUES
# ================================

cat("⚠️ Valeurs manquantes :\n")
missing <- colSums(is.na(data))
cat("  Total valeurs manquantes :", sum(missing), "\n\n")

# ================================
# 6. SAVE CLEANED DATA
# ================================

cat("💾 Sauvegarde :\n")
write.csv(data, "data/screen_time_clean.csv", row.names = FALSE)
cat("  ✅ Données nettoyées → data/screen_time_clean.csv\n\n")

# ================================
# 7. FINAL SUMMARY
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("✅ NETTOYAGE TERMINÉ\n")
cat("═══════════════════════════════════════════════════════════\n\n")

cat("📊 Résumé final :\n")
cat("  Lignes :", nrow(data), "\n")
cat("  Colonnes :", ncol(data), "\n")
cat("  Âge moyen :", round(mean(data$Age), 1), "ans\n")
cat("  Temps écran moyen :", round(mean(data$Avg_Daily_Screen_Time_hr), 2), "h/jour\n")
cat("  % dépassant limite :", round(sum(data$Exceeded_Recommended_Limit)/nrow(data)*100, 1), "%\n")
cat("  % avec impacts santé :", round(sum(data$Has_Health_Impact == 1)/nrow(data)*100, 1), "%\n\n")

