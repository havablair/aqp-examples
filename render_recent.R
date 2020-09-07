
# list files in working directory, create df
files <- list.files() %>% 
  as.data.frame() %>% 
  dplyr::rename("file_name" = ".")

# keep only .Rmd files
rmds <- files %>% 
  dplyr::filter(stringr::str_detect(file_name, ".Rmd")) %>% 
  dplyr::mutate(file_name = as.character(file_name))

# interested in mtime (time modified)
rmd_info <- file.info(rmds$file_name)

# sort descending so most recent mod is first
rmd_desc <- rmd_info %>%
  arrange(desc(mtime)) %>% 
  tibble::rownames_to_column(var = "file_name")

# grab target filename
target <- rmd_desc[1,1]

out_file <- str_replace(target, ".Rmd", ".html")


rmarkdown::render(target,
                  output_format = "html_document",
                  output_dir = "./docs", 
                  output_yaml = "_output.yml")


