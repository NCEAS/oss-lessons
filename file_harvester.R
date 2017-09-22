## Constants ----

types_referred <- c("png", "jpg", "csv", "txt")


### Functions ----

duplicate.checker <- function(file_list, file_type){
  # Check for duplicated filenames
  nb_duplicates <- sum(duplicated(basename(file_list)))
  cat(sprintf("There are %i potential duplicates in %s files\n", nb_duplicates*2, file_type))
  #list the duplicates if any
  if (nb_duplicates > 0){
    cat(sprintf("Here are the potential duplicated %s files:\n", file_type))
    duplicates <- basename(file_list[duplicated(basename(file_list))])
    for (d in duplicates){
      cat(file_list[basename(file_list) == d])
      cat("\n")
    }
  }
}

file.lister <- function(file_extension){
  # Build the regular expression
  regex_str <- paste0('\\.', file_extension, '$')
  #list the files
  file_listing <- list.files(pattern = regex_str, recursive = T, include.dirs = T, full.names = TRUE)
  # Check for potential similar names between modules
  duplicate.checker(file_listing, file_extension)
  return(file_listing)
}

### MAIN ----

## List all the files ----

# Get all the markdown and Rmarkdown files
md_files <- file.lister("?md")
# write.csv(md_files, file.path(getwd(), "markdown_listing.csv"), col.names = FALSE)
# the index of meta-analysis is going to be problematic, renamed it
# system(sprintf("git mv %s %s", 
#                file.path(getwd(),"/meta-analysis/index.Rmd"), 
#                file.path(getwd(),"/meta-analysis/index-meta.Rmd")))

# Get the R codes
#list.files(pattern = '\\.R$', recursive = T, include.dirs = T, ignore.case = TRUE)

# List all the files potentially reffered to from a Markdown file
files_referred <- sapply(types_referred,file.lister)

# list all the images
images_files <- c(files_referred$png, files_referred$jpg)

# list all the data
data_files <- c(files_referred$csv, files_referred$txt)


## Create the necessary directories for consolidation ----

# Create the data directory
data_dir <- file.path(getwd(), "data")
dir.create(data_dir, showWarnings = FALSE)

# Create the images directory
images_dir <- file.path(getwd(), "images")
dir.create(images_dir, showWarnings = FALSE)


## Copy files to the respective directories ----

# Copy images 
lapply(images_files, file.copy, to=images_dir)

# Copy data 
lapply(data_files, file.copy, to=data_dir)
