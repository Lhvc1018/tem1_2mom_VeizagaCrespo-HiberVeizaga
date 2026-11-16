"""Convierte el CSV original de Windows-1252 a UTF-8 para OpenCSVSerde."""

import csv
import sys
from pathlib import Path


if len(sys.argv) != 3:
    raise SystemExit("Uso: preparar_csv.py archivo_original.csv archivo_utf8.csv")

source, destination = map(Path, sys.argv[1:])
destination.parent.mkdir(parents=True, exist_ok=True)
rows = 0
with source.open("r", encoding="cp1252", newline="") as input_handle:
    reader = csv.reader(input_handle)
    header = next(reader)
    if len(header) != 21 or header[0] != "Row ID" or header[-1] != "Profit":
        raise ValueError("El archivo no corresponde a Sample Superstore con 21 columnas")
    with destination.open("w", encoding="utf-8", newline="") as output_handle:
        writer = csv.writer(output_handle)
        writer.writerow(header)
        for row in reader:
            if len(row) != 21:
                raise ValueError(f"La fila {rows + 2} contiene {len(row)} columnas")
            writer.writerow(row)
            rows += 1
print(f"Filas: {rows}; columnas: {len(header)}; salida: {destination}")
