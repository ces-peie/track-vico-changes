#------------------------------------------------------------------------------*
# Prepare data management environment
#------------------------------------------------------------------------------*

# Load used packages
library(package = magrittr)
library(package = dplyr)



#------------------------------------------------------------------------------*
# Generate reference table
#------------------------------------------------------------------------------*


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


# Get all names for qm structure table
all_names <- read.table(
  file = "./structure/SectionItem.csv", header = TRUE, sep = "\t", nrows = 1
) %>% names



#------------------------------------------------------------------------------*
# Get recorded changes
#------------------------------------------------------------------------------*


recorded_changes <- read.delim(file = "./changes/section-item-changes.csv",
                               sep = "\t", quote = "", stringsAsFactors = FALSE)

recorded_changes <- tbl_df(recorded_changes[, names(changes_table)])



# Calculate an md5 digest for each row
old <- sapply(
  X = gsub("[[:space:]]+", "",
       apply(X = changes_table, MARGIN = 1, paste, collapse = "")),
  FUN = digest::digest,
  USE.NAMES = FALSE
)

new <- sapply(
  X = gsub("[[:space:]]+", "",
           apply(X = recorded_changes, MARGIN = 1, paste, collapse = "")),
  FUN = digest::digest,
  USE.NAMES = FALSE
)


# Match them (NA represents something new)
same_as_old <- match(new, old)


# Show the different ones and a little context (previous and next)
show <- is.na(same_as_old) |
        lag(is.na(same_as_old), default = FALSE) |
        lead(is.na(same_as_old), default = FALSE)


# Keep only changed items
all_changes <- recorded_changes %>%
  filter(is.na(same_as_old)) %>%
  select(SectionItemGuid, everything())


# Add all names
add_names <- setdiff(all_names, names(all_changes))

all_changes <- all_changes %>%
  cbind(
    # Empty dataframe with the missing columns
    as_data_frame(as.list(setNames(rep(NA, length(add_names)), add_names)))
  ) %>%
  select_(.dots = c(setdiff(names(all_changes), all_names), all_names))


changes_table <- changes_table %>%
  cbind(
    # Empty dataframe with the missing columns
    as_data_frame(as.list(setNames(rep(NA, length(add_names)), add_names)))
  ) %>%
  select_(.dots = c(setdiff(names(changes_table), all_names), all_names))



# Get new items
inserts <- all_changes %>%
  filter(SectionItemGuid == "") %T>%
  write.table(file = "changes/temp_inserts.csv",
              row.names = FALSE, sep = "\t", quote = FALSE)


# Get changed items
updates <- all_changes %>%
  filter(SectionItemGuid != "") %T>%
  write.table(file = "changes/temp_updates.csv",
              row.names = FALSE, sep = "\t", quote = FALSE)


# Get deleted items
deletes <- changes_table %>%
  filter(!SectionItemGuid %in% recorded_changes$SectionItemGuid) %T>%
  write.table(file = "changes/temp_deletes.csv",
              row.names = FALSE, sep = "\t", quote = FALSE)


