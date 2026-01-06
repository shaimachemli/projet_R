# ================================
# 05 - VISUALIZATIONS
# ================================

library(tidyverse)
library(ggplot2)

# Load cleaned data
data <- read.csv("data/screen_time_clean.csv", stringsAsFactors = FALSE)

cat("\n📊 CRÉATION VISUALISATIONS...\n\n")

# ================================
# 1. DISTRIBUTION TEMPS ÉCRAN
# ================================

cat("📈 Chart 1 : Distribution temps écran...\n")

p1 <- ggplot(data, aes(x = Avg_Daily_Screen_Time_hr)) +
  geom_histogram(bins = 30, fill = "#667eea", alpha = 0.7, color = "white") +
  geom_vline(aes(xintercept = mean(Avg_Daily_Screen_Time_hr)), 
             color = "#e74c3c", size = 1.2, linetype = "dashed") +
  labs(title = "Distribution du Temps d'Écran",
       subtitle = paste0("Moyen : ", round(mean(data$Avg_Daily_Screen_Time_hr), 2), "h/jour"),
       x = "Heures/jour", y = "Nombre d'enfants") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14))

ggsave("outputs/plots/01_screen_time_distribution.png", p1, width = 8, height = 6, dpi = 300)
cat("  ✅ 01_screen_time_distribution.png\n")

# ================================
# 2. TEMPS ÉCRAN PAR GROUPE D'ÂGE
# ================================

cat("📈 Chart 2 : Temps écran par groupe d'âge...\n")

age_data <- data %>%
  group_by(Age_Group) %>%
  summarise(
    Mean_Screen = mean(Avg_Daily_Screen_Time_hr),
    .groups = 'drop'
  )

p2 <- ggplot(age_data, aes(x = Age_Group, y = Mean_Screen, fill = Age_Group)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = round(Mean_Screen, 2)), vjust = -0.5, fontface = "bold") +
  scale_fill_viridis_d() +
  labs(title = "Temps d'Écran par Groupe d'Âge",
       subtitle = "Les 11-13 ans ont plus d'écran",
       x = "Groupe d'âge", y = "Heures/jour") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave("outputs/plots/02_screen_time_by_age.png", p2, width = 8, height = 6, dpi = 300)
cat("  ✅ 02_screen_time_by_age.png\n")

# ================================
# 3. DÉPASSEMENT LIMITE
# ================================

cat("📈 Chart 3 : Dépassement limite...\n")

limit_data <- data %>%
  count(Exceeded_Recommended_Limit) %>%
  mutate(Label = ifelse(Exceeded_Recommended_Limit, "Dépasse\nlimite", "Respecte\nlimite"),
         Pct = round(n/sum(n)*100, 1))

p3 <- ggplot(limit_data, aes(x = "", y = n, fill = Label)) +
  geom_bar(stat = "identity", width = 1, color = "white", size = 2) +
  coord_polar("y", start = 0) +
  scale_fill_manual(values = c("Dépasse\nlimite" = "#e74c3c", "Respecte\nlimite" = "#27ae60")) +
  geom_text(aes(label = paste0(Pct, "%")), 
            position = position_stack(vjust = 0.5),
            size = 6, color = "white", fontweight = "bold") +
  labs(title = "🚨 85.8% DÉPASSENT LA LIMITE !",
       fill = "") +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 14, color = "#e74c3c"),
        legend.position = "bottom")

ggsave("outputs/plots/03_exceeded_limit.png", p3, width = 8, height = 6, dpi = 300)
cat("  ✅ 03_exceeded_limit.png\n")

# ================================
# 4. TEMPS ÉCRAN PAR APPAREIL
# ================================

cat("📈 Chart 4 : Temps écran par appareil...\n")

device_data <- data %>%
  group_by(Primary_Device) %>%
  summarise(
    Mean_Screen = mean(Avg_Daily_Screen_Time_hr),
    Count = n(),
    .groups = 'drop'
  ) %>%
  arrange(desc(Mean_Screen))

p4 <- ggplot(device_data, aes(x = reorder(Primary_Device, Mean_Screen), y = Mean_Screen, fill = Primary_Device)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = round(Mean_Screen, 2)), hjust = -0.2, fontface = "bold") +
  coord_flip() +
  scale_y_continuous(limits = c(0, 5)) +
  labs(title = "Temps d'Écran par Appareil",
       subtitle = "Laptop = le plus chronophage",
       x = "", y = "Heures/jour") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"))

ggsave("outputs/plots/04_screen_time_by_device.png", p4, width = 8, height = 6, dpi = 300)
cat("  ✅ 04_screen_time_by_device.png\n")

# ================================
# 5. IMPACTS SANTÉ PAR CATÉGORIE TEMPS ÉCRAN
# ================================

cat("📈 Chart 5 : Impacts santé par temps écran...\n")

