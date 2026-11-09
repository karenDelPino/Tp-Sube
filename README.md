# SUBE AMBA: patrones de uso del transporte público

**Dashboard publicado:** https://karendelpino.github.io/Tp-Sube/

## Integrantes
- Valentina Barroso
- Karen Del Pino

## Resumen
Usamos los datos abiertos de la tarjeta SUBE (Ministerio de Transporte de la Nación)
con la cantidad de **usuarios por día** de colectivo, tren y subte en el AMBA, desde
enero de 2020. Buscamos responder cómo se usa cada modo de transporte, cómo cambia el uso
entre días hábiles y fines de semana, y cómo evolucionó desde la cuarentena de 2020.
Hicimos un análisis exploratorio en R (medidas de posición, histogramas, boxplots y
tablas de frecuencia) y un dashboard interactivo con Quarto.

**Sobre los datos:**
- Son *usuarios*, no viajes: una persona que viaja varias veces el mismo día en
  colectivo cuenta una sola vez.
- `total_amba` son usuarios únicos. Es menor que colectivo + tren + subte, porque
  quien combina dos modos el mismo día cuenta en los dos, pero una sola vez en el total.
- La fuente no tiene datos de agosto de 2022 ni de enero de 2024.

## Estructura del repositorio
```
├── datos/
│   ├── crudos/          # dataset_sube_original.csv, tal como se descarga
│   └── procesados/      # dataset_sube.csv, limpio (con fecha real)
├── scripts/             # descarga.sh: descarga y limpieza
├── reportes/            # sube-R.qmd: análisis exploratorio (PDF)
├── dashboard/           # dashboard estático (crosstalk), se publica en GitHub Pages
├── dashboard_shiny/     # versión con Shiny (necesita R, no va a GitHub Pages)
└── docs/                # sitio renderizado que publica GitHub Pages (no editar a mano)
```

## Cómo reproducir el proyecto
1. Clonar el repositorio:
   ```bash
   git clone https://github.com/karenDelPino/Tp-Sube.git
   cd Tp-Sube
   ```
2. Abrir `Tp-sube.Rproj` en RStudio.
3. Instalar las dependencias (una sola vez):
   ```r
   install.packages(c("tidyverse", "scales", "here", "plotly", "crosstalk", "DT"))
   # Solo para la versión Shiny:
   install.packages(c("shiny", "bslib", "bsicons", "quarto"))
   ```
4. Descargar y limpiar los datos (desde la raíz del proyecto; necesita `curl` o `wget` y `python3`):
   ```bash
   bash scripts/descarga.sh
   ```
5. Renderizar el reporte:
   ```bash
   quarto render reportes/sube-R.qmd
   ```
6. Renderizar el dashboard (el resultado queda en `docs/`):
   ```bash
   cd dashboard
   quarto render
   ```

## Publicar en GitHub Pages
1. Renderizar el dashboard (paso 6) y subir la carpeta `docs/` a la rama `main`.
2. En GitHub: **Settings → Pages → Build and deployment**, elegir
   *Deploy from a branch*, rama `main`, carpeta `/docs`, y guardar.
3. En unos minutos queda en https://karendelpino.github.io/Tp-Sube/

## Orden de ejecución
1. `scripts/descarga.sh`
2. `reportes/sube-R.qmd`
3. `dashboard/` (`quarto render`)
