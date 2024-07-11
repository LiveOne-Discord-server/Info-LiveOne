# Load necessary libraries
library(stringr)

# Function to simulate basic grammar correction
correct_grammar <- function(text) {
  # This is a very simplistic correction, just for demonstration
  text <- str_replace_all(text, "\\bi\\b", "I")
  text <- str_replace_all(text, "\\bdont\\b", "don't")
  text <- str_replace_all(text, "\\bwont\\b", "won't")
  text <- str_replace_all(text, "\\bim\\b", "I'm")
  
  return(text)
}

# Simulate receiving messages and correcting them
messages <- c(
  "i dont know what to do",
  "im going to the store",
  "they wont be here today"
)

for (msg in messages) {
  corrected <- correct_grammar(msg)
  if (msg != corrected) {
    cat("Original:", msg, "\n")
    cat("Corrected:", corrected, "\n\n")
  }
}