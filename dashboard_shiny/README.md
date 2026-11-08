# Dashboard SUBE AMBA (Shiny + Quarto)

Dashboard interactivo de movilidad SUBE en el AMBA. Las tarjetas, los gráficos y la tabla se actualizan al mover los filtros.

Autoras: Valentina Barroso y Karen Del Pino.

## Cómo ejecutarlo

1. Instalá los paquetes (una sola vez), en la Console de RStudio:

```r
install.packages(c("tidyverse", "plotly", "shiny", "bslib", "bsicons", "DT", "quarto"))
```

2. Ubicá R en esta carpeta y ejecutá el dashboard:

```r
setwd("RUTA/A/dashboard_shiny")
quarto::quarto_serve("sube_reactivo.qmd")
```

3. Abrí en el navegador la dirección que aparece (http://127.0.0.1:XXXX).

Nota: al usar Shiny, el dashboard necesita R ejecutándose y no se puede publicar en GitHub Pages.
