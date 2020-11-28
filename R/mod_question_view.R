#' question_view UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_question_view_ui <- function(id){
  ns <- NS(id)
  tagList(
    
    fluidRow(
      column(2, selectInput(ns("question"), "Question",
                            choices = names(df %>% dplyr::select(-Trustname)))),
      
      column(10, DT::DTOutput(ns("table")))
    ) 
  )
}

#' question_view Server Function
#'
#' @noRd 
mod_question_view_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$table <- DT::renderDT({
      
      DT::datatable(df %>% 
                      dplyr::select(Trustname, .data[[input$question]],
                                    .data[[paste0(input$question)]]) %>% 
                      dplyr::arrange(desc(.data[[input$question]])),
                    options = list(
                      pageLength = 20,
                      lengthMenu = c(20, 50, 100)), rownames = FALSE
      ) %>% 
        DT::formatRound(input$question)
    })
  })
}
