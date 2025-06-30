remotes::install_github("abelbrasil/PaSim")
library(PaSim)

SIM <- download.SIM(inicio = 2023, fim = 2023, UF = "CE")

SIML <- process.SIM(SIM)

fSIM <- panel.SIM(SIML)

dCIDB <- CID

dCIDT <- CID

dMUN <- CADMUN

rm(SIM, SIML)

save.image("database.Rdata")
