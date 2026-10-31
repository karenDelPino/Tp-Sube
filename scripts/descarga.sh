#!/bin/bash

# =====================================================================
# SCRIPT: descarga.sh
# Descarga automáticamente el dataset_sube SUBE de la fuente oficial
# y transforma la fecha en año, mes y día de la semana.
# =====================================================================

echo "==============================================="
echo "DESCARGA Y LIMPIEZA DE DATOS SUBE"
echo "==============================================="

# PASO 1: Crear carpeta datos
echo ""
echo "PASO 1: Crear carpeta 'datos'..."

mkdir -p datos
echo "  ✓ Carpeta 'datos' creada"

# PASO 2: DESCARGAR del servidor oficial
echo ""
echo "PASO 2: Descargar dataset_sube desde servidor SUBE..."

URL="https://archivos-datos.transporte.gob.ar/upload/Sube/total-usuarios-por-dia-AMBA.csv"

# Usar curl o wget (lo que este disponible)
if command -v curl &> /dev/null; then
    echo "  Usando curl..."
    curl -L -o datos/dataset_sube_original.csv "$URL"
elif command -v wget &> /dev/null; then
    echo "  Usando wget..."
    wget -O datos/dataset_sube_original.csv "$URL"
else
    echo "  ❌ ERROR: Necesitas curl o wget instalado"
    exit 1
fi

# Verificar que descargo correctamente
if [ -f "datos/dataset_sube_original.csv" ]; then
    echo "  ✓ Archivo descargado correctamente"
else
    echo "  ❌ Error al descargar. Verifica tu conexion a internet"
    exit 1
fi

# PASO 3: Limpiar y transformar datos
echo ""
echo "PASO 3: Transformar datos (extraer anio, mes y dia de la semana)..."

python3 -c "
import csv
from datetime import datetime

with open('datos/dataset_sube_original.csv', mode='r', encoding='utf-8') as infile, \
     open('datos/dataset_sube.csv', mode='w', encoding='utf-8', newline='') as outfile:
    
    reader = csv.DictReader(infile)
    fieldnames = ['colectivo_amba', 'subte_amba', 'tren_amba', 'anio', 'mes', 'dia_semana']
    writer = csv.DictWriter(outfile, fieldnames=fieldnames)
    
    writer.writeheader()
    for row in reader:
        dt = datetime.strptime(row['indice_tiempo'].strip(), '%Y-%m-%d')
        writer.writerow({
            'colectivo_amba': row['colectivo_amba'].strip(),
            'subte_amba': row['subte_amba'].strip(),
            'tren_amba': row['tren_amba'].strip(),
            'anio': dt.year,
            'mes': dt.month,
            'dia_semana': dt.weekday()  # 0 = Lunes, 6 = Domingo
        })
"
# Comprobar si Python pudo procesar el archivo correctamente
if [ $? -ne 0 ]; then
    echo "  ❌ ERROR: Ocurrio un fallo en Python (Asegurate de cerrar RStudio o Excel si tienen el archivo abierto)."
    exit 1
fi

echo "  ✓ Datos transformados y guardados en 'datos/dataset_sube.csv'"

# PASO 4: Verificar
LINEAS=$(wc -l < datos/dataset_sube.csv)
echo "  ✓ Total de lineas: $LINEAS"

echo ""
echo "Primeras 5 lineas del dataset_sube:"
head -5 datos/dataset_sube.csv

# PASO 5: Resumen
echo ""
echo "==============================================="
echo "PROCESO COMPLETADO"
echo "==============================================="
echo ""
echo "Archivos generados:"
echo "  • datos/dataset_sube_original.csv (archivo original descargado)"
echo "  • datos/dataset_sube.csv (archivo limpio, LISTO PARA R)"
echo ""
echo "Proximo paso en RStudio:"
echo "  datos <- read.csv('datos/dataset_sube.csv')"
echo ""