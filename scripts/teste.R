remove.packages(PaSim)
remotes::install_github("abelbrasil/PaSim")
library(PaSIM)

SIM2 <- download.SIM(uf = "CE", period = (2010:2023))

download.SIM(uf = "CE", period = (2019:2023))

SIM2L <- process.SIM(SIM2)

base <- SIM2L %>%
    filter(FAIXA_ETARIA=="<1 ano")

table(SIM3$FAIXA_ETARIA)

fSIM <- panel.SIM(SIM2L)

save("fSIM","CID", file = "dataset.Rdata")
