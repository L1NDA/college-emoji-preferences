#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(markdown)
library(ggthemr)
library(wordcloud2)
library(igraph)
library(networkD3)
ggthemr('dust')

tab2 <- fluidPage(h1("Overall top emoji use, weighed by number of occurences"),
                  h3("Click on a word to see specific details."),
                  wordcloud2Output('wordcloud2', height="600px", width = "100%"),
                      tags$script(HTML(
                        "$(document).on('click', '#canvas', function() {",
                        'word = document.getElementById("wordcloud2wcSpan").innerHTML;',
                        "Shiny.onInputChange('selectedWord', word);",
                        "});"
                      )))

ui <- navbarPage("The Language of Emojis",
         tabPanel("About The Project",
                  fluidPage(uiOutput('aboutText'))),
          tabPanel("Overall emoji use", tab2),
          tabPanel("The network of emojis", fluidPage(
            h1("Connections between emoji usages"),
            h3("Drag the vertices to inspect the network."),
            forceNetworkOutput(outputId = "network"))),
          tabPanel("About The Author",
                              fluidPage(uiOutput('aboutAuthor'))),
          fluid = TRUE,
          includeCSS("./www/emojis.css")
)

