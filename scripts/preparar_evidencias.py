"""Construye consultas breves y el lote de capturas para CMD visible."""

from pathlib import Path


root = Path(__file__).resolve().parent.parent
query_dir = root / "data" / "evidencia_sql"
query_dir.mkdir(parents=True, exist_ok=True)
queries = [
    ("01_ubicacion", "DESCRIBE FORMATTED superstore_veizaga.ventas;"),
    ("01_carga", "SELECT COUNT(*) AS total_registros FROM superstore_veizaga.ventas;"),
    ("01_muestra", "SELECT row_id, order_id, order_date, ship_date, region, sales, profit FROM superstore_veizaga.ventas LIMIT 10;"),
]
for name, statement in queries:
    (query_dir / f"{name}.sql").write_text(statement + "\n", encoding="utf-8")
selection = {
    "01_calidad": (0, 1),
    "02_region": (0, 1),
    "03_rfm": (3, 4),
    "04_productos": (0, 1, 2, 3),
    "05_descuentos": (0, 1),
    "06_tendencias": (0, 1),
    "07_pareto": (2, 3),
}
for script_name, positions in selection.items():
    source = (root / "sql" / f"{script_name}.sql").read_text(encoding="utf-8")
    source = "\n".join(line for line in source.splitlines() if not line.lstrip().startswith("--"))
    statements = [part.strip() + ";" for part in source.split(";") if part.strip()]
    for index, position in enumerate(positions, 1):
        label = f"{script_name}_{index:02}"
        path = query_dir / f"{label}.sql"
        prefix = "SET hive.strict.checks.cartesian.product=false;\n" if script_name == "03_rfm" else ""
        path.write_text(prefix + statements[position] + "\n", encoding="utf-8")
        queries.append((label, statements[position]))

for script_name in ("08_envios", "09_segmentos", "10_estados", "11_categorias"):
    source = (root / "sql" / f"{script_name}.sql").read_text(encoding="utf-8")
    source = "\n".join(line for line in source.splitlines() if not line.lstrip().startswith("--"))
    (query_dir / f"{script_name}.sql").write_text(source, encoding="utf-8")
    queries.append((script_name, source))

lines = [
    "@echo off",
    "setlocal",
    'cd /d "%~dp0.."',
    "if not exist evidencias mkdir evidencias",
    'if exist "..\\ocultar_icono_barra.ps1" powershell -NoProfile -ExecutionPolicy Bypass -File "..\\ocultar_icono_barra.ps1" -Accion Ocultar >nul',
    "title Apache Hive Beeline - Superstore - Hiber Veizaga Crespo",
]
for name, _ in queries:
    lines.extend([
        "cls",
        f'docker exec -i docker-hive-hive-server-1 beeline -u jdbc:hive2://localhost:10000/default --verbose=true < "data\\evidencia_sql\\{name}.sql"',
        "if errorlevel 1 goto error",
        f'powershell -NoProfile -ExecutionPolicy Bypass -File "scripts\\capturar_pantalla_con_hora.ps1" -Output "evidencias\\{name}.png" >nul',
        "if errorlevel 1 goto error",
    ])
lines.extend([
    "goto cleanup", ":error", "echo Ocurrio un error durante las capturas.",
    ":cleanup", 'if exist "..\\ocultar_icono_barra.ps1" powershell -NoProfile -ExecutionPolicy Bypass -File "..\\ocultar_icono_barra.ps1" -Accion Restaurar >nul',
    "echo Capturas terminadas.", "pause",
])
(root / "cmd" / "capturas.cmd").write_text("\r\n".join(lines) + "\r\n", encoding="cp1252")
print(f"Consultas de evidencia: {len(queries)}")
