#' Panel SIM
#'
#' @param data A data frame from SINASC with the columns needed for the Power BI dashboard.
#'
#' @returns
#' @export
#'
#' @examples
#' fSIM <- panel.SIM(db_label)
panel.SIM <- function(data) {
  require(dplyr)
  base <- data %>%
    select(`Tipo de Óbtito`= TIPOBITO, `Data do Óbito` = DTOBITO, `Hora do Óbito`=HORAOBITO, `Idade`=IDADEINT,`Faixa Etária`=FAIXA_ETARIA,

           `Código Município de Naturalidade`=CODMUNNATU,`Município de Naturalidade`=MUNNATU,`Data de Nascimento`=DTNASC,`UF de Naturalidade`=UFNATU, `Região de Ocorrência`=REGIAO_OCOR, `Região de Residência`=REGIAO_RES,`Vínculo`=VINCULO,

           `Sexo`=SEXO,`Estado Civil` = ESTCIV,`Anos de Escolaridade` = ESC,`Código Ocupação`=OCUP, `Ocupação`=OCUPDESC,`Raça/Cor`=RACACOR, `Código Município de Residência`=CODMUNRES,

           `Município de Residência`= MUNRES, `UF de Residência`=UFRES,`Código do Estabelecimento`=CODESTAB,`Estabelecimento`=ESTAB,`Local de Ocorrência`=LOCOCOR, `Código Município de Ocorrência`=CODMUNOCOR, `Município de Ocorrência`=MUNOCOR, `UF de Ocorrência`=UFOCOR,`Peso`=PESO,`Faixa de Peso`=FAIXA_PESO,

           `Parto`=PARTO,`Semanas de Gestação`=SEMAGESTAC,`Gestação`=GESTACAO,`Gravidez`=GRAVIDEZ,`Óbito Parto`=OBITOPARTO, `Óbito na Gravidez`=OBITOGRAV,`Óbito durante o puerpério`=OBITOPUERP, `Situação Gestacional` = TPMORTEOCO,

           `Assistência Médica`=ASSISTMED, `Exame`=EXAME, `Cirurgia`=CIRURGIA, `Necropsia`=NECROPSIA, LINHAA, LINHAB, LINHAC, LINHAD, LINHAII, `Causa Básica`=CAUSABAS, `Causa Terminal`=TERM, `Circunstância`=CIRCOBITO,  `Fonte`=FONTE,`Acidente de Trabalho`=ACIDTRAB, `Óbito Investigado`=TPPOS,`Ano`=ANO,`Mês-Ano`=MES_ANO,`Idade da Mãe`= IDADEMAE,

           `Faixa Etária da Mãe`=FAIXA_ETARIA_MAE,`Anos de Escolaridade da Mãe` = ESCMAE,`Ocupação da Mãe`=OCUPMAEDESC,

           `Código Faixa Etária Mãe`=COD_FAIXA_ETARIA_MAE,`Código Faixa Peso`=COD_FAIXA_PESO,`Código Gestação`=COD_GESTACAO, `Código Gravidez`=COD_GRAVIDEZ, `Código Escolaridade`=COD_ESCOLARIDADE, `Código Escolaridade da Mãe`=COD_ESCOLARIDADE_MAE)

  return(base)
}
