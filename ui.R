library(plotly)
library(shiny)
library(ggplot2)

################################################################################
########### Samplemeta #########################################################
################################################################################


tab_about <- fluidPage(
  p("This demo was originally developed by ", a("Johan Henriksson", href="http://www.henlab.org")),
  p("Licensed under 2-clause BSD license, https://opensource.org/license/bsd-2-clause/")
)

################################################################################
########### Main tab ###########################################################
################################################################################


tab_statdist <- fluidPage(
  fluidRow(
    column(6,
           

           div(class = "label-left",
   
               
               h3("Configure prior:"),
               p("µ ∼ N (",HTML(paste0("µ",tags$sub("0"))),", ",HTML(paste0("σ",tags$sub("0"))),"²)"),
               
               sliderInput(
                 inputId = "mu0",
                 label = HTML(paste0("µ",tags$sub("0"),":")),
                 min=-10,
                 max=10,
                 value=0,
                 step=0.01
               ),
               
               sliderInput(
                 inputId = "sigma0",
                 label =  HTML(paste0("σ",tags$sub("0"),":")),
                 min=0,
                 max=10,
                 value=1,
                 step=0.01
               ),

               p("Assume x",shiny::tags$sub("i")," | µ ∼ N (µ, σ²)"),
               
               
               sliderInput(
                 inputId = "sigma",
                 label = "σ:",
                 min=0,
                 max=10,
                 value=1,
                 step=0.01
               ),

               
                              
              h3("New data"),
              textInput("newdata", label = "Data points:", value = "0"),
           ),
           

           
    ),
    column(6,
           
           
           
           h3("Distributions"),
           
           plotOutput(outputId = "plotPDF", height = "400px"),
           

    ),
  )
)



################################################################################
########### Total page #########################################################
################################################################################

#https://stackoverflow.com/questions/72040479/how-to-position-label-beside-slider-in-r-shiny

ui <- fluidPage(
  tags$style(HTML(
    "
    .label-left .form-group {
      display: flex;              /* Use flexbox for positioning children */
      flex-direction: row;        /* Place children on a row (default) */
      width: 100%;                /* Set width for container */
      max-width: 400px;
    }

    .label-left label {
      margin-right: 2rem;         /* Add spacing between label and slider */
      align-self: center;         /* Vertical align in center of row */
      text-align: right;
      flex-basis: 100px;          /* Target width for label */
    }

    .label-left .irs {
      flex-basis: 300px;          /* Target width for slider */
    }
    "
  )),
  
  shinyjs::useShinyjs(),
  
  titlePanel("Demo of Bayesian updating"),

  mainPanel(
    tabsetPanel(type = "tabs",
                tabPanel("General", tab_statdist),
                tabPanel("About", tab_about)
    )
  )
  
)



