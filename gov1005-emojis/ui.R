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

tab2 <- fluidPage(h1("What are Harvard students' most-used emojis?"),
                  h3("Click on a label to view specific details."),
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
          tabPanel("The World of Emojis", tab2),
          tabPanel("The Emoji Network", fluidPage(
            h1("Connections between emoji usages"),
            h3("Drag the vertices to inspect the network."),
            forceNetworkOutput(outputId = "network"))),
         tabPanel("The Language of Love", fluidPage(
           h1("The Language of Love"),
           h3("How do we express love in emojis, and how does this differ between us?"),
           p("While red hearts is by far the most often found in the top position for
             most commonly used emoji, it seems that, when taking the group of 10 most
             used emojis, hearts on faces is more preferred overall."),
           p("Taking into account the fact that twice as many females answered the
             survey, there is a relatively proportional split amongst gender for
             heart emoji preferences, with the exception of the heart eyes emoji,
             which males proportionally preferred more."),
           p("The respondents from class of 2021 preferred using red hearts
             twice as much, proportionally, than any of the other classes. There is is
             similar 100% increase of usage of the face with three hearts amongst
             the class of 2020. While no information was collected on social circles, there
             could be interaction effects at play from students picking up habits from
             close friends."),
           selectInput("heartgrouping", "Order By:", c("position", "gender", "year")),
           plotOutput('heartPlot', height = "1000px"),
         )),
         tabPanel("The Many Faces of Harvard",
                  h1("The Many Faces of Harvard"),
                  h3("What other correlations can be found in our data?"),
                  h2("Emoji Use by Year"),
                  plotOutput('emojiByYear', height = "600px"),
                  
                  h2("Emoji Use by House"),
                  plotOutput('emojiByHouse', height = "600px"),
                  
                  h2("Emoji Use by State"),
                  plotOutput('emojiByState', height = "600px"),
                  
                  h2("Emoji Use by Geder"),
                  plotOutput('emojiByGender')),
          tabPanel("About The Author",
                              fluidPage(uiOutput('aboutAuthor'))),
          fluid = TRUE,
          includeCSS("./www/emojis.css")
)

