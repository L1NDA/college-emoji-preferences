#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

ui <- fluidPage(
    
    titlePanel("Harvard Students x Most Frequently Used Emojis"),
    
    plotOutput("emojiPlot"),
    
    selectInput("variable", "Order:",
                               list("First" = "first", 
                                    "Second" = "second", 
                                    "Third" = "third",
                                    "Fourth" = "Fourth",
                                    "Fifth" = "Fifth",
                                    "Sixth" = "Sixth",
                                    "Seventh" = "Seventh",
                                    "Eighth" = "eighth",
                                    "Ninth" = "ninth",
                                    "Tenth" = "tenth")),
    
)

