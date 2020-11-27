#' trust_view UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_trust_view_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    fluidRow(
      column(2,
             selectInput(ns("trust"), "Select Trust",
                         choices = unique(df$Trustname),
                         selected = "Nottinghamshire Healthcare NHS Foundation Trust")
             ),
      
      column(10,
             DT::dataTableOutput(ns("trustView")))
    )
    

  )
}

#' trust_view Server Function
#'
#' @noRd 
mod_trust_view_server <- function(input, output, session){
  ns <- session$ns
  
  output$trustView <- DT::renderDT({
    
    DT::datatable(df %>% 
      dplyr::filter(Trustname == input$trust) %>%
      # dplyr::filter(Trustname == "Nottinghamshire Healthcare NHS Foundation Trust") %>% 
      tidyr::pivot_longer(!Trustname) %>% 
        dplyr::select(-Trustname) %>% 
      purrr::set_names(c("Question", "Mean score")),
    options = list(
      pageLength = 20,
      lengthMenu = c(20, 50, 100)), rownames = FALSE
      ) %>% 
    DT::formatRound("Mean score")
  })
  
}

