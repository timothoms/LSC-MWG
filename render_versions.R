rmarkdown::render_site('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd')

rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd', output_dir = "docs",
                  output_file = "panel1995.html",
                  params = list(set_title = "Panel Regressions (1995-2015)", cache = FALSE, begin = 1995, end = 2015, incl_new = FALSE))

rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd', output_dir = "docs",
                  output_file = "panel2lags.html",
                  params = list(set_title = "Panel Regressions (2 lags)", cache = FALSE, lags = 2, incl_new = FALSE))

rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd', output_dir = "docs",
                  output_file = "panel3lags.html",
                  params = list(set_title = "Panel Regressions (3 lags)", cache = FALSE, lags = 3, incl_new = FALSE))

rmarkdown::render('/Users/oskarntthoms/Documents/GitHub/LSC-MWG/panel.Rmd', output_dir = "docs",
                  output_file = "panel4lags.html",
                  params = list(set_title = "Panel Regressions (4 lags)", cache = FALSE, lags = 4, incl_new = FALSE))
