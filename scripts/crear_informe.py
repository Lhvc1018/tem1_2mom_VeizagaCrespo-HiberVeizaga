"""Genera un informe Word en Arial 12, sin tablas ni títulos desplegables."""

import re
from pathlib import Path

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.shared import Inches, Pt


root = Path(__file__).resolve().parent.parent
output = root / "Informe_Superstore_Hiber_Veizaga_Crespo.docx"
results = (root / "docs" / "resultados.md").read_text(encoding="utf-8")
sections = re.split(r"(?=^## Pregunta \d+\.)", results, flags=re.M)[1:]
assert len(sections) == 12

sql_names = [
    "00_modelo_carga.sql", "01_calidad.sql", "02_region.sql", "03_rfm.sql",
    "04_productos.sql", "05_descuentos.sql", "06_tendencias.sql", "07_pareto.sql",
    "08_envios.sql", "09_segmentos.sql", "10_estados.sql", "11_categorias.sql",
]
enunciados = [
    "Construya el modelo de almacenamiento en Apache Hive, identifique los campos, documente el diccionario, cree la tabla analítica y evidencie la carga.",
    "Audite registros, duplicados, órdenes, clientes, nulos, fechas, ventas y descuentos; proponga criterios para tratar inconsistencias.",
    "Analice ventas, ganancias, margen y variación anual por región mediante CTE y funciones de ventana; identifique los extremos.",
    "Calcule recencia, frecuencia y valor monetario por cliente; puntúe y justifique los segmentos de alto valor, recurrentes y en riesgo.",
    "Ordene productos por ganancia, volumen y rentabilidad; calcule margen, posición por categoría y ganancia acumulada.",
    "Compare cuatro rangos de descuento, rentabilidad y operaciones no rentables; identifique las categorías más afectadas.",
    "Analice ventas y ganancias mensuales, variaciones respecto al mes y año previos, media móvil y meses extremos.",
    "Determine cuántos productos concentran el 80 % de las ventas y de las ganancias; compare ambas concentraciones.",
    "Análisis complementario: compare los días entre pedido y envío por modalidad.",
    "Análisis complementario: compare ventas, ganancias y margen por segmento comercial.",
    "Análisis complementario: identifique los cinco estados con mayor y menor ganancia.",
    "Análisis complementario: compare la evolución anual de ventas y ganancias por categoría.",
]


def field(section, label):
    pattern = r"\*\*" + re.escape(label) + r"\.\*\*\s*(.*?)(?=\n\n|\Z)"
    match = re.search(pattern, section, re.S)
    if not match:
        raise ValueError(f"Falta {label}")
    return match.group(1).strip().replace("`", "")


document = Document()
document.core_properties.author = "Hiber Veizaga Crespo"
document.core_properties.last_modified_by = "Hiber Veizaga Crespo"
document.core_properties.title = "Análisis de ventas con Apache Hive"

page = document.sections[0]
page.page_width = Inches(8.5)
page.page_height = Inches(11)
page.top_margin = Inches(0.7)
page.bottom_margin = Inches(0.7)
page.left_margin = Inches(0.8)
page.right_margin = Inches(0.8)

normal = document.styles["Normal"]
normal.font.name = "Arial"
normal.font.size = Pt(12)
normal.paragraph_format.line_spacing = 1.15
normal.paragraph_format.space_after = Pt(6)


def paragraph(text="", *, bold=False, keep=False, before=0, after=6, page_before=False):
    item = document.add_paragraph(style="Normal")
    item.paragraph_format.space_before = Pt(before)
    item.paragraph_format.space_after = Pt(after)
    item.paragraph_format.keep_with_next = keep
    item.paragraph_format.page_break_before = page_before
    run = item.add_run(text)
    run.bold = bold
    run.font.name = "Arial"
    run.font.size = Pt(12)
    return item


def labeled(label, value):
    item = document.add_paragraph(style="Normal")
    item.paragraph_format.space_after = Pt(7)
    first = item.add_run(label + ": ")
    first.bold = True
    first.font.name = "Arial"
    first.font.size = Pt(12)
    second = item.add_run(value)
    second.font.name = "Arial"
    second.font.size = Pt(12)


def code_block(sql):
    paragraph("Consulta HiveQL", bold=True, keep=True, before=4, after=3)
    for line in sql.splitlines():
        item = paragraph(line or " ", after=0)
        item.paragraph_format.left_indent = Inches(0.15)
        item.paragraph_format.line_spacing = 1.0
    paragraph("", after=2)


