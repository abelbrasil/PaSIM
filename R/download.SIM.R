#' Download SIM
#'
#' @param uf The state acronym.
#' @param periodo A vector with one or two value(s): Strings indicating the period at the start of the interval of the required publications in the format "YYYY".
#' @param dir A string indicating the output directory where the files will be stored (the default is the directory created within the User's Documents folder).
#' @param filename A string indicating the name of the file for the downloaded file (the default is constructed based on the input parameters from the directory of the user's Documents folder).
#'
#' @returns
#' @export
#'
#' @examples
download.SIM <- function(uf, periodo, dir = ".", filename = NULL) {

  if (!require(pacman)) {
    install.packages("pacman")
    library(pacman)
  }

  pacman::p_load(furrr, fs, curl, httr, data.table, tibble,
                 stringi, stringr, progressr, writexl, dplyr, openxlsx, readxl)

  # Move the 'read.dbc' folder to the user's library ++++++++++++++++++++++++++++

  if (file.exists(file.path(system.file(package = "read.dbc")))) {
    cat("O arquivo 'read.dbc' Já existe no diretório library do R. \n")
  } else {
    # Full path of the 'read.dbc' folder
    caminho_pasta <- system.file("Arquivos_externos", package = "PaSIM")
    caminho_completo <- file.path(caminho_pasta, "read.dbc")

    # Destination directory
    dest_dir <- file.path(system.file(package = "PaSIM"))
    dest_dir <- gsub('PaSIM','', dest_dir)

    # Move the file to the destination directory
    novo_caminho_completo <- file.path(dest_dir, "read.dbc")
    file.rename(caminho_completo, novo_caminho_completo)
    cat("O arquivo 'read.dbc' foi movido com sucesso para:", novo_caminho_completo, "\n")
  }

  # Directory and files +++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Set the destination directory to download files
  dir_destino <- file.path(dir, "SIM")

  # Check the existence of the directory destination, if not, create it
  if (!dir.exists(dir_destino)) {
    dir.create(dir_destino, recursive = TRUE)
    cat(paste0("O diretório ", dir_destino, " foi criado.\n"))
  }

  # Report the directory
  cat(paste0("Os arquivos serão salvos em: ", dir_destino, "\n"))

  # Transformation of parameters
  if (!is.vector(uf)) uf <- as.vector(uf)
  if (!is.vector(periodo)) periodo <- as.vector(periodo)

  # Base URL for the DATASUS site
  base_url <- "ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/"

  # Define the columns of the SIM dataframe
  SIM <- data.frame(UF = character(),
                    ANO = integer(),
                    stringsAsFactors = FALSE)

  # Loop through the values of uf and period to download the corresponding files
  for (i in 1:length(uf)) {
    for (j in 1:length(periodo)) {
      file_name <- paste0("DO", uf[i], periodo[j], ".DBC")
      file_path <- file.path(dir_destino, file_name)

      # Check if the file has already been downloaded
      if (!file.exists(file_path)) {
        # Check if the extension is .dbc or .DBC in the URL
        url <- stri_paste(base_url, file_name)
        if (!identical(httr::status_code(httr::GET(url)), 200L)) {
          file_name_alt <- paste0("DO", uf[i], periodo[j], ".dbc")
          url_alt <- stri_paste(base_url, file_name_alt)
          if (!identical(httr::status_code(httr::GET(url_alt)), 200L)) {
            cat(paste0("Arquivo ", file_name, " não encontrado. Tentando baixar...\n"))
            curl_download(url, file.path(dir_destino, file_name))
          } else {
            file_name <- file_name_alt
            url <- url_alt
          }
        } else {
          # Create a connection with the URL and download the file
          file_name_local <- stri_replace_last_fixed(file_name, ".dbc", ".DBC")
          curl_download(url, file.path(dir_destino, file_name_local))
        }
      }

      # Read the file and save it in a dataframe
      cat(paste0("Lendo o arquivo ", file_name, "\n"))
      file_ext <- tools::file_ext(file_path)

      if (file_ext == "dbc" | file_ext == "DBC") {
        file_df <- read.dbc::read.dbc(file_path)
      } else {
        cat(paste0("O arquivo ", file_name, " não está no formato DBC.\n"))
        next
      }

      # Add the columns UF and periodo
      file_df$UF <- uf[i]
      file_df$ANO <- periodo[j]

      # Add the data to the SIM dataframe
      SIM <- bind_rows(SIM, file_df)
    }
  }

  # Transfer the 'SIM' dataframe to the global environment
  #assign("SIM", SIM, envir = .GlobalEnv)

  return(SIM)

}
