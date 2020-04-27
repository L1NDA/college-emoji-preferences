#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(knitr)
library(emojifont)
library(wordcloud2)
library(scales)

emoji_data <- read_csv("data-cleaned.csv",
                       col_types = cols(
                           time = col_character(),
                           confirm = col_character(),
                           all_emojis = col_character(),
                           year = col_double(),
                           gender = col_character(),
                           house = col_character(),
                           ethnicity = col_character(),
                           residence = col_character(),
                           concentration = col_character(),
                           secondary = col_character(),
                           email = col_character()
                       ))

# Pivoting table wider so that there is one column for each emoji

emoji_data$all_emojis <- str_split(emoji_data$all_emojis, ",")
emoji_data$all_emojis <- gsub("[^[:alnum:]_,]", "", emoji_data$all_emojis)
emoji_data$all_emojis <- sub(".", "", emoji_data$all_emojis)

emoji_data_separated <- emoji_data %>%
    separate(all_emojis, c("first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"), 
             sep=",", extra="drop")

# Pivoting longer to create table with emoji use and order

emoji_data_longer <- emoji_data_separated %>%
    pivot_longer(names_to = "position", 
                 values_to = "emoji_name",
                 cols = c("first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth"))

emoji_summarized <- emoji_data_longer %>%
    group_by(position, emoji_name) %>%
    summarize(count = n()) %>%
    arrange(emoji_name) %>%
    filter(count > 1)

emoji_data_total <- emoji_data_longer %>%
    group_by(emoji_name) %>%
    summarize(count = n())

emoji_data_total$emoji_name <- gsub("_", " ", emoji_data_total$emoji_name)

emoji_data_specifics <- emoji_data_longer

emoji_data_specifics$emoji_name <- gsub("_", " ", emoji_data_specifics$emoji_name)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    output$aboutText <- renderUI({
        HTML(markdown::markdownToHTML(knit('about-text.Rmd', quiet = TRUE)))
    })
    
    output$wordcloud2 <- renderWordcloud2({
        wordcloud2(data = emoji_data_total, 
                   fontFamily = "sans-serif", 
                   color = rep_len(c("salmon","lightpink", "lightblue", "orange"), 
                                  nrow(emoji_data_total)))
    })
    
    observeEvent(input$selectedWord, {
        cleanedInput <- gsub(":.*","",isolate(input$selectedWord))
        showModal(modalDialog(
            title = "Emoji-specific Information",
            tags$img(
                src = base64enc::dataURI(file = paste0("./emoji-imgs/", cleanedInput, ".png"),
                                         mime = "image/png"),
                height = "50px",
                align = "center"),
            renderText(cleanedInput),
            selectInput("demographic", "", c("gender", "concentration", "year")),
            renderPlot({
                demographic <- input$demographic

                ggplot(emoji_data_specifics %>%
                            filter(emoji_name == cleanedInput), aes_string(demographic)) +
                    geom_bar() +
                    theme_classic() +
                    scale_y_continuous(breaks = pretty_breaks()) + 
                    coord_flip()
                    
            }),
            easyClose = TRUE,
            footer = NULL
        ))
    })
    

    output$emojiPlot <- renderPlot({
        
        ggplot(emoji_summarized %>% 
                   filter(position == input$variable), 
                    aes(x = emoji_name, y = count)) + 
        geom_col() +
        coord_flip() +
        expand_limits(y = 0) + 
        scale_y_continuous(breaks=c(1:12)) +
        labs(title = paste("Frequency of", input$variable, "most commonly used emojis"),
             subtitle = paste("Of all emojis with a count > 2 in the", input$variable, "position"),
             y = "Count",
             x = "Emoji Name") +
        theme_classic() + 
        theme(legend.position="none")
        
    })

})
