#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # List the first level UI elements here 
    dashboardPage(
      dashboardHeader(title = "CMHS dashboard"),
      dashboardSidebar(
        sidebarMenu(
          menuItem("Trust view", tabName = "trust", icon = icon("hospital-user")),
          
          menuItem("Trend view", tabName = "trend", icon = icon("chart-line"))
        )
      ),
      dashboardBody(
        tabItems(
          
          tabItem(tabName = "trust",
                  mod_trust_view_ui("trust_view_ui_1"),
          ),
          tabItem(tabName = "trend",
                  mod_trend_module_ui("trend_module_ui_1"),
          )
        ),
        p(HTML("<a href = 'www.cqc.org.uk/cmhsurvey'>All content cqc.org.uk/cmhsurvey</a>"))
      )
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
  
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'cmhsDashboard'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

