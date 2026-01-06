# ================================
# 04 - DEEP ANALYSIS
# ================================

library(tidyverse)

# Load cleaned data
data <- read.csv("data/screen_time_clean.csv", stringsAsFactors = FALSE)



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


# ================================
# 9. TESTS D'HYPOTHESES SIMPLES
# ================================
# ================================
# 9. TESTS D'HYPOTHESES SIMPLES
# ================================

cat("\n🔬 TESTS D'HYPOTHESES\n")

# ---- Test 1 : Temps écran garçons vs filles ----
# Objectif : comparer le temps écran moyen entre garçons et filles
# H0 : moyenne filles = moyenne garçons
# H1 : moyenne filles != moyenne garçons
t_test_gender <- t.test(
  Avg_Daily_Screen_Time_hr ~ Gender, # variable continue ~ variable catégorielle
  data = data,
  var.equal = TRUE # on suppose variances égales pour simplifier
)
cat("\n1️⃣ t-test : Temps écran garçons vs filles\n")
print(t_test_gender)

# Interprétation simple
if(t_test_gender$p.value < 0.05){
  cat("=> Différence significative de temps écran entre garçons et filles\n")
} else {
  cat("=> Pas de différence significative\n")
}
# COMMENTAIRE : ici p-value = 0.278 > 0.05 donc pas de différence
# Les garçons et filles passent en moyenne le même temps devant les écrans (~4,35h vs 4,39h)

# ---- Test 2 : Appareil vs Dépassement limite ----
# Objectif : voir si le type d'appareil est lié au dépassement des limites
# H0 : appareil et dépassement indépendants
# H1 : appareil et dépassement liés
device_exceed <- table(data$Primary_Device, data$Exceeded_Recommended_Limit) # table de contingence
chi2_device <- chisq.test(device_exceed) # test chi-2 d'indépendance
cat("\n2️⃣ Test chi-2 : Appareil x Dépassement limite\n")
print(chi2_device)

if(chi2_device$p.value < 0.05){
  cat("=> Dépendance significative : type d'appareil lié au dépassement\n")
} else {
  cat("=> Pas de lien significatif\n")
}
# COMMENTAIRE : ici p-value < 0.05 donc certains appareils favorisent le dépassement
# On peut regarder la table pour savoir lequel (ex: tablettes, smartphones)

# ---- Test 3 : Ratio éducatif vs Impact santé ----
# Objectif : comparer le ratio éducatif moyen chez enfants avec ou sans impact santé
# H0 : moyenne ratio éducatif sans impact = moyenne ratio éducatif avec impact
# H1 : moyenne ratio éducatif diffère
t_test_ratio <- t.test(
  Educational_to_Recreational_Ratio ~ Has_Health_Impact,
  data = data,
  var.equal = FALSE # Welch test pour variances potentiellement différentes
)
cat("\n3️⃣ t-test : Ratio éducatif x Impact santé\n")
print(t_test_ratio)

if(t_test_ratio$p.value < 0.05){
  cat("=> Différence significative : le ratio éducatif semble influencer la santé\n")
} else {
  cat("=> Pas de différence significative\n")
}
# COMMENTAIRE : ici p-value < 2.2e-16 donc le ratio éducatif est significativement plus élevé
# chez les enfants sans impact santé. Plus éducatif → moins de problèmes de santé


