# ================================
# DASHBOARD INTERACTIF - SHINY
# ================================

library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(DT)

# Load data
data <- read.csv("data/screen_time_clean.csv", stringsAsFactors = FALSE)

# UI
ui <- dashboardPage(
  
  # HEADER
  dashboardHeader(
    title = "📱 Screen Time Children Dashboard",
    titleWidth = 350,
    tags$li(class = "dropdown", tags$span("Data: 9,668 enfants | 2024"))
  ),
  
  # SIDEBAR
  dashboardSidebar(
    width = 250,
    sidebarMenu(
      menuItem("🏠 Accueil", tabName = "home", icon = icon("home")),
      menuItem("📊 Aperçu", tabName = "overview", icon = icon("chart-bar")),
      menuItem("📱 Appareils", tabName = "devices", icon = icon("mobile")),
      menuItem("😴 Impacts Santé", tabName = "health", icon = icon("heart")),
      menuItem("👥 Démographie", tabName = "demographics", icon = icon("users")),
      menuItem("📈 Analyses", tabName = "analysis", icon = icon("line-chart")),
      menuItem("📋 Données", tabName = "data", icon = icon("table")),
      
      hr(),
      
      h4("🎯 FILTRES GLOBAUX", style = "color: white; padding: 15px;"),
      
      # Filtre Age Group
      selectInput(
        "age_filter",
        "Groupe d'âge:",
        choices = c("Tous", unique(data$Age_Group)),
        selected = "Tous"
      ),
      
      # Filtre Gender
      selectInput(
        "gender_filter",
        "Sexe:",
        choices = c("Tous", unique(data$Gender)),
        selected = "Tous"
      ),
      
      # Filtre Device
      selectInput(
        "device_filter",
        "Appareil:",
        choices = c("Tous", unique(data$Primary_Device)),
        selected = "Tous"
      ),
      
      # Filtre Location
      selectInput(
        "location_filter",
        "Localisation:",
        choices = c("Tous", unique(data$Urban_or_Rural)),
        selected = "Tous"
      ),
      
      # Filtre Health Impact
      selectInput(
        "health_filter",
        "Impacts santé:",
        choices = c("Tous", "Avec impacts", "Sans impacts"),
        selected = "Tous"
      ),
      
      hr(),
      
      # Reset button
      actionButton("reset", "🔄 Réinitialiser Filtres", 
                   width = "100%",
                   style = "background-color: #E74C3C; color: white;")
    )
  ),
  
  # BODY
  dashboardBody(
    
    # CSS personnalisé
    tags$head(
      tags$style(HTML("
        .box-title { font-weight: bold; font-size: 16px; }
        .stat-box { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .info-box { border-left: 5px solid #3498DB; }
      "))
    ),
    
    # ONGLET 1 - ACCUEIL
    tabItems(
      tabItem(tabName = "home",
        fluidRow(
          column(12,
            h1("🎯 Bienvenue au Dashboard Screen Time", style = "color: #2C3E50;"),
            p("Analyse interactive de l'utilisation des écrans chez les enfants",
              style = "font-size: 16px; color: #7F8C8D;"),
            hr()
          )
        ),
        fluidRow(
          infoBox("👶 Enfants", textOutput("total_children"), 
                  icon = icon("child"), color = "blue", width = 3),
          infoBox("⏰ Temps moyen", textOutput("avg_screen_time"), 
                  icon = icon("clock"), color = "yellow", width = 3),
          infoBox("🚨 En danger", textOutput("at_risk"), 
                  icon = icon("warning"), color = "red", width = 3),
          infoBox("✅ Sains", textOutput("safe_children"), 
                  icon = icon("check"), color = "green", width = 3)
        ),
        fluidRow(
          box(
            title = "📌 Informations clés",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            p(HTML("
              <ul style='font-size: 16px; line-height: 1.8;'>
                <li><strong>85.8%</strong> des enfants dépassent la limite recommandée</li>
                <li><strong>67.1%</strong> présentent des impacts santé</li>
                <li><strong>#1 Problème:</strong> Poor Sleep (50.29%)</li>
                <li><strong>#2 Problème:</strong> Eye Strain (24.63%)</li>
                <li><strong>Appareil le plus utilisé:</strong> Laptop (4.46h/jour)</li>
                <li><strong>Facteur protecteur:</strong> Ratio éducatif élevé</li>
              </ul>
            "))
          )
        )
      ),
      
      # ONGLET 2 - APERÇU
      tabItem(tabName = "overview",
        fluidRow(
          box(
            title = "📊 Distribution Temps Écran",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_distribution", height = "400px")
          ),
          box(
            title = "🎯 Statut Enfants",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_risk_status", height = "400px")
          )
        ),
        fluidRow(
          box(
            title = "⏰ Temps Écran par Catégorie",
            status = "warning",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("plot_screen_category", height = "400px")
          )
        )
      ),
      
      # ONGLET 3 - APPAREILS
      tabItem(tabName = "devices",
        fluidRow(
          box(
            title = "📱 Temps Écran par Appareil",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_devices", height = "400px")
          ),
          box(
            title = "🔥 % Impacts par Appareil",
            status = "danger",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_device_impact", height = "400px")
          )
        ),
        fluidRow(
          box(
            title = "📊 Tableau: Statistiques par Appareil",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            DTOutput("table_devices")
          )
        )
      ),
      
      # ONGLET 4 - IMPACTS SANTÉ
      tabItem(tabName = "health",
        fluidRow(
          box(
            title = "😴 Types d'Impacts Santé",
            status = "danger",
            solidHeader = TRUE,
            width = 8,
            plotlyOutput("plot_health_impacts", height = "500px")
          ),
          box(
            title = "📊 Résumé Santé",
            status = "warning",
            solidHeader = TRUE,
            width = 4,
            valueBoxOutput("vb_with_impact", width = 12),
            valueBoxOutput("vb_without_impact", width = 12),
            valueBoxOutput("vb_avg_ratio", width = 12)
          )
        )
      ),
      
      # ONGLET 5 - DÉMOGRAPHIE
      tabItem(tabName = "demographics",
        fluidRow(
          box(
            title = "👶 Temps Écran par Groupe d'Âge",
            status = "primary",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_age", height = "400px")
          ),
          box(
            title = "👥 Temps Écran par Sexe",
            status = "info",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_gender", height = "400px")
          )
        ),
        fluidRow(
          box(
            title = "🏙️ Urbain vs Rural",
            status = "success",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_location", height = "400px")
          ),
          box(
            title = "📚 Ratio Éducatif (Facteur Protecteur)",
            status = "warning",
            solidHeader = TRUE,
            width = 6,
            plotlyOutput("plot_ratio", height = "400px")
          )
        )
      ),
      
      # ONGLET 6 - ANALYSES
      tabItem(tabName = "analysis",
        fluidRow(
          box(
            title = "📈 Corrélation: Temps Écran × Impacts Santé",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            plotlyOutput("plot_correlation", height = "500px")
          )
        ),
        fluidRow(
          box(
            title = "📊 Matrice Temps Écran × Impacts",
            status = "info",
            solidHeader = TRUE,
            width = 12,
            DTOutput("table_analysis")
          )
        )
      ),
      
      # ONGLET 7 - DONNÉES
      tabItem(tabName = "data",
        fluidRow(
          box(
            title = "📋 Données Complètes (Filtrées)",
            status = "primary",
            solidHeader = TRUE,
            width = 12,
            DTOutput("table_full_data"),
            downloadButton("download_data", "📥 Télécharger CSV")
          )
        )
      )
    )
  )
)

# SERVER
server <- function(input, output, session) {
  
  # REACTIVE DATA (with filters)
  filtered_data <- reactive({
    d <- data
    
    if (input$age_filter != "Tous") {
      d <- d %>% filter(Age_Group == input$age_filter)
    }
    if (input$gender_filter != "Tous") {
      d <- d %>% filter(Gender == input$gender_filter)
    }
    if (input$device_filter != "Tous") {
      d <- d %>% filter(Primary_Device == input$device_filter)
    }
    if (input$location_filter != "Tous") {
      d <- d %>% filter(Urban_or_Rural == input$location_filter)
    }
    if (input$health_filter == "Avec impacts") {
      d <- d %>% filter(Has_Health_Impact == TRUE)
    } else if (input$health_filter == "Sans impacts") {
      d <- d %>% filter(Has_Health_Impact == FALSE)
    }
    
    d
  })
  
  # RESET BUTTON
  observeEvent(input$reset, {
    updateSelectInput(session, "age_filter", selected = "Tous")
    updateSelectInput(session, "gender_filter", selected = "Tous")
    updateSelectInput(session, "device_filter", selected = "Tous")
    updateSelectInput(session, "location_filter", selected = "Tous")
    updateSelectInput(session, "health_filter", selected = "Tous")
  })
  
  # ─────────────────────────────────────────────────────────────
  # INFO BOXES - ACCUEIL
  # ─────────────────────────────────────────────────────────────
  
  output$total_children <- renderText({
    format(nrow(filtered_data()), big.mark = ",")
  })
  
  output$avg_screen_time <- renderText({
    sprintf("%.2f h/jour", mean(filtered_data()$Avg_Daily_Screen_Time_hr, na.rm = TRUE))
  })
  
  output$at_risk <- renderText({
    at_risk <- sum(filtered_data()$Avg_Daily_Screen_Time_hr > 6 & filtered_data()$Has_Health_Impact)
    sprintf("%d (%.1f%%)", at_risk, 100 * at_risk / nrow(filtered_data()))
  })
  
  output$safe_children <- renderText({
    safe <- sum(filtered_data()$Avg_Daily_Screen_Time_hr < 2 & !filtered_data()$Has_Health_Impact)
    sprintf("%d (%.1f%%)", safe, 100 * safe / nrow(filtered_data()))
  })
  
  # ─────────────────────────────────────────────────────────────
  # PLOTS - APERÇU
  # ─────────────────────────────────────────────────────────────
  
  output$plot_distribution <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = Avg_Daily_Screen_Time_hr)) +
      geom_histogram(bins = 30, fill = "#3498DB", alpha = 0.7) +
      geom_vline(aes(xintercept = mean(Avg_Daily_Screen_Time_hr)), 
                 color = "#E74C3C", linetype = "dashed", size = 1) +
      labs(title = "Distribution Temps Écran", x = "Heures/jour", y = "Nombre") +
      theme_minimal()
    ggplotly(p, tooltip = "y")
  })
  
  output$plot_risk_status <- renderPlotly({
    risk_data <- filtered_data() %>%
      mutate(status = case_when(
        Avg_Daily_Screen_Time_hr > 6 & Has_Health_Impact ~ "Danger",
        Avg_Daily_Screen_Time_hr < 2 & !Has_Health_Impact ~ "Sain",
        TRUE ~ "À surveiller"
      )) %>%
      group_by(status) %>%
      summarise(count = n(), .groups = 'drop')
    
    p <- ggplot(risk_data, aes(x = status, y = count, fill = status)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c("Danger" = "#E74C3C", 
                                    "Sain" = "#2ECC71", 
                                    "À surveiller" = "#F39C12")) +
      labs(title = "Statut Enfants", x = "", y = "Nombre") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = "y")
  })
  
  output$plot_screen_category <- renderPlotly({
    cat_data <- filtered_data() %>%
      group_by(Screen_Category) %>%
      summarise(count = n(), pct = 100 * n() / nrow(filtered_data()), .groups = 'drop')
    
    p <- ggplot(cat_data, aes(x = reorder(Screen_Category, count), y = count, fill = Screen_Category)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Catégories Temps Écran", x = "", y = "Nombre") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = c("x", "y"))
  })
  
  # ─────────────────────────────────────────────────────────────
  # PLOTS - APPAREILS
  # ─────────────────────────────────────────────────────────────
  
  output$plot_devices <- renderPlotly({
    device_data <- filtered_data() %>%
      group_by(Primary_Device) %>%
      summarise(mean_time = mean(Avg_Daily_Screen_Time_hr), .groups = 'drop')
    
    p <- ggplot(device_data, aes(x = reorder(Primary_Device, mean_time), y = mean_time, fill = Primary_Device)) +
      geom_bar(stat = "identity") +
      coord_flip() +
      labs(title = "Temps Écran Moyen par Appareil", x = "", y = "Heures/jour") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = "y")
  })
  
  output$plot_device_impact <- renderPlotly({
    device_health <- filtered_data() %>%
      group_by(Primary_Device) %>%
      summarise(pct_impact = 100 * sum(Has_Health_Impact) / n(), .groups = 'drop')
    
    p <- ggplot(device_health, aes(x = reorder(Primary_Device, pct_impact), y = pct_impact, fill = pct_impact)) +
      geom_bar(stat = "identity") +
      scale_fill_gradient(low = "#2ECC71", high = "#E74C3C") +
      coord_flip() +
      labs(title = "% Enfants avec Impacts par Appareil", x = "", y = "%") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = "y")
  })
  
  output$table_devices <- renderDT({
    device_stats <- filtered_data() %>%
      group_by(Primary_Device) %>%
      summarise(
        "Nombre" = n(),
        "Temps moyen (h)" = round(mean(Avg_Daily_Screen_Time_hr), 2),
        "% Impacts" = round(100 * sum(Has_Health_Impact) / n(), 1),
        .groups = 'drop'
      ) %>%
      arrange(desc(Nombre))
    
    datatable(device_stats, options = list(pageLength = 10))
  })
  
  # ─────────────────────────────────────────────────────────────
  # PLOTS - SANTÉ
  # ─────────────────────────────────────────────────────────────
  
  output$plot_health_impacts <- renderPlotly({
    health_data <- filtered_data() %>%
      separate_rows(Health_Impacts, sep = ", ") %>%
      filter(Health_Impacts != "None") %>%
      group_by(Health_Impacts) %>%
      summarise(count = n(), .groups = 'drop') %>%
      arrange(desc(count)) %>%
      slice(1:10)
    
    p <- ggplot(health_data, aes(x = reorder(Health_Impacts, count), y = count)) +
      geom_bar(stat = "identity", fill = "#E74C3C") +
      coord_flip() +
      labs(title = "Top 10 Impacts Santé", x = "", y = "Nombre") +
      theme_minimal()
    ggplotly(p, tooltip = "y")
  })
  
  output$vb_with_impact <- renderValueBox({
    n_with <- sum(filtered_data()$Has_Health_Impact)
    valueBox(
      value = sprintf("%d (%.1f%%)", n_with, 100 * n_with / nrow(filtered_data())),
      subtitle = "Avec impacts santé",
      icon = icon("warning"),
      color = "red"
    )
  })
  
  output$vb_without_impact <- renderValueBox({
    n_without <- sum(!filtered_data()$Has_Health_Impact)
    valueBox(
      value = sprintf("%d (%.1f%%)", n_without, 100 * n_without / nrow(filtered_data())),
      subtitle = "Sans impacts santé",
      icon = icon("check"),
      color = "green"
    )
  })
  
  output$vb_avg_ratio <- renderValueBox({
    avg_ratio <- mean(filtered_data()$Educational_to_Recreational_Ratio)
    valueBox(
      value = sprintf("%.3f", avg_ratio),
      subtitle = "Ratio Éducatif/Récréatif moyen",
      icon = icon("book"),
      color = "blue"
    )
  })
  
  # ─────────────────────────────────────────────────────────────
  # PLOTS - DÉMOGRAPHIE
  # ─────────────────────────────────────────────────────────────
  
  output$plot_age <- renderPlotly({
    age_data <- filtered_data() %>%
      group_by(Age_Group) %>%
      summarise(mean_time = mean(Avg_Daily_Screen_Time_hr), .groups = 'drop')
    
    p <- ggplot(age_data, aes(x = Age_Group, y = mean_time, fill = Age_Group)) +
      geom_bar(stat = "identity") +
      labs(title = "Temps Écran par Groupe d'Âge", x = "Groupe d'âge", y = "Heures/jour") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = "y")
  })
  
  output$plot_gender <- renderPlotly({
    gender_data <- filtered_data() %>%
      group_by(Gender) %>%
      summarise(mean_time = mean(Avg_Daily_Screen_Time_hr), .groups = 'drop')
    
    p <- ggplot(gender_data, aes(x = Gender, y = mean_time, fill = Gender)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c("Male" = "#3498DB", "Female" = "#E91E63")) +
      labs(title = "Temps Écran par Sexe", x = "Sexe", y = "Heures/jour") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = "y")
  })
  
  output$plot_location <- renderPlotly({
    location_data <- filtered_data() %>%
      group_by(Urban_or_Rural) %>%
      summarise(mean_time = mean(Avg_Daily_Screen_Time_hr), .groups = 'drop')
    
    p <- ggplot(location_data, aes(x = Urban_or_Rural, y = mean_time, fill = Urban_or_Rural)) +
      geom_bar(stat = "identity") +
      scale_fill_manual(values = c("Urban" = "#9B59B6", "Rural" = "#27AE60")) +
      labs(title = "Urbain vs Rural", x = "Localisation", y = "Heures/jour") +
      theme_minimal() +
      theme(legend.position = "none")
    ggplotly(p, tooltip = "y")
  })
  
  output$plot_ratio <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = Educational_to_Recreational_Ratio, 
                                      fill = as.factor(Has_Health_Impact))) +
      geom_histogram(bins = 30, alpha = 0.6) +
      scale_fill_manual(values = c("FALSE" = "#2ECC71", "TRUE" = "#E74C3C"),
                        labels = c("FALSE" = "Pas impacts", "TRUE" = "Avec impacts")) +
      labs(title = "Ratio Éducatif: Facteur Protecteur", x = "Ratio", y = "Nombre",
           fill = "") +
      theme_minimal()
    ggplotly(p, tooltip = "y")
  })
  
  # ─────────────────────────────────────────────────────────────
  # PLOTS - ANALYSES
  # ─────────────────────────────────────────────────────────────
  
  output$plot_correlation <- renderPlotly({
    p <- ggplot(filtered_data(), aes(x = Avg_Daily_Screen_Time_hr, y = as.numeric(Has_Health_Impact))) +
      geom_jitter(alpha = 0.3, height = 0.05, color = "#3498DB") +
      geom_smooth(method = "glm", method.args = list(family = "binomial"),
                  color = "#E74C3C", fill = "#E74C3C", alpha = 0.2) +
      labs(title = "Corrélation: Temps Écran × Probabilité d'Impacts Santé",
           x = "Heures d'écran/jour", y = "Probabilité d'impacts") +
      theme_minimal()
    ggplotly(p, tooltip = c("x", "y"))
  })
  
  output$table_analysis <- renderDT({
    analysis_data <- filtered_data() %>%
      group_by(Screen_Category) %>%
      summarise(
        "Total" = n(),
        "Avec impacts" = sum(Has_Health_Impact),
        "Sans impacts" = sum(!Has_Health_Impact),
        "% Impacts" = round(100 * sum(Has_Health_Impact) / n(), 1),
        .groups = 'drop'
      )
    
    datatable(analysis_data, options = list(pageLength = 10))
  })
  
  # ─────────────────────────────────────────────────────────────
  # TABLE - DONNÉES COMPLÈTES
  # ─────────────────────────────────────────────────────────────
  
  output$table_full_data <- renderDT({
    datatable(filtered_data(), options = list(pageLength = 20, scrollX = TRUE))
  })
  
  output$download_data <- downloadHandler(
    filename = "screen_time_filtered.csv",
    content = function(file) {
      write.csv(filtered_data(), file, row.names = FALSE)
    }
  )
}

# RUN APP
shinyApp(ui, server)