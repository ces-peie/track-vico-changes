# Load used packages
library(package = dplyr)

# Read in questionnaire definition files
questionnaire_set <- read.csv(file = "./structure/QuestionnaireSet.csv",
                              sep = "\t", stringsAsFactors = FALSE)
questionnaire <- read.csv(file = "./structure/Questionnaire.csv",
                          sep = "\t", stringsAsFactors = FALSE)
section <- read.csv(file = "./structure/Section.csv",
                    sep = "\t", stringsAsFactors = FALSE)
section_item <- read.csv(file = "./structure/SectionItem.csv",
                         sep = "\t", stringsAsFactors = FALSE)


# Annotate questions with Section, Questionnaire and QuestionnaireSet names
changes_table <- section_item %>%
  tbl_df %>%
  left_join(select(section, section_name = Name,
                   SectionID, QuestionnaireID)) %>%
  left_join(select(questionnaire, questionnaire_name = Name,
                   QuestionnaireID, QuestionnaireSetID)) %>%
  left_join(select(questionnaire_set, questionnaire_set_name = Name,
                   QuestionnaireSetID)) %>%
  mutate(ChangeType = "",
         Comments = "") %>%
  select(questionnaire_set_name, questionnaire_name, section_name,
         Number, MainText, HelpText, ChangeType, Comments, VariableName,
         SectionItemGuid, SectionID, Ordinal, Level, Visible, Type)


# Save annotated table
write.table(changes_table, file = "./changes/section-item-changes.csv",
            sep = "\t", quote = FALSE, row.names = FALSE)
