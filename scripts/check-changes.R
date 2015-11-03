#------------------------------------------------------------------------------*
# Prepare data management environment
#------------------------------------------------------------------------------*

# Load used packages
library(package = magrittr)
library(package = tidyr)
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





#------------------------------------------------------------------------------*
# Write sql scripts to modify the questionnaire
#------------------------------------------------------------------------------*


# Define fields to be quoted
quote_fields <- data_frame(
  SectionItemGuid = TRUE, 
  SectionID = FALSE, 
  Ordinal = FALSE, 
  Level = FALSE, 
  Visible = FALSE, 
  Type = TRUE, 
  Number = TRUE, 
  MainText = TRUE, 
  GroupMember = FALSE, 
  GroupText = TRUE, 
  Condition = TRUE, 
  BranchIf = TRUE, 
  VariableName = TRUE, 
  ScreenTemplate = TRUE, 
  Arguments = TRUE, 
  VariableScope = FALSE, 
  Required = FALSE, 
  AbsMin = FALSE, 
  AbsMax = FALSE, 
  PromptUnder = TRUE, 
  PromptOver = TRUE, 
  LegalValueTable = TRUE, 
  CustomValidation = TRUE, 
  CustomValidationFailMessage = TRUE, 
  ConfirmChange = FALSE, 
  HideNext = FALSE, 
  HideBack = FALSE, 
  ConfirmNext = FALSE, 
  ConfirmBack = FALSE, 
  MainTextColor = TRUE, 
  HelpText = TRUE, 
  OtherText1 = TRUE, 
  OtherText1Color = TRUE, 
  OtherText2 = TRUE, 
  OtherText2Color = TRUE, 
  OtherText3 = TRUE, 
  OtherText3Color = TRUE, 
  Comment = TRUE, 
  OnLoad = TRUE, 
  OnUnload = TRUE, 
  OnChange = TRUE,
  OnBranch = TRUE
) %>% 
  gather(key = field, value = quote, convert = TRUE)



# Delete removed questions
deletes %>%
  with(
    cat(
      file = "./sql/apply_deletes.sqlce",
      paste0("DELETE FROM SectionItem WHERE SectionItemGuid = '",
                   SectionItemGuid, "';"),
      sep = "\n"
    )
  )



# Update modified questions

cat("--", as.character(Sys.time()), "questionnaire updates\n\n",
    file = "./sql/apply_updates.sqlce")

updates %>%
  select(-c(questionnaire_set_name:Comments)) %>%
  mutate(order = seq(1, n())) %>% 
  gather(field, value, -SectionItemGuid, -order, convert = TRUE) %>%
  arrange(order) %>%
  left_join(gather(changes_table, field, original_value, -SectionItemGuid,
                   convert = TRUE)) %>%
  filter(value != original_value) %>%
  group_by(SectionItemGuid) %>%
  mutate(order = min(order)) %>%
  left_join(quote_fields) %>%
  group_by(order, SectionItemGuid) %>%
  do(
    {
      with(.,
        cat(
          file = "./sql/apply_updates.sqlce", append = TRUE,
          paste0(
            "UPDATE SectionItem\n\tSET\n",
            paste0("\t\t", field, " = ",
                   if(quote) "'" else "",
                   value,
                   if(quote) "'" else "",
                   "\n"),
            "\tWHERE SectionItemGuid = '", first(SectionItemGuid), "';\n"
          ),
          sep = "\n\n"
        )
      )
      data_frame(processed = TRUE)
    }
  )





# Insert new questions

cat("--", as.character(Sys.time()), "questionnaire inserts\n\n",
    file = "./sql/apply_inserts.sqlce")

inserts %>%
  mutate(Comment = Comments) %>%
  select(-Comments) %>% 
  mutate_each_(funs(ifelse(is.na(.) | . == "", "NULL", .)),
               vars = names(.)) %>%
  mutate(id = paste(SectionID, Ordinal, sep = "-")) %>% 
  select(-c(questionnaire_set_name:ChangeType, SectionItemGuid)) %>%
  mutate(order = seq(1, n())) %>% 
  gather(field, value, -id, -order, convert = TRUE) %>%
  arrange(order) %>%
  group_by(id) %>%
  mutate(order = min(order)) %>%
  left_join(quote_fields) %>%
  group_by(order, id) %>%
  arrange(value == "NULL", field == "Comment") %>%
  do(
    {
      with(.,
           cat(
             file = "./sql/apply_inserts.sqlce", append = TRUE,
             paste0(
               "INSERT INTO SectionItem\n\t",
               "([SectionItemGuid], [", paste(field, collapse = "], ["), "])\n",
               "\tVALUES\n\t\t(\n\t\t",
               "NewId(), -- Generate GUID for new question\n\t\t",
               paste(
                 paste0(ifelse(quote & value != "NULL", "'", ""),
                        value,
                        ifelse(quote & value != "NULL", "'", ""),
                        ", -- ", field, "\n\t\t"),
                 collapse = ""
               ),
               ");\n"
             ),
             sep = "\n\n"
           )
      )
      data_frame(processed = TRUE)
    }
  )
