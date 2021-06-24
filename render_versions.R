
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/index.Rmd',
                  output_dir = "docs")
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/summary.Rmd',
                  output_dir = "docs")

rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/data.Rmd',
                  output_dir = "docs",
                  params = list(cache = FALSE, optimize = TRUE))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/cases.Rmd',
                  output_dir = "docs",
                  params = list(cache = FALSE, optimize = TRUE))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/classifications.Rmd',
                  output_dir = "docs",
                  params = list(cache = FALSE, optimize = TRUE))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/sequences.Rmd',
                  output_dir = "docs",
                  params = list(cache = FALSE, optimize = FALSE))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/regressions.Rmd',
                  output_dir = "docs",
                  params = list(cache = FALSE, optimize = TRUE))

rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd',
                  output_dir = "docs",
                  output_file = "panel1995.html",
                  params = list(cache = FALSE, optimize = TRUE, begin = 1995, end = 2015, incl_new = FALSE, set_title = "Panel Regressions (1995-2015)"))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd',
                  output_dir = "docs",
                  output_file = "panel2lags.html",
                  params = list(cache = FALSE, optimize = TRUE, lags = 2, incl_new = FALSE, set_title = "Panel Regressions (2 lags)"))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd',
                  output_dir = "docs",
                  output_file = "panel3lags.html",
                  params = list(cache = FALSE, optimize = TRUE, lags = 3, incl_new = FALSE, set_title = "Panel Regressions (3 lags)"))
rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd',
                  output_dir = "docs",
                  params = list(cache = TRUE, optimize = TRUE))
