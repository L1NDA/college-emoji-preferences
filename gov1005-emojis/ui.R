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

# Ggplot themes

library(ggthemr)

# Allows us to visualize the wordcloud

library(wordcloud2)

# Allows us to visualize the network

library(igraph)
library(networkD3)

# Setting the ggplot theme

ggthemr('dust')

# Rendering the wordcloud page

tab2 <- fluidPage(h1("What are Harvard students' most-used emojis?"),
                  
                  wordcloud2Output('wordcloud2', height="600px", width = "100%"),
                  p(""),
                  h3("Click on a label to view specific details."),
                      tags$script(HTML(
                        "$(document).on('click', '#canvas', function() {",
                        'word = document.getElementById("wordcloud2wcSpan").innerHTML;',
                        "Shiny.onInputChange('selectedWord', word);",
                        "});"
                      )))

# Creating a navbar with tabs for each page

ui <- navbarPage("The Language of Emojis",
                 tabPanel("About The Project",
                          fluidPage(uiOutput('aboutText'))),
                 
          # Wordcloud page
                 
          tabPanel("The World of Emojis", tab2),
          
          # Network page
          
          tabPanel("The Emoji Network", fluidPage(
            h1("Connections between emoji usages"),
            p("Edges were created between all emoji responses per participant to
              analyze the overall network of emoji usages. These edges are unweighted,
              and therefore do not represent the strength of connection, but do show
              cross-emoji interactions and correlations. Six groups have been denoted, each
              with a different color."),
            p("Interestingly enough, this network created from the data collected
              does to some extent represent expected relationships between emojis,
              such as the red heart node connecting to the face with heart eyes node,
              or the face with tears of joy node connecting to the weary face node, which 
              connects to the loudly crying face node. The red heart node has the most
              outgoing edges as it is one of the most commonly used emojis."),
            forceNetworkOutput(outputId = "network")),
            p(""),
            h3("Drag the vertices to inspect the network.")),
          
        # Hearts page  
          
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
             twice as much, proportionally, than any of the other classes. There is a
             similar 100% increase of usage of the face with three hearts amongst
             the class of 2020. While no information was collected on social circles, there
             could be interaction effects at play from students picking up habits from
             close friends."),
           p(" "),
           selectInput("heartgrouping", "Order By:", c("position", "gender", "year")),
           plotOutput('heartPlot', height = "1000px"),
         )),
        
        # Analysis by demographic page
        
         tabPanel("The Many Faces of Harvard",
                  h1("The Many Faces of Harvard"),
                  h3("What other correlations can be found in our data?"),
                  h2("Emoji Use by Year"),
                  p("Looking at the top percentage usages per class, it appears that freshmen and sophomores
                    have a larger share of their top emojis as negative emotions, such as the crying face, 
                    weary face, and grimacing face."),
                  plotOutput('emojiByYear', height = "600px"),
                  
                  h2("Emoji Use by State"),
                  p("Interestingly, each state has very distinctive emoji preferences.
                    Californians use the pleading face much more often compared to the other states,
                    while those from Massachusetts like to use the face with smiling eyes, New Yorkers
                    and face with tears of joy, and Texans with the face with steam from nose."),
                  plotOutput('emojiByState', height = "600px"),
                  
                  h2("Emoji Use by Gender"),
                  p("While emoji preferences were pretty similar between genders,
                    males preferred using the face with steam from nose, weary face, and
                    grimacing face, while females had a much higher usage of the pleading face."),
                  plotOutput('emojiByGender'),
                  
                  h2("Emoji Use by House"),
                  p("The original goal of analyzing by house was to see whether a difference
                    existed with river vs. quad housing respondents. Unfortunately, not enough
                    data was gathered on quad residents to conduct a meaningful analysis."),
                  plotOutput('emojiByHouse', height = "600px")),
          fluid = TRUE,
        
          # Custom CSS
        
          includeCSS("./www/emojis.css")
)

