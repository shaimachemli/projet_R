# ================================
# 04 - DEEP ANALYSIS
# ================================

library(tidyverse)

# Load cleaned data
data <- read.csv("data/screen_time_clean.csv", stringsAsFactors = FALSE)

cat("\n🔍 ANALYSES APPROFONDIES...\n\n")

# ================================
# 1. AGE GROUP x DEVICE ANALYSIS
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("👶 + 📱 GROUPE D'ÂGE x APPAREIL\n")
cat("═══════════════════════════════════════════════════════════\n\n")

age_device <- data %>%
  group_by(Age_Group, Primary_Device) %>%
  summarise(
    Count = n(),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Health_Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  pivot_wider(
    names_from = Primary_Device,
    values_from = Mean_Screen_Time,
    values_fill = NA
  )

print(age_device)
cat("\n💡 Quel appareil pour quel âge ?\n\n")

# ================================
# 2. SCREEN TIME IMPACT ON HEALTH
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("⏰ + 🏥 TEMPS ÉCRAN x IMPACTS SANTÉ\n")
cat("═══════════════════════════════════════════════════════════\n\n")

screen_health <- data %>%
  group_by(Screen_Category) %>%
  summarise(
    Total = n(),
    With_Impact = sum(Has_Health_Impact),
    Without_Impact = sum(Has_Health_Impact == 0),
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Screen_Category, c("Faible (< 2h)", "Modéré (2-4h)", "Élevé (4-6h)", "Très élevé (> 6h)")))

print(screen_health)
cat("\n💡 À partir de combien d'heures = impacts santé ?\n\n")

# ================================
# 3. DEVICE x HEALTH IMPACT
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("📱 + 🏥 APPAREIL x IMPACTS SANTÉ\n")
cat("═══════════════════════════════════════════════════════════\n\n")

device_health <- data %>%
  group_by(Primary_Device) %>%
  summarise(
    Total = n(),
    With_Impact = sum(Has_Health_Impact),
    Without_Impact = sum(Has_Health_Impact == 0),
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    .groups = 'drop'
  ) %>%
  arrange(desc(Impact_Pct))

print(device_health)
cat("\n💡 Quel appareil cause le plus de problèmes ?\n\n")

# ================================
# 4. EDUCATION LEVEL x HEALTH
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("📚 + 🏥 ÉDUCATION x IMPACTS SANTÉ\n")
cat("═══════════════════════════════════════════════════════════\n\n")

edu_health <- data %>%
  group_by(Education_Level) %>%
  summarise(
    Total = n(),
    With_Impact = sum(Has_Health_Impact),
    Without_Impact = sum(Has_Health_Impact == 0),
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3),
    .groups = 'drop'
  ) %>%
  arrange(match(Education_Level, c("Très peu", "Peu", "Équilibré", "Très éducatif")))

print(edu_health)
cat("\n💡 Ratio éducatif = protecteur ?\n\n")

# ================================
# 5. LOCATION x DEVICE
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🏙️ + 📱 URBAIN/RURAL x APPAREIL\n")
cat("═══════════════════════════════════════════════════════════\n\n")

location_device <- data %>%
  group_by(Urban_or_Rural, Primary_Device) %>%
  summarise(
    Count = n(),
    Pct = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    .groups = 'drop'
  ) %>%
  arrange(Urban_or_Rural, desc(Count))

print(location_device)
cat("\n💡 Différences d'appareils urbain vs rural ?\n\n")

# ================================
# 6. HIGH RISK PROFILES
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🚨 PROFILS À RISQUE (Temps écran > 6h + Impacts santé)\n")
cat("═══════════════════════════════════════════════════════════\n\n")

high_risk <- data %>%
  filter(Avg_Daily_Screen_Time_hr > 6, Has_Health_Impact == 1) %>%
  summarise(
    Count = n(),
    Pct_of_Total = round(n()/nrow(data)*100, 2),
    Avg_Age = round(mean(Age), 1),
    Pct_Male = round(sum(Gender == "Male")/n()*100, 1),
    Top_Device = names(table(Primary_Device))[which.max(table(Primary_Device))],
    Top_Health_Issue = names(table(Health_Impacts))[which.max(table(Health_Impacts))]
  )

print(high_risk)
cat("\n💡 ", high_risk$Count, "enfants en DANGER !\n\n")

# ================================
# 7. LOW RISK PROFILES
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("✅ PROFILS SAINS (Temps écran < 2h + Aucun impact)\n")
cat("═══════════════════════════════════════════════════════════\n\n")

low_risk <- data %>%
  filter(Avg_Daily_Screen_Time_hr < 2, Has_Health_Impact == 0) %>%
  summarise(
    Count = n(),
    Pct_of_Total = round(n()/nrow(data)*100, 2),
    Avg_Age = round(mean(Age), 1),
    Pct_Male = round(sum(Gender == "Male")/n()*100, 1),
    Top_Device = names(table(Primary_Device))[which.max(table(Primary_Device))],
    Mean_Ratio = round(mean(Educational_to_Recreational_Ratio), 3)
  )

print(low_risk)
cat("\n💡 ", low_risk$Count, "enfants en bonne santé !\n\n")

# ================================
# 8. SPECIFIC HEALTH ISSUES
# ================================

cat("═══════════════════════════════════════════════════════════\n")
cat("🏥 PROBLÈMES SANTÉ SPÉCIFIQUES\n")
cat("═══════════════════════════════════════════════════════════\n\n")

# Poor Sleep analysis
poor_sleep <- data %>%
  filter(grepl("Poor Sleep", Health_Impacts)) %>%
  summarise(
    Count = n(),
    Pct_of_Total = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Age = round(mean(Age), 1)
  )

cat("Poor Sleep :\n")
print(poor_sleep)

# Eye Strain analysis
eye_strain <- data %>%
  filter(grepl("Eye Strain", Health_Impacts)) %>%
  summarise(
    Count = n(),
    Pct_of_Total = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Age = round(mean(Age), 1)
  )

cat("\nEye Strain :\n")
print(eye_strain)

# Anxiety analysis
anxiety <- data %>%
  filter(grepl("Anxiety", Health_Impacts)) %>%
  summarise(
    Count = n(),
    Pct_of_Total = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Age = round(mean(Age), 1)
  )

cat("\nAnxiety :\n")
print(anxiety)

# Obesity Risk analysis
obesity <- data %>%
  filter(grepl("Obesity Risk", Health_Impacts)) %>%
  summarise(
    Count = n(),
    Pct_of_Total = round(n()/nrow(data)*100, 2),
    Mean_Screen_Time = round(mean(Avg_Daily_Screen_Time_hr), 2),
    Mean_Age = round(mean(Age), 1)
  )

cat("\nObesity Risk :\n")
print(obesity)
cat("\n")


