#' trend_module UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_trend_module_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    fluidRow(
      column(3,
             selectInput(ns("trust"), "Select Trust",
                         choices = sort(unique(df$Trustname)),
                         selected = "Nottinghamshire Healthcare NHS Foundation Trust"),
             
             selectInput(ns("questionSection"), 
                         "View questions or sections",
                         choices = c("Questions" = "Q",
                                     "Sections" = "S")),
             
             selectInput(ns("rankMean"),
                         "View rank or mean",
                         choices = c("Rank", "Mean"))
      ),
      
      column(9, plotOutput(ns("trendGraph"), height = "600px"))
    )
  )
}

#' trend_module Server Functions
#'
#' @noRd 
mod_trend_module_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$trendGraph <- renderPlot({
      
      graph_type <- input$rankMean
      
      trend_data %>% 
        dplyr::filter(Trustname == input$trust) %>%
        tidyr::pivot_longer(cols = c(-Trustname, -year)) %>% 
        tidyr::separate(col = name, sep = 5, into = c("type", "number")) %>% 
        tidyr::pivot_wider(names_from = c(type, year), values_from = value) %>% 
        dplyr::select(-Trustname) %>% 
        purrr::set_names(c("Question", "Mean 2020", "Rank 2020", "Mean 2019", "Rank 2019")) %>%  
        dplyr::left_join(all_names, by = c("Question" = "code")) %>% 
        dplyr::filter(grepl(input$questionSection, Question)) %>% 
        dplyr::select(Question, dplyr::starts_with(graph_type)) %>% 
        purrr::set_names(c("Question", "score_2020", "score_2019")) %>% 
        dplyr::mutate(change = dplyr::case_when(
          graph_type == "Mean" & (score_2020 - score_2019 < 0) ~ "Worse",
          graph_type == "Mean" & (score_2020 - score_2019 >= 0) ~ "Better",
          graph_type == "Rank" & (score_2019 - score_2020 < 0) ~ "Worse",
          graph_type == "Rank" & (score_2019 - score_2020 >= 0) ~ "Better")) %>% 
        dplyr::mutate(Question = reorder(Question, score_2020)) %>% 
        dplyr::arrange(desc(score_2020)) %>% 
        ggplot2::ggplot(ggplot2::aes(x = Question, 
                                     xend = Question,
                                     y = score_2020, yend = score_2019,
                                     colour = change, group = change)) +
        ggplot2::geom_segment() + ggplot2::scale_color_manual(limits = c("Better", "Worse"),
                                                              values = c("green", "red")) +
        ggplot2::geom_point(colour = "black", shape = 1) +
        ggplot2::geom_point(ggplot2::aes(x = Question, y = score_2019), 
                            colour = "black", shape = 16) +
        ggplot2::coord_flip() + ggplot2::theme_minimal() +
        ggplot2::ggtitle("Hollow: 2020 data. Filled: 2019 data") +
        ggplot2::ylab(graph_type)
    })
  })
}

## To be copied in the UI
# 

## To be copied in the server
# 
