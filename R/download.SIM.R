#' Download SIM
#'
#' @param inicio The year that start the files extract.
#' @param fim The year that finish the files extract. By default the last year. Can't be the current year.
#' @param UF The state acronym.
#' @seealso \code{\link{process.SIM} \link{panel.SIM}}
#'
#' @return A data frame with the filtered raw SIM data.
#' @author Luan Augusto, \email{luanguto87@gmail.com}
#' @export
#'
#' @examples
#' ce <- download.SIM(2022,UF="  CE")
download.SIM <- function(inicio,fim,UF="all",cod_estab="") {
  require(read.dbc)
  require(dplyr)
  require(lubridate)

  urls <- c()

  db <- c()



  if (fim==as.numeric(format(Sys.Date(), "%Y"))){
    stop("Error: Not is possible download file of the current year")
  }
  anos <- c(inicio:fim)
  for (i in anos) {
    if(i==as.numeric(format(Sys.Date(), "%Y"))-1){
      if (UF=="all"){
        url <- paste0("ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DO",TABUF$SIGLA_UF,i,".dbc")
      }
      else
        url <- paste0("ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DO",UF,i,".dbc")
    }
    else
      if (UF=="all"){
        url <- paste0("ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DO",TABUF$SIGLA_UF,i,".dbc")
      }
    else
      url <- paste0("ftp://ftp.datasus.gov.br/dissemin/publicos/SIM/CID10/DORES/DO",UF,i,".dbc")
    urls <- append(urls,url)
  }
  for (i in 1:length(urls)) {
    temp <- tempfile(fileext = ".dbc")
    download.file(urls[i], destfile = temp, mode = "wb", method = "libcurl")
    data <- read.dbc(temp)
    db <- bind_rows(db,data)
  }

  return(db)
}
