library(tidyverse)
knitr::knit_hooks$set(webgl = rgl::hook_webgl)
if(params$optimize) {
  knitr::knit_hooks$set(optipng = knitr::hook_optipng)
  knitr::knit_hooks$set(pngquant = knitr::hook_pngquant)
  knitr::opts_chunk$set(optipng = "-o7")
}
knitr::opts_chunk$set(echo = TRUE, cache = params$cache,
                      fig.width = 7, fig.height = 5,
                      out.width = "67%", out.height = "67%",
                      rownames.print = FALSE,
                      rows.print = 10, cols.min.print = 10)
options(width = 240, max.print = 5000)
conflicted::conflict_prefer("filter", "dplyr")
