#!/bin/bash

# =====================================================================
# SCRIPT: descarga.sh
# Descarga el dataset SUBE (usuarios por día en el AMBA) de la fuente
# oficial y genera una versión limpia lista para R.
#
# Ejecutar desde la RAÍZ del proyecto:   bash scripts/descarga.sh
#
# Genera:
#   datos/crudos/dataset_sube_original.csv   (archivo original, sin tocar)
#   datos/procesados/dataset_sube.csv        (archivo limpio)
#
# IMPORTANTE: los valores son USUARIOS por día, no viajes.
#   - colectivo_amba, subte_amba, tren_amba: usuarios de cada modo.
#   - total_amba: usuarios únicos. Es menor que la suma de los tres
#     modos, porque quien usa dos modos el mismo día cuenta una sola vez.
# La fuente no tiene todos los días (faltan, por ejemplo, agosto 2022 y
# enero 2024), por eso guardamos la fecha real y nunca la recalculamos.
# =====================================================================

set -e

URL="https://archivos-datos.transporte.gob.ar/upload/Sube/total-usuarios-por-dia-AMBA.csv"
CRUDO="datos/crudos/dataset_sube_original.csv"
LIMPIO="datos/procesados/dataset_sube.csv"

echo "==============================================="
echo "DESCARGA Y LIMPIEZA DE DATOS SUBE"
echo "==============================================="

# PASO 1: Crear carpetas
echo ""
echo "PASO 1: Crear carpetas de datos..."
mkdir -p datos/crudos datos/procesados
echo "  ✓ Carpetas 'datos/crudos' y 'datos/procesados' listas"

# PASO 2: Descargar del servidor oficial
echo ""
echo "PASO 2: Descargar dataset desde el servidor oficial..."

if command -v curl &> /dev/null; then
    echo "  Usando curl..."
    curl -fL -o "$CRUDO" "$URL"
elif command -v wget &> /dev/null; then
    echo "  Usando wget..."
    wget -O "$CRUDO" "$URL"
else
    echo "  ❌ ERROR: Necesitas curl o wget instalado"
    exit 1
fi

if [ -s "$CRUDO" ]; then
    echo "  ✓ Archivo descargado: $CRUDO"
else
    echo "  ❌ Error al descargar. Verifica tu conexion a internet"
    exit 1
fi

# PASO 3: Limpiar y transformar
echo ""
echo "PASO 3: Transformar datos (fecha real, anio, mes y dia de la semana)..."

python3 - "$CRUDO" "$LIMPIO" <<'PYTHON'
import csv
import sys
from datetime import datetime

origen, destino = sys.argv[1], sys.argv[2]
campos = ['fecha', 'anio', 'mes', 'dia_semana',
          'colectivo_amba', 'subte_amba', 'tren_amba', 'total_amba']

filas = {}
with open(origen, mode='r', encoding='utf-8-sig') as infile:
    for row in csv.DictReader(infile):
        dt = datetime.strptime(row['indice_tiempo'].strip(), '%Y-%m-%d')
        # Si una fecha viniera repetida, nos quedamos con la última
        filas[dt] = {
            'fecha': dt.strftime('%Y-%m-%d'),
            'anio': dt.year,
            'mes': dt.month,
            'dia_semana': dt.weekday(),  # 0 = Lunes, 6 = Domingo
            'colectivo_amba': row['colectivo_amba'].strip(),
            'subte_amba': row['subte_amba'].strip(),
            'tren_amba': row['tren_amba'].strip(),
            'total_amba': row['total_amba'].strip(),
        }

with open(destino, mode='w', encoding='utf-8', newline='') as outfile:
    writer = csv.DictWriter(outfile, fieldnames=campos)
    writer.writeheader()
    for dt in sorted(filas):
        writer.writerow(filas[dt])

fechas = sorted(filas)
huecos = [(a, b) for a, b in zip(fechas, fechas[1:]) if (b - a).days > 1]
print(f"  Filas: {len(fechas)}  |  Desde {fechas[0]:%d/%m/%Y} hasta {fechas[-1]:%d/%m/%Y}")
for a, b in huecos:
    print(f"  ⚠ Faltan datos entre {a:%d/%m/%Y} y {b:%d/%m/%Y} ({(b - a).days - 1} días)")
PYTHON

echo "  ✓ Datos guardados en '$LIMPIO'"

# PASO 4: Verificar
echo ""
echo "Primeras 5 lineas:"
head -5 "$LIMPIO"

echo ""
echo "==============================================="
echo "PROCESO COMPLETADO"
echo "==============================================="
echo "Proximo paso en RStudio:"
echo "  datos <- readr::read_csv(here::here('datos', 'procesados', 'dataset_sube.csv'))"
echo ""
