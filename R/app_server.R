#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ) {
  # List the first level callModules here
  
  mod_trust_view_server("trust_view_ui_1")
  
  mod_trend_module_server("trend_module_ui_1")
}
