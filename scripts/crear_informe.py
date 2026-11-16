"""Genera el informe Word con resultados y capturas reales de Beeline."""

import re
from pathlib import Path

from docx import Document
from docx.enum.table import WD_CELL_VERTICAL_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Inches, Pt, RGBColor


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
    match = re.search(r"\*\*" + re.escape(label) + r"\.\*\*\s*(.*?)(?=\n\n|\Z)", section, re.S)
    if not match:
        raise ValueError(f"Falta {label}")
    return match.group(1).strip()


def shade(cell, color="E8EEF5"):
    node = OxmlElement("w:shd")
    node.set(qn("w:fill"), color)
    cell._tc.get_or_add_tcPr().append(node)


def padding(cell, value=90):
    props = cell._tc.get_or_add_tcPr()
    margins = props.first_child_found_in("w:tcMar")
    if margins is None:
        margins = OxmlElement("w:tcMar")
        props.append(margins)
    for side in ("top", "start", "bottom", "end"):
        item = margins.find(qn(f"w:{side}"))
        if item is None:
            item = OxmlElement(f"w:{side}")
            margins.append(item)
        item.set(qn("w:w"), str(value))
        item.set(qn("w:type"), "dxa")


document = Document()
document.core_properties.author = "Hiber Veizaga Crespo"
document.core_properties.last_modified_by = "Hiber Veizaga Crespo"
document.core_properties.title = "Análisis de ventas con Apache Hive"
page = document.sections[0]
page.page_width = Inches(8.5)
page.page_height = Inches(11)
page.top_margin = Inches(0.65)
page.bottom_margin = Inches(0.65)
page.left_margin = Inches(0.8)
page.right_margin = Inches(0.8)

normal = document.styles["Normal"]
normal.font.name = "Aptos"
normal.font.size = Pt(9)
normal.paragraph_format.space_after = Pt(4)
title = document.styles["Title"]
title.font.name = "Aptos Display"
title.font.size = Pt(22)
title.font.bold = True
title.font.color.rgb = RGBColor(0, 0, 0)
title.font.underline = False
title_props = title._element.get_or_add_pPr()
title_border = title_props.find(qn("w:pBdr"))
if title_border is not None:
    title_props.remove(title_border)
for style in (document.styles["Heading 1"], document.styles["Heading 2"]):
    style.font.color.rgb = RGBColor(0, 0, 0)
    style.paragraph_format.keep_with_next = True

document.add_paragraph("Análisis de ventas con Apache Hive", style="Title")
document.add_paragraph("Hiber Veizaga Crespo · Sample Superstore")
document.add_paragraph("Repositorio: https://github.com/Lhvc1018/tem1_2mom_VeizagaCrespo-HiberVeizaga")
document.add_paragraph(
    "Proyecto individual de modelado, ingesta, calidad y analítica comercial. "
    "El dataset contiene 9.994 líneas de venta, 5.009 órdenes y 793 clientes. "
    "Las ocho preguntas desarrolladas y cuatro análisis complementarios se resolvieron en Apache Hive mediante CMD."
)
document.add_heading("Datos y ejecución", level=1)
document.add_paragraph("Fuente: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final")
document.add_paragraph(
    "El archivo original se convirtió de Windows-1252 a UTF-8. "
    "La ingesta usa OpenCSVSerde; la tabla analítica utiliza ORC y tipos Hive apropiados. "
    "La ruta verificada es la de superstore_veizaga.ventas en el almacén de Hive."
)
document.add_paragraph(
    "Ejecución en CMD: cmd\\cargar.cmd para crear y cargar la tabla; "
    "cmd\\consultas.cmd para ejecutar las consultas; "
    "cmd\\capturas.cmd para obtener la evidencia visual."
)
document.add_heading("Hallazgos principales", level=1)
for item in (
    "La auditoría no detectó identificadores duplicados, fechas inválidas ni descuentos fuera de rango.",
    "West registra la mayor ganancia regional; Central, la menor.",
    "El 100 % de las 856 líneas con descuento superior al 50 % no es rentable.",
    "414 productos generan el 80 % de las ventas; 340 productos generan el 80 % de las ganancias positivas.",
):
    document.add_paragraph(item, style="List Bullet")

document.add_page_break()
document.add_heading("Diccionario de datos", level=1)
dictionary = (root / "docs" / "diccionario_datos.md").read_text(encoding="utf-8")
rows = [line.strip().split("|")[1:-1] for line in dictionary.splitlines() if line.startswith("|")]
rows = [[cell.strip() for cell in row] for row in rows]
rows = [rows[0]] + rows[2:]
table = document.add_table(rows=1, cols=4)
table.style = "Table Grid"
table.autofit = False
widths = [Inches(x) for x in (1.25, 1.2, 0.75, 3.7)]
for cell, width, value in zip(table.rows[0].cells, widths, rows[0]):
    cell.width = width
    cell.text = value
    shade(cell)
    padding(cell)
    for run in cell.paragraphs[0].runs:
        run.bold = True
        run.font.size = Pt(7.5)
