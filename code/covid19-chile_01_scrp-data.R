library(here)
source(here("code","covid19-chile_00_libraries.R"))

covid19_html <- read_html('https://www.minsal.cl/nuevo-coronavirus-2019-ncov/casos-confirmados-en-chile-covid-19/')
# covid19_chile <- covid19_chile %>% html_nodes(css = 'table:nth-child(2) tr~ tr+ tr td')
# covid19_chile <- covid19_chile %>% html_nodes(css = '#main table:nth-child(1) tr~ tr+ tr td')
covid19_html <- covid19_html %>% html_nodes(css = 'table:nth-child(4) td , #main table:nth-child(1) tr~ tr+ tr td')
covid19_html <- covid19_html %>% html_text()


covid19_chile <- covid19_html  %>% head(-2)
covid19_chile <- covid19_chile %>% str_remove_all("\\.")
covid19_chile <- covid19_chile %>% matrix(ncol = 5, byrow = TRUE)
covid19_chile <- covid19_chile %>% as_tibble()
covid19_chile <- covid19_chile %>% set_colnames(covid19_chile %>% slice(1) %>% unlist %>% make_clean_names)
covid19_chile <- covid19_chile %>% tail(-1)
covid19_chile <- covid19_chile %>% rename(casos_fallecidos = "fallecidos")
covid19_chile <- covid19_chile %>% mutate_at(vars(starts_with('casos')), as.numeric)
covid19_chile <- covid19_chile %>% mutate(casos_recuperados = NA)
covid19_chile <- covid19_chile %>% inset2(17, 'casos_recuperados', covid19_html  %>% tail(1))
covid19_chile <- covid19_chile %>% mutate(fecha = Sys.Date())
covid19_chile <- covid19_chile %>% select(-fecha, -casos_fallecidos,  everything(), fecha, casos_fallecidos, -percent_casos_totales)

write_csv2(covid19_chile, here("data", paste0("covid19_chile_",Sys.Date(),".csv")))