screen_cat_data <- data %>%
  group_by(Screen_Category) %>%
  summarise(
    Total = n(),
    With_Impact = sum(Has_Health_Impact),
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Screen_Category, c("Faible (< 2h)", "Modéré (2-4h)", "Élevé (4-6h)", "Très élevé (> 6h)")))

p5 <- ggplot(screen_cat_data, aes(x = Screen_Category, y = Impact_Pct, fill = Screen_Category)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = paste0(Impact_Pct, "%")), vjust = -0.5, fontface = "bold") +
  scale_fill_manual(values = c("Faible (< 2h)" = "#27ae60", 
                               "Modéré (2-4h)" = "#f39c12",
                               "Élevé (4-6h)" = "#e74c3c",
                               "Très élevé (> 6h)" = "#c0392b")) +
  scale_y_continuous(limits = c(0, 100)) +
  labs(title = "💡 Impacts Santé par Catégorie Temps Écran",
       subtitle = "À partir de 4h = 81% ont des problèmes",
       x = "", y = "% Avec impacts santé") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("outputs/plots/05_health_impact_by_screen_time.png", p5, width = 8, height = 6, dpi = 300)
cat("  ✅ 05_health_impact_by_screen_time.png\n")

# ================================
# 6. RATIO ÉDUCATIF PROTECTEUR
# ================================

cat("📈 Chart 6 : Ratio éducatif...\n")

edu_data <- data %>%
  group_by(Education_Level) %>%
  summarise(
    Impact_Pct = round(sum(Has_Health_Impact)/n()*100, 1),
    .groups = 'drop'
  ) %>%
  arrange(match(Education_Level, c("Très peu", "Peu", "Équilibré", "Très éducatif")))

p6 <- ggplot(edu_data, aes(x = Education_Level, y = Impact_Pct, fill = Education_Level)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = paste0(Impact_Pct, "%")), vjust = -0.5, fontface = "bold") +
  scale_fill_manual(values = c("Très peu" = "#e74c3c", 
                               "Peu" = "#f39c12",
                               "Équilibré" = "#3498db",
                               "Très éducatif" = "#27ae60")) +
  scale_y_continuous(limits = c(0, 80)) +
  labs(title = "📚 Ratio Éducatif = PROTECTEUR !",
       subtitle = "Très éducatif : 52.6% impacts vs Très peu : 73.2%",
       x = "", y = "% Avec impacts santé") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("outputs/plots/06_education_level_protective.png", p6, width = 8, height = 6, dpi = 300)
cat("  ✅ 06_education_level_protective.png\n")

# ================================
# 7. PROBLÈMES SANTÉ TOP 5
# ================================

cat("📈 Chart 7 : Problèmes santé...\n")

health_data <- data %>%
  filter(Has_Health_Impact == 1) %>%
  count(Health_Impacts) %>%
  arrange(desc(n)) %>%
  slice(1:7)

p7 <- ggplot(health_data, aes(x = reorder(Health_Impacts, n), y = n, fill = Health_Impacts)) +
  geom_bar(stat = "identity", alpha = 0.8) +
  geom_text(aes(label = n), hjust = -0.2, fontface = "bold", size = 3.5) +
  coord_flip() +
  labs(title = "🏥 Top Problèmes Santé",
       subtitle = "Poor Sleep : 50.3% des enfants !",
       x = "", y = "Nombre d'enfants") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold"),
        axis.text = element_text(size = 9))

ggsave("outputs/plots/07_health_problems_top.png", p7, width = 8, height = 6, dpi = 300)
cat("  ✅ 07_health_problems_top.png\n")

# ================================
# 8. PROFILS À RISQUE vs SAINS
# ================================

cat("📈 Chart 8 : Profils à risque...\n")

profile_data <- tibble(
  Profile = c("🚨 DANGER\n(> 6h + impacts)", "✅ SAIN\n(< 2h + 0 impacts)"),
  Count = c(1106, 792),
  Pct = c(11.44, 8.19)
)

p8 <- ggplot(profile_data, aes(x = Profile, y = Count, fill = Profile)) +
  geom_bar(stat = "identity", alpha = 0.8, width = 0.6) +
  geom_text(aes(label = paste0(Count, "\n(", Pct, "%)")), 
            vjust = -0.5, fontface = "bold", size = 5) +
  scale_fill_manual(values = c("🚨 DANGER\n(> 6h + impacts)" = "#e74c3c", 
                               "✅ SAIN\n(< 2h + 0 impacts)" = "#27ae60")) +
  scale_y_continuous(limits = c(0, 1300)) +
  labs(title = "⚠️ PROFILS À RISQUE vs SAINS",
       x = "", y = "Nombre d'enfants") +
  theme_minimal() +
  theme(legend.position = "none",
        plot.title = element_text(hjust = 0.5, face = "bold", size = 14, color = "#e74c3c"),
        axis.text.x = element_text(size = 11, face = "bold"))

ggsave("outputs/plots/08_risk_profiles.png", p8, width = 8, height = 6, dpi = 300)
cat("  ✅ 08_risk_profiles.png\n")