table.rows[0]._tr.get_or_add_trPr().append(OxmlElement("w:tblHeader"))
for values in rows[1:]:
    row = table.add_row()
    for cell, width, value in zip(row.cells, widths, values):
        cell.width = width
        cell.text = value
        padding(cell, 60)
        cell.vertical_alignment = WD_CELL_VERTICAL_ALIGNMENT.CENTER
        for paragraph in cell.paragraphs:
            paragraph.paragraph_format.space_after = Pt(0)
            for run in paragraph.runs:
                run.font.size = Pt(7.5)

for number, section in enumerate(sections, 1):
    heading = re.search(r"^## (Pregunta \d+\. .+)$", section, re.M).group(1)
    strategy = field(section, "Estrategia")
    if "**Criterios.**" in section:
        strategy += " " + field(section, "Criterios")
    result = field(section, "Resultado")
    interpretation = field(section, "Interpretación")
    conclusion = field(section, "Conclusión")
    sql = (root / "sql" / sql_names[number - 1]).read_text(encoding="utf-8")
    document.add_page_break()
    if number == 12:
        document.add_paragraph()
    document.add_heading(heading, level=1)
    answer_table = document.add_table(rows=0, cols=2)
    answer_table.style = "Table Grid"
    answer_table.autofit = False
    for label, value in (
        ("Enunciado", enunciados[number - 1]),
        ("Estrategia", strategy),
        ("Consulta HiveQL", sql),
        ("Resultado", result),
        ("Interpretación", interpretation),
        ("Conclusión", conclusion),
    ):
        cells = answer_table.add_row().cells
        cells[0].width = Inches(1.25)
        cells[1].width = Inches(5.65)
        cells[0].text = label
        cells[1].text = value
        shade(cells[0])
        for cell in cells:
            padding(cell)
            for paragraph in cell.paragraphs:
                paragraph.paragraph_format.space_after = Pt(0)
                for run in paragraph.runs:
                    if label == "Consulta HiveQL" and cell == cells[1]:
                        run.font.name = "Consolas"
                        run.font.size = Pt(7)
                    else:
                        run.font.size = Pt(8.5)
                    if cell == cells[0]:
                        run.bold = True

    evidence = re.findall(r"\[([^]]+)\]\(\.\./evidencias/([^)]*\.png)\)", section)
    if not evidence:
        raise ValueError(f"Sin evidencia para pregunta {number}")
    document.add_heading(f"Evidencia de la pregunta {number}", level=1)
    for caption, filename in evidence:
        image = root / "evidencias" / filename
        if not image.exists():
            raise FileNotFoundError(image)
        paragraph = document.add_paragraph()
        paragraph.paragraph_format.space_after = Pt(2)
        paragraph.paragraph_format.keep_with_next = True
        paragraph.add_run(caption).bold = True
        picture = document.add_paragraph()
        picture.alignment = WD_ALIGN_PARAGRAPH.CENTER
        picture.paragraph_format.space_after = Pt(5)
        picture.add_run().add_picture(str(image), width=Inches(6.6))

document.add_page_break()
document.add_heading("Optimización y conclusiones generales", level=1)
document.add_paragraph(
    "La tabla analítica usa ORC y tipos DATE, INT y DOUBLE. Las agregaciones preceden a las funciones de ventana. "
    "Con 9.994 filas, particionar por año o región crearía particiones pequeñas sin una ventaja clara."
)
document.add_paragraph(
    "La carga conservó 9.994 líneas y la auditoría no detectó anomalías en las reglas comprobadas. "
    "West obtuvo la mayor ganancia regional; Central, la menor."
)
document.add_paragraph(
    "Los descuentos superiores al 50 % coincidieron con pérdidas en las 856 líneas del grupo. "
    "La asociación es descriptiva y no demuestra causalidad."
)
document.add_paragraph(
    "La segmentación identificó 199 clientes en riesgo. "
    "414 productos concentran el 80 % de las ventas y 340 concentran el 80 % de las ganancias positivas."
)
document.add_heading("Acciones sugeridas", level=2)
actions = document.add_table(rows=1, cols=3)
actions.style = "Table Grid"
for cell, value in zip(actions.rows[0].cells, ("Tema", "Hallazgo", "Acción")):
    cell.text = value
    shade(cell)
    padding(cell)
    for run in cell.paragraphs[0].runs:
        run.bold = True
for values in (
    ("Regiones", "Central tuvo la menor ganancia y margen regional.", "Revisar mezcla de productos y costos por región."),
    ("Descuentos", "Las 856 líneas con descuento alto registraron pérdidas.", "Evaluar límites de descuento por subcategoría."),
    ("Clientes", "199 clientes quedaron en riesgo según RFM.", "Priorizar campañas de retención y medir respuesta."),
    ("Productos", "414 productos concentran el 80 % de las ventas.", "Revisar disponibilidad y rentabilidad de los líderes."),
):
    for cell, value in zip(actions.add_row().cells, values):
        cell.text = value
        padding(cell)

document.save(output)
print(output)
