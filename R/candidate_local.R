#' Download data on the candidates' background in local elections
#'
#' \code{candidate_local()} downloads and aggregates the data on the candidates' background who vied
#' local elections in Brazil. The function returns a \code{data.frame} where each observation
#' corresponds to a candidate.
#'
#' @note For the elections prior to 2000, some information can be incomplete.
#'
#' @param year Election year. For this function, onlye the years of 1996, 2000, 2004, 2008, and 2012
#' are available.
#'
#' @return \code{candidate_local()} returns a \code{data.frame} with the following variables:
#'
#' \itemize{
#'   \item DATA_GERACAO: Generation date of the file (when the data was collected).
#'   \item HORA_GERACAO: Generation time of the file (when the data was collected), Brasilia Time.
#'   \item ANO_ELEICAO: Election year.
#'   \item NUM_TURNO: Round number.
#'   \item DESCRICAO_ELEICAO: Description of the election.
#'   \item SIGLA_UF: Units of the Federation's acronym in which occurred the election.
#'   \item SIGLA_UE: Units of the Federation's acronym (In case of major election is the FU's
#'   acronym in which the candidate runs for (text) and in case of municipal election is the
#'   municipal's Supreme Electoral Court code (number)). Assume the special values BR, ZZ and
#'   VT to designate, respectively, Brazil, Overseas and Absentee Ballot.
#'   \item DESCRICAO_UE: Description of the Electoral Unit.
#'   \item CODIGO_CARGO: Code of the position that the candidate runs for.
#'   \item DESCRICAO_CARGO: Description of the position that the candidate runs for.
#'   \item NOME_CANDIDATO: Candidate's complete name.
#'   \item SEQUENCIAL_CANDIDATO: Candidate's sequence number generated internally by the electoral
#'   systems. It is not the candidate's campaign number.
#'   \item NUMERO_CANDIDATO: Candidate's number in the ballot box.
#'   \item CPF_CANDIDATO: Candidate's CPF.
#'   \item NOME_URNA_CANDIDATO: Candidate's ballot box name.
#'   \item COD_SITUACAO_CANDIDATURA: Code of the candidature situation.
#'   \item DES_SITUACAO_CANDIDATURA: Description of the candidature situation.
#'   \item NUMERO_PARTIDO: Party number.
#'   \item SIGLA_PARTIDO: Party acronym.
#'   \item NOME_PARTIDO: Party name.
#'   \item CODIGO_LEGENDA: Sequential code of the party shortname generated by the Electoral Justice.
#'   \item SIGLA_LEGENDA: Party's shortname acronym.
#'   \item COMPOSICAO_LEGENDA: Party's shortname composition.
#'   \item NOME_COLIGACAO: Coalition shortname.
#'   \item CODIGO_OCUPACAO: Candidate's occupation code.
#'   \item DESCRICAO_OCUPACAO: Candidate's occupation description.
#'   \item DATA_NASCIMENTO: Candidate's date of birth.
#'   \item NUM_TITULO_ELEITORAL_CANDIDATO: Candidate's ballot number.
#'   \item IDADE_DATA_ELEICAO: Candidate's age on the day of election.
#'   \item CODIGO_SEXO: Candidate's sex code.
#'   \item DESCRICAO_SEXO: Candidate's sex description.
#'   \item COD_GRAU_INSTRUCAO: Candidate's level of education code. Generated internally by the electoral systems.
#'   \item DESCRICAO_GRAU_INSTRUCAO: Candidate's level of education description.
#'   \item CODIGO_ESTADO_CIVIL: Candidate's marital status code.
#'   \item DESCRICAO_ESTADO_CIVIL: Candidate's marital status description.
#'   \item CODIGO_NACIONALIDADE: Candidate's nationality code.
#'   \item DESCRICAO_NACIONALIDADE: Candidate's nationality description.
#'   \item SIGLA_UF_NASCIMENTO: Candidate's Units of the Federation birth's acronym.
#'   \item COD_MUNICIPIO_NASCIMENTO: Candidate's birth city's Supreme Electoral Court code.
#'   \item COD_MUNICIPIO_NASCIMENTO: Candidate's birth city.
#'   \item DESPESA_MAX_CAMPANHA: Maximum expenditure campaign declared by the party to that position. Values in Reais.
#'   \item COD_SIT_TOT_TURNO: Candidate's totalization status code in that election round.
#'   \item DESC_SIT_TOT_TURNO: Candidate's totalization status description in that round.
#'   \item CODIGO_COR_RACA: Candidate's color/race code (self-declaration, only for 2014 election).
#'   \item DESCRICAO_COR_RACA: Candidate's color/race description (self-declaration, only for 2014 election).
#'   \item EMAIL_CANDIDATO: Candidate's e-mail adress (only for 2014 election).
#' }
#'
#' @import utils
#' @importFrom magrittr "%>%"
#' @export
#' @examples
#' \dontrun{
#' df <- candidate_local(2000)
#' }

