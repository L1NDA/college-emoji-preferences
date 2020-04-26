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

# aboutText <- includeMarkdown("about-text.Rmd")

tab2 <- fluidPage(wordcloud2Output('wordcloud2', width="100%", height="600px"),
        tags$script(HTML(
          "$(document).on('click', '#canvas', function() {",
          'word = document.getElementById("wordcloud2wcSpan").innerHTML;',
          "Shiny.onInputChange('selectedWord', word);",
          "});"
        )))

ui <- navbarPage("The Language of Emojis",
                 tabPanel("About this project", uiOutput('aboutText')),
                 tabPanel("Overall emoji use", tab2),
                 tabPanel("Emoji use by concentration")
)

