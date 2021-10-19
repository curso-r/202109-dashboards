separar <- function(tab, coluna) {
  tab |> 
    pull({{coluna}}) |> 
    stringr::str_split(", ") |> 
    purrr::flatten_chr()
}

separar_e_contar_distintos <- function(tab, coluna) {
  tab |> 
    separar(coluna)|> 
    n_distinct()
}