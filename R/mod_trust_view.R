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
                         choices = sort(unique(df$Trustname)),
                         selected = "Nottinghamshire Healthcare NHS Foundation Trust"),
             selectInput(ns("questionSection"), 
                         "View questions or sections",
                         choices = c("Questions" = "Q",
                                     "Sections" = "S")),
             wellPanel(
               p("Reorder the table by clicking any header")
             ),
             wellPanel(
               p("Click the table to see a graph of all trusts for that question")
             )
      ),
      
      column(4,
             DT::dataTableOutput(ns("trustView"))),
      
      column(6, plotOutput(ns("questionView"), height = "600px"))
    )
  )
}

#' trust_view Server Function
#'
#' @noRd 
mod_trust_view_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    tableData <- reactive({
      
      df %>% 
        dplyr::filter(Trustname == input$trust) %>%
        tidyr::pivot_longer(cols = -Trustname) %>% 
        tidyr::separate(col = name, sep = 5, into = c("type", "number")) %>% 
        tidyr::pivot_wider(names_from = c(type), values_from = value) %>% 
        dplyr::select(-Trustname) %>% 
        purrr::set_names(c("Question", "Mean score", "Rank")) %>%  
        dplyr::left_join(all_names, by = c("Question" = "code")) %>% 
        dplyr::filter(grepl(input$questionSection, Question)) %>% 
        tibble::column_to_rownames(var = "Question") %>% 
        dplyr::select(Question = name, everything())
    })
    
    output$trustView <- DT::renderDT({
      
      DT::datatable(tableData(),
                    selection = 'single',
                    options = list(
                      pageLength = 20,
                      lengthMenu = c(20, 50, 100))
      ) %>%
        DT::formatRound("Mean score")
    })
    
    output$questionView <- renderPlot({
      
      req(input$trustView_rows_selected)
      
      selected_row <- rownames(tableData() %>% 
                         dplyr::slice(input$trustView_rows_selected))
      
      df %>% 
        tidyr::pivot_longer(cols = -Trustname) %>% 
        tidyr::separate(col = name, sep = 5, into = c("type", "number")) %>% 
        tidyr::pivot_wider(names_from = c(type), values_from = value) %>% 
        dplyr::filter(number == selected_row) %>% 
        purrr::set_names(c("Trustname", "Question", "Mean score", "Rank")) %>%  
        dplyr::left_join(all_names, by = c("Question" = "code")) %>% 
        dplyr::select(Trust = Trustname, `Mean score`) %>% 
        ggplot2::ggplot(ggplot2::aes(x = reorder(Trust, `Mean score`), y = `Mean score`)) +
        ggplot2::geom_bar(stat = "identity") +
        ggplot2::coord_flip() + ggplot2::ylab("Trust")
    })
  })
}
