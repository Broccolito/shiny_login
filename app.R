library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)

library(dplyr)
library(tibble)
library(openssl)

ui = fluidPage(
  title = "Event Scheduler",
  titlePanel(title = "Event Scheduler"),
  sidebarLayout(
    sidebarPanel = sidebarPanel(
      
      actionButton(inputId = "login",label = "Log In"),
      uiOutput(outputId = "welcome_sign")
      
    ),
    mainPanel = mainPanel(),
    fluid = TRUE,
    position = "left"
  )
)

server = function(input, output, session) {
  
  source("manage_user_list.R")
  logged_in <<- FALSE
  logged_in_user <<- ""

  observeEvent(input$login, {
    showModal(modalDialog(
      title = "Welcome to Event Scheduler",
      div(
        textInput(inputId = "username", label = "User Name"),
        textInput(inputId = "password", label = "Password"),
        actionButton(inputId = "login_user",label = "Log In"),
        actionButton(inputId = "signup_user",label = "Sign Up"),
        actionButton(inputId = "login_help",label = "Help")
      )
    ))
  })
  
  observeEvent(input$login_help,{
    showModal(modalDialog(
      title = "Log in as a Registered Member",
      div(
        p("As registered active CES memebers, please log in by using your official 
          name as the user name and your pre-set password as the password.")
      )
    ))
  })
  
  observeEvent(input$login_user, {
    user_list = read_user_list()
    if(any(user_list$user_name == input$username)){
      if(user_list[which(user_list$user_name == input$username),]$password == sha256(input$password)){
        logged_in_user <<- input$username
        logged_in <<- TRUE
        removeModal()
        
        output$welcome_sign = renderUI({
          div(
            br(),
            h5(paste0("Welcome ", logged_in_user,"!"))
          )
        })
        
      }
    }else{
      showModal(modalDialog(
        title = "User Not Exist",
        div(
          p("The user name that you input does not exist. Please retry.")
        )
      ))
    }
  })
  
  
  onSessionEnded(fun = stopApp)
}

shinyApp(ui, server)