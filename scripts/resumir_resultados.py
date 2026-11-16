"""Resume tablas ASCII de Beeline para revisar respuestas."""

from pathlib import Path


for path in sorted(Path("data/resultados").glob("*.log")):
    text = path.read_text(encoding="utf-8", errors="replace")
    tables = []
    current = []
    for line in text.splitlines():
        if line.startswith("|") and line.endswith("|"):
            current.append([part.strip() for part in line[1:-1].split("|")])
        elif current and line.startswith("+"):
            continue
        elif current:
            tables.append(current)
            current = []
    if current:
        tables.append(current)
    print("\n", path.name, "tablas", len(tables))
    for index, table in enumerate(tables, 1):
        print("  ", index, "filas", len(table) - 1, "columnas", table[0])
        for row in table[1:6]:
            print("      ", row)
