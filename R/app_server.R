#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  callModule(mod_trust_view_server, "trust_view_ui_1")
  
  callModule(mod_question_view_server, "question_view_ui_1")
}
