# Load used packages
library(package = dplyr)

# Read data
questions <- read.csv(file = "changes/section-item-changes.csv",
                      header = TRUE, sep = "\t", quote = "",
                      stringsAsFactors = FALSE)


# Fix question numbers
fixed_questions <- questions %>%
  filter(Type != "Variable") %>%
  group_by(SectionID) %>%
  arrange(Ordinal) %>% 
  # Label questions for each possible level
  mutate(fn1 = stats::filter(x = Level==1, 1, method = "rec")) %>% group_by(fn1, add = TRUE) %>%
  mutate(fn2 = stats::filter(x = Level==2, 1, method = "rec")) %>% group_by(fn2, add = TRUE) %>%
  mutate(fn3 = stats::filter(x = Level==3, 1, method = "rec")) %>% group_by(fn3, add = TRUE) %>%
  mutate(fn4 = stats::filter(x = Level==4, 1, method = "rec")) %>% group_by(fn4, add = TRUE) %>%
  mutate(fn5 = stats::filter(x = Level==5, 1, method = "rec")) %>% group_by(fn5, add = TRUE) %>%
  mutate(fn6 = stats::filter(x = Level==6, 1, method = "rec")) %>% group_by(fn6, add = TRUE) %>%
  mutate(fn7 = stats::filter(x = Level==7, 1, method = "rec")) %>% group_by(fn7, add = TRUE) %>%
  mutate(fn8 = stats::filter(x = Level==8, 1, method = "rec")) %>% group_by(fn8, add = TRUE) %>%
  mutate(fn9 = stats::filter(x = Level==9, 1, method = "rec")) %>% group_by(fn9, add = TRUE) %>%
  # Paste the numbers together and remove the trailing zeroes
  mutate(fixed_number = paste(fn1, fn2, fn3, fn4, fn5, fn6, fn7, fn8, fn9, sep = "."),
         fixed_number = sub("[.]0.*$", "", fixed_number)) %>%
  # Keep numbers for the hospital only
  filter(Number != fixed_number, questionnaire_set_name == "Hospital") %>%
  ungroup() %>% 
  select(SectionID, Ordinal, Level, fixed_number)


# Tag the questions with the fixed numbers
questions <- questions %>%
  left_join(fixed_questions) %>%
  mutate(Number = ifelse(!is.na(fixed_number), fixed_number, Number)) %>%
  select(-fixed_number)


# Update the changes table
write.table(x = questions, file = "changes/section-item-changes.csv",
            sep = "\t", row.names = FALSE, quote = FALSE)


# End of script