paragraph("Análisis de ventas con Apache Hive", bold=True, after=12)
paragraph("Hiber Veizaga Crespo")
paragraph("Sample Superstore")
paragraph("Repositorio: https://github.com/Lhvc1018/tem1_2mom_VeizagaCrespo-HiberVeizaga")
paragraph(
    "Se cargaron 9.994 líneas de venta. El informe resuelve las ocho preguntas desarrolladas "
    "y presenta cuatro análisis complementarios."
)
paragraph("Datos y ejecución", bold=True, before=8, keep=True)
paragraph("Fuente: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final")
paragraph("La carga usa OpenCSVSerde y una tabla ORC. Las consultas y capturas se ejecutaron en CMD con Beeline.")
paragraph("Hallazgos principales", bold=True, before=8, keep=True)
paragraph("West tuvo la mayor ganancia regional; Central, la menor.")
paragraph("Los 856 registros con descuento superior al 50 % registraron pérdidas.")
paragraph("414 productos concentran el 80 % de las ventas; 340, el 80 % de las ganancias positivas.")

paragraph("Diccionario de datos", bold=True, keep=True, page_before=True)
paragraph("El CSV original contiene 21 columnas. Las fechas de origen usan el formato mes/día/año.")
dictionary = (root / "docs" / "diccionario_datos.md").read_text(encoding="utf-8")
rows = [line.strip().split("|")[1:-1] for line in dictionary.splitlines() if line.startswith("|")]
for row in rows[2:]:
    original, hive, data_type, description = [cell.strip() for cell in row]
    labeled(f"{original} ({hive}, {data_type})", description)

for number, section in enumerate(sections, 1):
    heading = re.search(r"^## (Pregunta \d+\. .+)$", section, re.M).group(1)
    strategy = field(section, "Estrategia")
    if "**Criterios.**" in section:
        strategy += " " + field(section, "Criterios")
    sql = (root / "sql" / sql_names[number - 1]).read_text(encoding="utf-8")
    evidence = re.findall(r"\[([^]]+)\]\(\.\./evidencias/([^)]*\.png)\)", section)
    if not evidence:
        raise ValueError(f"Sin evidencia para pregunta {number}")

    paragraph(heading, bold=True, keep=True, page_before=True)
    labeled("Enunciado", enunciados[number - 1])
    labeled("Estrategia", strategy)
    code_block(sql)
    labeled("Resultado", field(section, "Resultado"))
    labeled("Interpretación", field(section, "Interpretación"))
    labeled("Conclusión", field(section, "Conclusión"))

    paragraph(f"Evidencia de la pregunta {number}", bold=True, keep=True, page_before=True)
    for caption, filename in evidence:
        image = root / "evidencias" / filename
        if not image.exists():
            raise FileNotFoundError(image)
        paragraph(caption, bold=True, keep=True, after=3)
        item = document.add_paragraph(style="Normal")
        item.alignment = WD_ALIGN_PARAGRAPH.CENTER
        item.paragraph_format.space_after = Pt(10)
        item.add_run().add_picture(str(image), width=Inches(6.8))

paragraph("Optimización y conclusiones generales", bold=True, keep=True, page_before=True)
paragraph(
    "La tabla analítica usa ORC y tipos DATE, INT y DOUBLE. Las agregaciones preceden a las "
    "funciones de ventana. Particionar 9.994 filas por año o región crearía particiones pequeñas."
)
paragraph(
    "La auditoría no detectó anomalías en las reglas comprobadas. West obtuvo la mayor "
    "ganancia regional; Central, la menor."
)
paragraph(
    "Los descuentos superiores al 50 % coincidieron con pérdidas en 856 líneas. "
    "Esta asociación descriptiva no demuestra causalidad."
)
paragraph(
    "La segmentación identificó 199 clientes en riesgo. 414 productos concentran el 80 % "
    "de las ventas y 340 concentran el 80 % de las ganancias positivas."
)
paragraph("Acciones sugeridas", bold=True, before=8, keep=True)
paragraph("Revisar la mezcla de productos y costos en Central.")
paragraph("Evaluar límites de descuento por subcategoría.")
paragraph("Priorizar campañas de retención para los clientes en riesgo.")
paragraph("Revisar disponibilidad y rentabilidad de los productos líderes.")

document.save(output)
print(output)
