# SUBE AMBA: patrones de uso del transporte público

## Integrantes
- Valentina Barroso
- Karen Del Pino

## Resumen
Breve descripción (3 a 5 líneas): qué dataset usan (transacciones SUBE
en el AMBA), qué pregunta buscan responder y qué análisis realizan.

## Estructura del repositorio
```
├── datos/
│   ├── crudos/        # datos originales, sin modificar
│   └── procesados/    # datos limpios o resultados intermedios
├── scripts/           # descarga.sh y scripts de limpieza
└── reportes/          # sube R.qmd y sus salidas
```

## Cómo reproducir el proyecto
1. Clonar el repositorio:
```bash
   git clone https://github.com/USUARIO/REPO.git
   cd REPO
```
2. Abrir `Tp-sube.Rproj` en RStudio.
3. Instalar las dependencias:
```r
   install.packages(c("tidyverse", "here"))
```
4. Descargar los datos ejecutando el script desde la raíz del proyecto:
```bash
   bash scripts/descarga.sh
```
5. Renderizar el reporte:
```bash
   quarto render reportes/sube-R.qmd
```

## Orden de ejecución
1. `scripts/descarga.sh`
2. `reportes/sube-R.qmd`