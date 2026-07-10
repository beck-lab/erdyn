#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(shinybrowser)
# library(shinyjs)
# library(shinyBS)
library(magick)
library(imager)
library(readxl)
# library(curl) # make the jsonlite suggested dependency explicit
library(qgraph)
library(patchwork)
library(plyr)
library(tidyverse)

ui <- dashboardPage(
  dashboardHeader(
    title = "ER Dynamics"
    , titleWidth = 235
  ),
  dashboardSidebar(
    sidebarMenu(
      id = "tabs",
      menuItem("Home", tabName = "home", icon = icon("home")),
      menuItem("Descriptives", tabName = "desc", icon = icon("arrow-alt-circle-right")),
      menuItem("RQ1 Overview", tabName = "rq1", icon = icon("arrow-alt-circle-right")),
      menuItem("RQ1 Idiographic Results", tabName = "rq1b", icon = icon("arrow-alt-circle-right")),
      menuItem("RQ2 Overview", tabName = "rq2", icon = icon("arrow-alt-circle-right")),
      menuItem("RQ2 Idiographic Results", tabName = "rq2b", icon = icon("arrow-alt-circle-right")),
      menuItem("Time Series Plots", tabName = "ts", icon = icon("arrow-alt-circle-right"))#,
      # menuItem("Multilevel VAR", tabName = "mlvar-plot", icon = icon("arrow-alt-circle-right")),
      # # menuItem("Centrality Plots", tabName = "Centrality", icon = icon("arrow-alt-circle-right")),
      # menuItem("Zero-Order Correlations", tabName = "cors", icon = icon("arrow-alt-circle-right")),
      # menuItem("Sample Size Tables", tabName = "sampsize", icon = icon("arrow-alt-circle-right")),
      # menuItem("LASSO Graphical VAR", tabName = "lasso-plot", icon = icon("arrow-alt-circle-right")),
      # menuItem("Robustness Tests", tabName = "rob-plot", icon = icon("arrow-alt-circle-right")),
      # menuItem("Time Series Plots", tabName = "ts-plot", icon = icon("arrow-alt-circle-right"))
    )
  ),
  dashboardBody(
    tags$head(tags$style(HTML('
      .skin-blue .main-header .logo {
        background-color: #022851; 
      }
      
      .skin-blue .main-header .logo:hover {
        background-color: #022851; 
      }
      
      .skin-blue .main-header .navbar {
        background-color: #022851; 
      }
    '))),
    tabItems(
      ### Home page -----------------------------------------------
      tabItem(
        "home",
        h2("Home Page and Study Information"),
        fluidRow(
          box(
            shinybrowser::detect(),
            h3("Background: Emotion as an Idiographic Dynamic System"),
            width = 6,
            htmlOutput("home_box1Text"),
            htmlOutput("home_box1")
          ),
          box(
            h3("Background: Emotion as a Goal-Directed Idiographic Dynamic System"),
            width = 6,
            htmlOutput("home_box2Text"),
            htmlOutput("home_box2")
          ),
          box(
            h3("Hypotheses"),
            width = 12,
            textOutput("home_box4Text"),
            htmlOutput("home_box4")
          )
        )
      ),
      ## Descriptives page -----------------------------------------------
      tabItem(
        "desc",
        h2("Descriptives"),
        fluidRow(
          column(width = 9,
                 box(
                   h3("Between-Person and Person-Specific Descriptive Statistics"),
                   width = 12,
                   textOutput("desc_box1Text")
                 ),
                 box(
                   h3("Between-Person Descriptives"),
                   width = 12,
                   textOutput("desc_box2Text"),
                   htmlOutput("desc_box2Tab")
                 ),
                 box(
                   h3("Person-Specific Correlations"),
                   width = 12,
                   htmlOutput("desc_box3Text"),
                   htmlOutput("desc_box3Tab")
                 ),
                 box(
                   h3("ICCs"),
                   width = 12,
                   htmlOutput("desc_box4Text"),
                   htmlOutput("desc_box4Tab")
                 )
          ),
          column(width = 3,
                 box(
                   title = p("Inputs", style = 'font-size:20px;color:white;'),
                   width = 12,
                   solidHeader = T,
                   background = "navy",
                   selectizeInput("SID1",
                                  "Participant ID:",
                                  choices = "")
                 )
          )
        )
      ),
      ### RQ1 Overview -----------------------------------------------
      tabItem(
        "rq1",
        h2("RQ1 Overview"),
        fluidRow(
          column(width = 9,
                 box(
                   h3("Background"),
                   width = 12,
                   textOutput("rq1_box1Text")
                 ),
                 box(
                   h3("Individual Differences in Idiographic Emotion Systems"),
                   width = 12,
                   textOutput("rq1_box2Text"),
                   htmlOutput("rq1_box2Plot")
                 ),
                 box(
                   h3("Meta-Analytic Estimates of Model Parameter Estimates"),
                   width = 12,
                   # htmlOutput("res_box3Text"),
                   htmlOutput("rq1_box3Tab")
                 )
          ),
          column(width = 3,
                 box(
                   title = p("Inputs", style = 'font-size:20px;color:white;'),
                   width = 12,
                   solidHeader = T,
                   background = "navy",
                   selectizeInput("focal3",
                                  "Emotion Set:",
                                  choices = c("Focal", "Supplementary")),
                   selectizeInput("exclusion3"
                                  , "Exclusion Criteria:"
                                  , choices = c("Parameter-Based Exclusion", "Person-Based Exclusion")),
                   selectizeInput("er_exc3"
                                  , "Exclusion Criteria:"
                                  , choices = c("All Data", "Emotion Regulation Events"))
                 )
          )
        )
      ),
      ### RQ1 N=1 -----------------------------------------------
      tabItem(
        "rq1b",
        h2("RQ1 Idiographic Results"),
        fluidRow(
          column(width = 9,
                 box(
                   h3("Background"),
                   width = 12,
                   textOutput("rq1b_box1Text")
                 ),
                 box(
                   h3("Idiographic Emotion System"),
                   width = 12,
                   textOutput("rq1b_box2Text"),
                   htmlOutput("rq1b_box2Plot")
                 ),
                 box(
                   h3("Model Parameter Estimates"),
                   width = 12,
                   # htmlOutput("res_box3Text"),
                   htmlOutput("rq1b_box3Tab")
                 )
          ),
          column(width = 3,
                 box(
                   title = p("Inputs", style = 'font-size:20px;color:white;'),
                   width = 12,
                   solidHeader = T,
                   background = "navy",
                   selectizeInput("SID5",
                                  "Participant ID:",
                                  choices = ""),
                   selectizeInput("emo5",
                                  "Emotion Indicator:",
                                  choices = c("Positive", "Negative", "Angry", "Afraid", "Guilty", "Sad", "Happy", "Excited", "Proud", "Content")),
                   selectizeInput("er_exc5"
                                  , "Exclusion Criteria:"
                                  , choices = c("All Data", "Emotion Regulation Events"))
                 )
          )
        )
      ),
      ### RQ2 Overview -----------------------------------------------
      tabItem(
        "rq2",
        h2("RQ2 Overview"),
        fluidRow(
          column(width = 9,
                 box(
                   h3("Background"),
                   width = 12,
                   textOutput("rq2_box1Text")
                 ),
                 box(
                   h3("Individual Differences in Goal-Directed Idiographic Emotion Systems"),
                   width = 12,
                   textOutput("rq2_box2Text"),
                   htmlOutput("rq2_box2Plot")
                 ),
                 box(
                   h3("Meta-Analytic Estimates of Model Parameter Estimates"),
                   width = 12,
                   # htmlOutput("res_box3Text"),
                   htmlOutput("rq2_box3Tab")
                 )
          ),
          column(width = 3,
                 box(
                   title = p("Inputs", style = 'font-size:20px;color:white;'),
                   width = 12,
                   solidHeader = T,
                   background = "navy",
                   selectizeInput("ergoal4",
                                  "Emotion Regulation Goal:",
                                  choices = c("Goal to Change Positive Emotions", "Goal to Change Negative Emotions")),
                   selectizeInput("focal4",
                                  "Emotion Set:",
                                  choices = c("Focal", "Supplementary")),
                   selectizeInput("exclusion4"
                                  , "Exclusion Criteria:"
                                  , choices = c("Parameter-Based Exclusion", "Person-Based Exclusion")),
                   selectizeInput("er_exc4"
                                  , "Exclusion Criteria:"
                                  , choices = c("All Data", "Emotion Regulation Events"))
                 )
          )
        )
      ),
      ### RQ2 N=1 -----------------------------------------------
      tabItem(
        "rq2b",
        h2("RQ2 Idiographic Results"),
        fluidRow(
          column(width = 9,
                 box(
                   h3("Background"),
                   width = 12,
                   textOutput("rq2b_box1Text")
                 ),
                 box(
                   h3("Idiographic Goal-Directed Emotion System"),
                   width = 12,
                   textOutput("rq2b_box2Text"),
                   htmlOutput("rq2b_box2Plot")
                 ),
                 box(
                   h3("Model Parameter Estimates"),
                   width = 12,
                   # htmlOutput("res_box3Text"),
                   htmlOutput("rq2b_box3Tab")
                 )
          ),
          column(width = 3,
                 box(
                   title = p("Inputs", style = 'font-size:20px;color:white;'),
                   width = 12,
                   solidHeader = T,
                   background = "navy",
                   selectizeInput("SID6",
                                  "Participant ID:",
                                  choices = ""),
                   selectizeInput("emo6",
                                  "Emotion Indicator:",
                                  choices = c("Positive", "Sad", "Happy", "Excited", "Proud", "Content")),
                   selectizeInput("ergoal6",
                                  "Emotion Regulation Goal:",
                                  choices = c("Goal to Change Positive Emotions", "Goal to Change Negative Emotions")),
                   selectizeInput("er_exc6"
                                  , "Exclusion Criteria:"
                                  , choices = c("All Data", "Emotion Regulation Events"))
                 )
          )
        )
      ),
      ### Time Series Plots -----------------------------------------------
      tabItem(
        "ts",
        h2("Time Series Plots"),
        fluidRow(
          column(width = 9,
                 box(
                   h3("Background"),
                   width = 12,
                   textOutput("ts_box1Text")
                 ),
                 box(
                   h3("Figure S1"),
                   width = 12,
                   htmlOutput("ts_box2Text"),
                   htmlOutput("ts_box2Plot")
                 ),
                 box(
                   h3("N=1 Time Series Plots"),
                   width = 12,
                   # htmlOutput("res_box3Text"),
                   htmlOutput("ts_box3Plot")
                 ),
                 box(
                   h3("Do people return to baseline?"),
                   width = 12,
                   htmlOutput("ts_box4Text"),
                   htmlOutput("ts_box4Tab")
                 )
          ),
          column(width = 3,
                 box(
                   title = p("Inputs", style = 'font-size:20px;color:white;'),
                   width = 12,
                   solidHeader = T,
                   background = "navy",
                   selectizeInput("SID7",
                                  "Participant ID:",
                                  choices = ""),
                   selectizeInput("emo7",
                                  "Emotion Indicator:",
                                  choices = c("Positive", "Negative", "Angry", "Afraid", "Guilty", "Sad", "Happy", "Excited", "Proud", "Content")),
                   selectizeInput("exclusion7"
                                  , "Exclusion Criteria:"
                                  , choices = c("Parameter-Based Exclusion", "Person-Based Exclusion")),
                   selectizeInput("er_exc7"
                                  , "Exclusion Criteria:"
                                  , choices = c("All Data", "Emotion Regulation Events"))
                 )
          )
        )
      )#,
      
    )
  )
)



# functions ---------------------------------------------------------------



load_url <- function (url, ..., sha1 = NULL) {
  # based very closely on code for devtools::source_url
  stopifnot(is.character(url), length(url) == 1)
  temp_file <- tempfile()
  on.exit(unlink(temp_file))
  request <- httr::GET(url)
  httr::stop_for_status(request)
  writeBin(httr::content(request, type = "raw"), temp_file)
  file_sha1 <- digest::digest(file = temp_file, algo = "sha1")
  if (is.null(sha1)) {
    message("SHA-1 hash of file is ", file_sha1)
  }
  else {
    if (nchar(sha1) < 6) {
      stop("Supplied SHA-1 hash is too short (must be at least 6 characters)")
    }
    file_sha1 <- substr(file_sha1, 1, nchar(sha1))
    if (!identical(file_sha1, sha1)) {
      stop("SHA-1 hash of downloaded file (", file_sha1, 
           ")\n  does not match expected value (", sha1, 
           ")", call. = FALSE)
    }
  }
  load(temp_file, envir = .GlobalEnv)
}
library(RColorBrewer)
edge_colors <- RColorBrewer::brewer.pal(8, "Purples")[c(3,4,6)]

loadRData <- function(SID, type, study, h){
  #loads an RData file, and returns it
  path <- sprintf("%s/04_results/02_graphicalVAR/small/%s/%s/%s.RData?raw=true", wd, h, study, SID)
  load_url(path)
  get(ls()[ls() == type])
}

# load_url("https://github.com/beck-lab/PAIRS-Network-Stability/raw/master/idiographic_plots.RData")
#load("~/Box Sync/network/PAIRS/PAIRS_graphicalVAR/centralityPlots.RData")
# load_url("https://github.com/beck-lab/PAIRS-Network-Stability/raw/master/centralityPlots.RData")
# load_url("https://github.com/beck-lab/PAIRS_graphicalVAR/raw/master/app_data.RData")
wd <- "https://github.com/beck-lab/erdyn/blob/main"

load_url("https://github.com/beck-lab/erdyn/raw/main/erdyn/desc-subs.RData")
load_url("https://github.com/beck-lab/erdyn/raw/refs/heads/main/erdyn/rq1_plot_subs.RData")
load_url("https://github.com/beck-lab/erdyn/raw/refs/heads/main/erdyn/rq2_int_plot_subs.RData")
load_url("https://github.com/beck-lab/erdyn/raw/refs/heads/main/erdyn/ts_subs.RData")
# load_url("https://github.com/beck-lab/personalised-happiness/blob/main/04_results/svar_subs.RData?raw=true")
# load_url("https://github.com/beck-lab/personalised-happiness/raw/main/04_results/01_mlVAR/pop_results_small.RData")

server <- function(input, output, session) {
  # print(sids)
  print(input)
  
  ### Pop-Up Box ----------------------------------------------
  showModal(
    modalDialog(
      title = "Welcome to the Interactive Results for this project: Emotion regulation as an idiographic dynamic system",
      easyClose = TRUE,
      footer = modalButton("Get Started"),
      tags$p(
        "In this project, we examined how emotion can be understood as (1) an idiographic dynamic system and (2) a ",
        "goal-directed idiographic dynamic system characterized by equilibria. To do so, we use data from two ",
        "intensive longitudinal studies that assessed both emotion and emotion regulation goals (i.e. whether ",
        "people wanted to increase, maintain, or decrease their emotions. We modeled these data as stochastic ",
        "differential equation models in which changes in emotion were predicted from current emotion levels (RQ1) ",
        "and main effect of emotion regulation goals as well as interaction between the two (RQ2). We then validated ",
        "individual differences in these models as predictors of baseline assessments of well-being. "
      ),
      tags$p(
        "As you'll see, we found that people differ in their emotion systems, the degree to which these systems ",
        "are goal-directed, and their emotion regulation efficacy. We also see that there are some associations ",
        "between components of these systems and baseline well-being."
      ),
      tags$p(
        "We suggest checking out the full set of materials on the OSF and GitHub:"
      ),
      tags$ul(
        tags$li(
          "Preprint: ", HTML('<a href="" target="_blank">PsyArxiv</a>')
        ),
        tags$li(
          "OSF Materials: ", HTML('<a href="https://osf.io/89kmw/overview?view_only=afb561a8a1e448579d648477ae2a18b5" target="_blank">https://osf.io/89kmw/overview?view_only=afb561a8a1e448579d648477ae2a18b5</a>')
        ),
        tags$li(
          "GitHub Materials: ", HTML('<a href="" target="_blank"></a>')
        )#,
        # tags$li(
        #   "Static Web Page: ", HTML('<a href="https://emoriebeck.github.com/personalised-happiness" target="_blank">https://emoriebeck.github.com/personalised-happiness</a>')
        # )
      ),
      tags$p("Thanks for visiting!"),
      #tags$p(HTML("&mdash; Tabea Springstein, Rohit Batra, and Emorie D. Beck"))
    )
  )
  
  ### Reactive Outputs ----------------------------------------
  ## (home page)
  observe({
    updateSelectizeInput(session, 'SID1', choices = c("", desc_subs$sid))
  })
  # 
  ## RQ1 - idio (b)
  observe({
    er_exc5 = mapvalues(input$er_exc5, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    rq1_plot_subs2 <- (rq1_plot_subs %>% filter(er_exc == er_exc5 & emo_item == input$emo5))$SID
    updateSelectizeInput(session, 'SID5', choices = c("", rq1_plot_subs2))
  })
  
  ## RQ2 - idio (b)
  observe({
    er_exc6 <- mapvalues(input$er_exc6, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    ergoal6 <- mapvalues(input$ergoal6, paste("Goal to Change", c("Positive", "Negative"), "Emotions"), c("goalPos", "goalNeg"), warn_missing = F)
    rq2_int_plot_subs2 <- (rq2_int_plot_subs %>% filter(er_exc == er_exc6 & emo_item == input$emo6 & ergoal == ergoal6))$SID
    print(rq2_int_plot_subs2)
    updateSelectizeInput(session, 'SID6', choices = c("", rq2_int_plot_subs2))
  })
  
  observe({
    er_exc6 <- mapvalues(input$er_exc6, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    ergoal6 <- mapvalues(input$ergoal6, paste("Goal to Change", c("Positive", "Negative"), "Emotions"), c("goalPos", "goalNeg"), warn_missing = F)
    emo_set <- if(input$ergoal6 == "Goal to Change Positive Emotions") c("Positive", "Happy", "Excited", "Proud", "Content") else c("Negative", "Angry", "Afraid", "Guilty", "Sad")
    updateSelectizeInput(session, 'emo6', choices = c("", emo_set))
    # c("Positive", "Negative", "Angry", "Afraid", "Guilty", "Sad", "Happy", "Excited", "Proud", "Content")
  })
  
  ## Time Series
  observe({
    er_exc7 <- mapvalues(input$er_exc5, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    exc7 <- mapvalues(input$exclusion7, c("Parameter-Based Exclusion", "Person-Based Exclusion"), c("parameter", "person"), warn_missing = F)
    ts_subs2 <- (ts_subs %>% filter(er_exc == er_exc7 & emo_item == input$emo7 & exclusion == exc7))$SID
    updateSelectizeInput(session, 'SID7', choices = c("", ts_subs2))
  })
  # 
  # svar_subs_all <- svar_subs %>% select(-dir) %>% distinct()
  # 
  # observe({
  #   subs3 <- (svar_subs_all %>% filter(hrmnzn == input$hrmnz1 & Study == input$study1))$SID
  #   set.seed(4)
  #   subs3 <- sample(subs3, 100)
  #   updateSelectizeInput(session, 'SID3', choices = c("", subs3))
  # })
  
  # observe({
  #     subs3 <- (sids %>% filter(hrmnz == input$hrmnz3 & study == input$study3))$SID
  #     set.seed(4)
  #     subs3 <- sample(subs3, 100)
  #     updateSelectizeInput(session, 'SID3', choices = c("", subs3))
  # })
  # 
  # observe({
  #     subs4 <- (sids %>% filter(hrmnz == input$hrmnz4 & study == input$study4))$SID
  #     set.seed(4)
  #     subs4 <- sample(subs4, 100)
  #     updateSelectizeInput(session, 'SID4', choices = c("", subs4))
  # })
  
  ### Home  Outputs --------------------------------------------
  output$home_box1 <- renderText({
    # pulling plot object
    file <- "https://github.com/beck-lab/erdyn/raw/refs/heads/main/05-results/plots/fig-1-cao-v2.png"
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.2
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$home_box1Text <- renderText({
    return("<strong>Figure 1</strong>. <em>Emotion State Change predicted by Emotion State Level. 
             Attractor Location is defined as Emotion State Level where Emotion State Change is 
             expected to be 0. ")
  })
  
  output$home_box2 <- renderText({
    # pulling plot object
    file <- "https://github.com/beck-lab/erdyn/raw/refs/heads/main/05-results/plots/fig-2-int-v2.png"
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.3
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$home_box2Text <- renderText({
    return("<strong>Figure 2. </strong><em>Example Plots of Emotion State Change predicted by 
             Emotion State Level for goal to increase or goal to decrease. Panels A and C show 
             significant interactions, though only Panel C indicates successful regulation in 
             line with goals.")
  })
  
  output$home_box4 <- renderText({
    file <- "https://github.com/beck-lab/erdyn/raw/main/05-results/tables/tab-1-hypotheses.html"
    print(file)
    rawHTML <- paste(readLines(file), collapse="\n")
    return(rawHTML)
  })
  
  output$home_box4Text <- renderText({
    return("A comprehensive overview of our hypotheses for this research question is presented in Table 1.")
  })
  
  
  ### Descriptives ------------------------------------------------------------
  
  output$desc_box1Text <- renderText({
    return("In this study, we investigated dynamic changes in emotions while 
    considering momentary goals to up or downregulate positive and negative affect. 
    More details on the modelling procedure can be found in the Method and online materials. ")
  })
  
  output$desc_box2Text <- renderText({
    return("Below, Table 2 presents the between-person descriptives, zero-order correlations, and within- 
             and between-person reliabilty (where applicable).")
  })
  
  output$desc_box2Tab <- renderText({
    # validate(need(input$SID1, 'Please select a Participant ID'))
    file <- "https://github.com/beck-lab/erdyn/raw/main/05-results/tables/tab-2-bp-desc.html"
    print(file)
    rawHTML <- paste(readLines(file), collapse="\n")
    return(rawHTML)
  })
  
  output$desc_box3Text <- renderText({
    return("Below, you can choose a participant ID to see the within-person zero-order correlations among EMA variables.")
  })
  
  output$desc_box3Tab <- renderText({
    validate(need(input$SID1, 'Please select a Participant ID'))
    file <- mapvalues(input$SID1, desc_subs$sid, desc_subs$file, warn_missing = F)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/tables/px-r-tabs/%s", file)
    print(file)
    rawHTML <- paste(readLines(file), collapse="\n")
    return(rawHTML)
  })
  
  output$desc_box4Text <- renderText({
    return("Below, Table S2 presents the average within-person correlations 
           across all participants, within- and between-person reliability, 
           where applicable, ICC's of all EMA variables, and descriptives.")
  })
  
  output$desc_box4Tab <- renderText({
    # validate(need(input$SID1, 'Please select a Participant ID'))
    file <- "https://github.com/beck-lab/erdyn/raw/refs/heads/main/05-results/tables/tab-s1-within-rs-desc.html"
    print(file)
    rawHTML <- paste(readLines(file), collapse="\n")
    return(rawHTML)
  })
  
  ### RQ 1 Results Overview Outputs ----------------------------------------
  
  output$rq1_box1Text <- renderText({
    return("After you choose a group of emotions (focal = positive and negative affect; supplementary = discrete emotions), you will see 
             plots that demonstrate individual differences in simple emotion systems (top). If you want to zoom into specific participants'
             simple emotion systems, please see the next tabs.")
  })
  
  output$rq1_box2Plot <- renderText({
    # pulling plot object
    # input$focal3, input$exclusion3, input$er_exc3 
    focal3 <- mapvalues(input$focal3, c("Focal", "Supplementary"), c("focal", "sup"), warn_missing = F)
    exc3 <- mapvalues(input$exclusion3, c("Parameter-Based Exclusion", "Person-Based Exclusion"), c("parameter", "person"), warn_missing = F)
    er_exc3 <- mapvalues(input$er_exc3, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/plots/RQ1/%s-%s-%s.png", focal3, exc3, er_exc3)
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.5
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$rq1_box2Text <- renderText({
    return("Each line represents predicted attractor location (i.e., level of emotion where 
             change is predicted to be zero) and strength (i.e., slope of the line). Attractor 
             Location is defined as Emotion State Level where Emotion State Change is expected 
             to be 0.")
  })
  
  output$rq1_box3Tab <- renderText({
    # tabSx-sup-rq1-parameter-er-ma.html
    focal3 <- mapvalues(input$focal3, c("Focal", "Supplementary"), c("focal", "sup"), warn_missing = F)
    exc3 <- mapvalues(input$exclusion3, c("Parameter-Based Exclusion", "Person-Based Exclusion"), c("parameter", "person"), warn_missing = F)
    er_exc3 <- mapvalues(input$er_exc3, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/tables/RQ1/key-terms/tabSx-%s-rq1-%s-%s-ma.html", focal3, exc3, er_exc3)
    rawHTML <- paste(readLines(file), collapse="\n")
  })
  

  ### RQ1b - Idio -------------------------------------------------------------

  output$rq1b_box1Text <- renderText({
    return("After you choose a group of emotions (focal = positive and negative affect; supplementary = discrete emotions), you will see be able to choose a participant ID. Then, you'll see 
             plots that demonstrate specific participants'
             simple emotion systems.")
  })  
  
  output$rq1b_box2Plot <- renderText({
    # pulling plot object
    # input$focal3, input$exclusion3, input$er_exc3 
    validate(need(input$SID5, '\nPlease select a Participant ID'))
    er_exc5 <- mapvalues(input$er_exc5, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    sid5 <- input$SID5
    file <- rq1_plot_subs %>% filter(SID == sid5 & emo_item == input$emo5 & er_exc == er_exc5) %>% pull(file)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/plots/RQ1/px-traj/png/%s", file)
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.5
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$rq1b_box2Text <- renderText({
    return("Each line represents predicted attractor location (i.e., level of emotion where 
             change is predicted to be zero) and strength (i.e., slope of the line). Attractor 
             Location is defined as Emotion State Level where Emotion State Change is expected 
             to be 0.")
  })
  
  output$rq1b_box3Tab <- renderText({
    # tabSx-sup-rq1-parameter-er-ma.html
    validate(need(input$SID5, '\nPlease select a Participant ID'))
    er_exc5 <- mapvalues(input$er_exc5, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    sid5 <- input$SID5
    file <- rq1_plot_subs %>% filter(SID == sid5 & emo_item == input$emo5 & er_exc == er_exc5) %>% pull(file)
    file <- str_replace_all(file, ".png", ".html")
    # file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/plots/RQ1/px-traj/png/%s", file)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/tables/RQ1/px-tabs/%s", file)
    rawHTML <- paste(readLines(file), collapse="\n")
  })
  

  ### RQ2 Overview ------------------------------------------------------------
  
  output$rq2_box1Text <- renderText({
    return("After you choose a group of emotions and an emotion regulation goal, you will see 
             plots that demonstrate individual differences in models that include interactions between goals and current emotion levels (i.e. 
             goal-directed regulation; RQ2). If you want to zoom into specific participants'
             goal-directed systems, please see the next tabs.")
  })
  
  output$rq2_box2Plot <- renderText({
    # pulling figure file 
    # input$focal3, input$exclusion3, input$er_exc3 
    focal4 <- mapvalues(input$focal4, c("Focal", "Supplementary"), c("focal", "sup"), warn_missing = F)
    exc4 <- mapvalues(input$exclusion4, c("Parameter-Based Exclusion", "Person-Based Exclusion"), c("parameter", "person"), warn_missing = F)
    er_exc4 <- mapvalues(input$er_exc4, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    ergoal4 <- mapvalues(input$ergoal4, paste("Goal to Change", c("Positive", "Negative"), "Emotions"), c("goalPos", "goalNeg"), warn_missing = F)
    
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/plots/RQ2-int/%s-%s-%s-%s.png", ergoal4, focal4, exc4, er_exc4)
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.5
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$rq2_box2Text <- renderText({
    return("Each line represents predicted attractor location (i.e., level of emotion where 
             change is predicted to be zero) and strength (i.e., slope of the line). Attractor 
             Location is defined as Emotion State Level where Emotion State Change is expected 
             to be 0.")
  })
  
  output$rq2_box3Tab <- renderText({
    # tabSx-rq2int-focal-person-er-ma.html
    focal4 <- mapvalues(input$focal4, c("Focal", "Supplementary"), c("focal", "sup"), warn_missing = F)
    exc4 <- mapvalues(input$exclusion4, c("Parameter-Based Exclusion", "Person-Based Exclusion"), c("parameter", "person"), warn_missing = F)
    er_exc4 <- mapvalues(input$er_exc4, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/tables/RQ2-int/key-terms/tabSx-rq2int-%s-%s-%s-ma.html", focal4, exc4, er_exc4)
    rawHTML <- paste(readLines(file), collapse="\n")
  })
  
  
  ### RQ2b - Idio -------------------------------------------------------------
  
  output$rq2b_box1Text <- renderText({
    return("After you choose an emotion and emotion regulation goal, you will see be able to choose a participant ID. Then, you'll see 
             plots that demonstrate models that include interactions between goals and current emotion levels (i.e. 
             goal-directed regulation; RQ2).Green = Change in line with goal; Yellow = Non-significant change; Red = Change counter to goal")
  })  
  
  output$rq2b_box2Plot <- renderText({
    # pulling plot object
    # input$focal3, input$exclusion3, input$er_exc3 
    validate(need(input$SID6, '\nPlease select a Participant ID'))
    er_exc6 <- mapvalues(input$er_exc6, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    ergoal6 <- mapvalues(input$ergoal6, paste("Goal to Change", c("Positive", "Negative"), "Emotions"), c("goalPos", "goalNeg"), warn_missing = F)
    sid6 <- input$SID6
    print(paste(er_exc6, ergoal6, sid6, input$emo6))
    file <- rq2_int_plot_subs %>% filter(SID == sid6 & emo_item == input$emo6 & er_exc == er_exc6 & ergoal == ergoal6) %>% pull(file)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/plots/RQ2-int/px-traj/png/%s", file)
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.5
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$rq2b_box2Text <- renderText({
    return("Each line represents predicted attractor location (i.e., level of emotion where 
             change is predicted to be zero) and strength (i.e., slope of the line). Attractor 
             Location is defined as Emotion State Level where Emotion State Change is expected 
             to be 0.")
  })
  
  output$rq2b_box3Tab <- renderText({
    # tabSx-sup-rq1-parameter-er-ma.html
    validate(need(input$SID6, '\nPlease select a Participant ID'))
    validate(need(input$emo6, 'Please select an Emotion'))
    er_exc6 <- mapvalues(input$er_exc6, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    ergoal6 <- mapvalues(input$ergoal6, paste("Goal to Change", c("Positive", "Negative"), "Emotions"), c("goalPos", "goalNeg"), warn_missing = F)
    sid6 <- input$SID6
    file <- rq2_int_plot_subs %>% filter(SID == sid6 & emo_item == input$emo6 & er_exc == er_exc6 & ergoal == ergoal6) %>% pull(file)
    file <- str_replace_all(file, ".png", ".html")
    print(file)
    # file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/plots/RQ1/px-traj/png/%s", file)
    file <- sprintf("https://github.com/beck-lab/erdyn/raw/main/05-results/tables/RQ2-int/px-tabs/%s", file)
    print(file)
    rawHTML <- paste(readLines(file), collapse="\n")
  })
  
  ### Time Series Plots -------------------------------------------------------------
  
  output$ts_box1Text <- renderText({
    return("After you choose an emotion, you will see be able to choose a participant ID. Then, you'll see 
             plots that demonstrate models that demonstrate how emotion and change in emotion unfold across time, which 
             is another common visualizaiton in dynamic systems. Figure S1 Below demonstrates the relationship between these 
           plots and the change as outcome figures used in the main manuscript")
  })  
  
  output$ts_box2Text <- renderText({
    return("<strong>Figure S1</strong>. <em>Emotion and Emotion State Change predicted time. Emotion State change  
             was derived from model predictions. The dashed line on the Emotion State Change plot in the point at which 
           the expected change is zero.")
  })
  
  output$ts_box2Plot <- renderText({
    # pulling plot object
    file <- "https://github.com/beck-lab/erdyn/raw/main/05-results/plots/Fig-S1.png"
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.5
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$ts_box3Plot <- renderText({
    # pulling plot object
    # input$focal3, input$exclusion3, input$er_exc3 
    validate(need(input$SID7, '\nPlease select a Participant ID'))
    sid7 <- input$SID7
    er_exc7 <- mapvalues(input$er_exc7, c("All Data", "Emotion Regulation Events"), c("all", "er"), warn_missing = F)
    file <- ts_subs %>% filter(SID == sid7 & emo_item == input$emo7) %>% pull(file)
    file <- sprintf("https://github.com/beck-lab/erdyn/blob/main/05-results/plots/time-series/png/%s?raw=true", file)
    print(file)
    dims <- image_info(image_read(file))
    screen_wdth <- shinybrowser::get_width()
    img_wdth <- screen_wdth*.5
    img_ht <- (img_wdth*dims$height)/dims$width
    return(c('<center><img src="',file,'" width="', img_wdth, '" height="', img_ht,'"></center>', sep = ""))
    # "
  })
  
  output$ts_box4Text <- renderText({
    return('<p>
      This table summarizes the percentage of participants who showed at least one
      return episode. A return episode was defined as a transition into a near-zero
      derivative region around the estimated attractor. Specifically, a return was
      counted when the model-implied absolute rate of change was small
      (<span class="math">|dE/dt| &lt; .25</span>) and the prior occasion was not
      already within this range. Thus, consecutive observations within the near-zero
      region were treated as part of the same return episode rather than counted as
      repeated returns.
    </p>
    
    <p>
      Across specifications, return episodes were common. Return episodes were
      generally more common for positive than negative emotion, and percentages
      varied somewhat across model specifications and exclusion rules.
    </p>')
  })
  
  output$ts_box4Tab <- renderText({
    file <- "https://github.com/beck-lab/erdyn/raw/refs/heads/main/05-results/tables/tab-s2-returns.html"
    print(file)
    rawHTML <- paste(readLines(file), collapse="\n")
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
