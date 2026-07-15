import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

def build_release_notes_pdf():
    pdf_path = r"C:\Users\carlo\OneDrive\ORACULO IA\Releases\RELEASE_NOTES.pdf"
    
    # Asegurar que el directorio de salida exista
    os.makedirs(os.path.dirname(pdf_path), exist_ok=True)
    
    doc = SimpleDocTemplate(pdf_path, pagesize=letter,
                            rightMargin=40, leftMargin=40, topMargin=40, bottomMargin=40)
    story = []
    
    styles = getSampleStyleSheet()
    
    # Estilos Personalizados
    title_style = ParagraphStyle(
        'DocTitle',
        parent=styles['Title'],
        fontName='Helvetica-Bold',
        fontSize=24,
        textColor=colors.HexColor('#1E3C72'),
        spaceAfter=15
    )
    
    h1_style = ParagraphStyle(
        'SectionHeader',
        parent=styles['Heading1'],
        fontName='Helvetica-Bold',
        fontSize=15,
        textColor=colors.HexColor('#1E3C72'),
        spaceBefore=12,
        spaceAfter=6
    )
    
    body_style = ParagraphStyle(
        'BodyTextCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10,
        leading=14,
        textColor=colors.HexColor('#333333'),
        spaceAfter=6
    )
    
    bullet_style = ParagraphStyle(
        'BulletCustom',
        parent=body_style,
        leftIndent=15,
        bulletIndent=8,
        spaceAfter=4
    )

    # 1. Cabecera
    story.append(Paragraph("ORÁCULO IA — NOTAS DE VERSIÓN", title_style))
    story.append(Paragraph("Versión 2.12.0 — Edición Workspace (Espacio Personal)", body_style))
    story.append(Spacer(1, 12))
    
    # 2. Resumen Ejecutivo
    story.append(Paragraph("1. Resumen de la Versión", h1_style))
    summary_text = (
        "La versión 2.12.0 introduce el nuevo Módulo de Espacio de Trabajo Personal (Mi Workspace), "
        "una suite de herramientas integradas y offline que permite a los usuarios escribir notas "
        "con soporte Markdown, gestionar prompts personalizados en su bóveda, estructurar experimentos "
        "con control de hipótesis y catalogar documentos corporativos. Toda la información es persistida "
        "localmente de forma segura."
    )
    story.append(Paragraph(summary_text, body_style))
    
    # 3. Características Destacadas
    story.append(Paragraph("2. Características Destacadas", h1_style))
    story.append(Paragraph("• <b>Notebook Markdown (Módulo 2):</b> Editor con autoguardado inteligente cada 4 segundos y barra de herramientas con atajos de formato.", bullet_style))
    story.append(Paragraph("• <b>Prompt Vault (Módulo 3):</b> Bóveda personal para guardar, etiquetar, duplicar y asociar prompts con misiones o conceptos del Universo del Conocimiento.", bullet_style))
    story.append(Paragraph("• <b>Registro de Experimentos (Módulo 4):</b> Sistema estructurado para documentar objetivos, hipótesis, prompts de entrada, resultados y lecciones aprendidas.", bullet_style))
    story.append(Paragraph("• <b>Mis Documentos (Módulo 5):</b> Clasificación de documentos de negocio en categorías como IA, Trabajo, Banco, Excel y Programación.", bullet_style))
    story.append(Paragraph("• <b>Copias de Seguridad (Módulo 9):</b> Respaldos locales con verificación de integridad criptográfica mediante hash SHA-256.", bullet_style))
    
    # 4. Aseguramiento de Calidad
    story.append(Paragraph("3. Control de Calidad y Pruebas", h1_style))
    quality_text = (
        "Esta compilación ha superado el 100% de la suite de pruebas unitarias y de integración de la plataforma, "
        "con un total de <b>602 pruebas en verde</b>. El análisis estático de código mediante lints se ejecutó con "
        "cero errores de compilación y advertencias críticas de tipado."
    )
    story.append(Paragraph(quality_text, body_style))
    
    doc.build(story)
    print(f"PDF de Notas de Versión generado en: {pdf_path}")

if __name__ == "__main__":
    build_release_notes_pdf()