candidate_local <- function(year){


  # Input tests
  test_local_year(year)

  # Downloads the data
  dados <- tempfile()
  sprintf("http://agencia.tse.jus.br/estatistica/sead/odsele/consulta_cand/consulta_cand_%s.zip", year) %>%
    download.file(dados)
  unzip(dados, exdir = paste0("./", year))
  unlink(dados)

  cat("Processing the data...")

  # Cleans the data
  setwd(as.character(year))
  banco <- juntaDados()
  setwd("..")
  unlink(as.character(year), recursive = T)

  # Changes variables names
  if(year < 2012){
    names(banco) <- c("DATA_GERACAO", "HORA_GERACAO", "ANO_ELEICAO", "NUM_TURNO", "DESCRICAO_ELEICAO",
                      "SIGLA_UF", "SIGLA_UE", "DESCRICAO_UE", "CODIGO_CARGO", "DESCRICAO_CARGO",
                      "NOME_CANDIDATO", "SEQUENCIAL_CANDIDATO", "NUMERO_CANDIDATO", "CPF_CANDIDATO",
                      "NOME_URNA_CANDIDATO", "COD_SITUACAO_CANDIDATURA", "DES_SITUACAO_CANDIDATURA",
                      "NUMERO_PARTIDO", "SIGLA_PARTIDO", "NOME_PARTIDO", "CODIGO_LEGENDA", "SIGLA_LEGENDA",
                      "COMPOSICAO_LEGENDA", "NOME_COLIGACAO", "CODIGO_OCUPACAO", "DESCRICAO_OCUPACAO",
                      "DATA_NASCIMENTO", "NUM_TITULO_ELEITORAL_CANDIDATO", "IDADE_DATA_ELEICAO",
                      "CODIGO_SEXO", "DESCRICAO_SEXO", "COD_GRAU_INSTRUCAO", "DESCRICAO_GRAU_INSTRUCAO",
                      "CODIGO_ESTADO_CIVIL", "DESCRICAO_ESTADO_CIVIL", "CODIGO_NACIONALIDADE",
                      "DESCRICAO_NACIONALIDADE", "SIGLA_UF_NASCIMENTO", "CODIGO_MUNICIPIO_NASCIMENTO",
                      "NOME_MUNICIPIO_NASCIMENTO", "DESPESA_MAX_CAMPANHA", "COD_SIT_TOT_TURNO",
                      "DESC_SIT_TOT_TURNO")

  } else {
    names(banco) <-c("DATA_GERACAO", "HORA_GERACAO", "ANO_ELEICAO", "NUM_TURNO", "DESCRICAO_ELEICAO",
                     "SIGLA_UF", "SIGLA_UE", "DESCRICAO_UE", "CODIGO_CARGO", "DESCRICAO_CARGO",
                     "NOME_CANDIDATO", "SEQUENCIAL_CANDIDATO", "NUMERO_CANDIDATO", "CPF_CANDIDATO",
                     "NOME_URNA_CANDIDATO", "COD_SITUACAO_CANDIDATURA", "DES_SITUACAO_CANDIDATURA",
                     "NUMERO_PARTIDO", "SIGLA_PARTIDO", "NOME_PARTIDO", "CODIGO_LEGENDA", "SIGLA_LEGENDA",
                     "COMPOSICAO_LEGENDA", "NOME_COLIGACAO", "CODIGO_OCUPACAO", "DESCRICAO_OCUPACAO",
                     "DATA_NASCIMENTO", "NUM_TITULO_ELEITORAL_CANDIDATO", "IDADE_DATA_ELEICAO",
                     "CODIGO_SEXO", "DESCRICAO_SEXO", "COD_GRAU_INSTRUCAO", "DESCRICAO_GRAU_INSTRUCAO",
                     "CODIGO_ESTADO_CIVIL", "DESCRICAO_ESTADO_CIVIL", "CODIGO_NACIONALIDADE",
                     "DESCRICAO_NACIONALIDADE", "SIGLA_UF_NASCIMENTO", "CODIGO_MUNICIPIO_NASCIMENTO",
                     "NOME_MUNICIPIO_NASCIMENTO", "DESPESA_MAX_CAMPANHA", "COD_SIT_TOT_TURNO",
                     "DESC_SIT_TOT_TURNO", "EMAIL_CANDIDATO")
  }

  cat("Done")
  return(banco)
}
