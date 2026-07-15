import os
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle

def build_pdf():
    pdf_path = os.path.join("docs", "PROJECT_ARCHITECTURE.pdf")
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
        fontSize=16,
        textColor=colors.HexColor('#1E3C72'),
        spaceBefore=15,
        spaceAfter=8
    )
    
    body_style = ParagraphStyle(
        'BodyTextCustom',
        parent=styles['Normal'],
        fontName='Helvetica',
        fontSize=10.5,
        leading=14,
        textColor=colors.HexColor('#333333'),
        spaceAfter=8
    )
    
    # 1. Cabecera
    story.append(Paragraph("ORÁCULO IA — Arquitectura de la Plataforma", title_style))
    story.append(Paragraph("Edición Enterprise & Arquitectura Modular Offline", body_style))
    story.append(Spacer(1, 15))
    
    # 2. Descripción General
    story.append(Paragraph("1. Introducción y Capas de Diseño", h1_style))
    intro_text = (
        "ORÁCULO IA está estructurado bajo un diseño orientado a características (Feature-First) "
        "que aísla la lógica empresarial, de aprendizaje y utilidades de negocio de manera modular y "
        "completamente offline. La persistencia se realiza mediante SharedPreferences en el almacenamiento del dispositivo, "
        "y el contenido académico/profesional reside en bases de datos JSON optimizadas para carga asíncrona y perezosa (lazy-loading)."
    )
    story.append(Paragraph(intro_text, body_style))
    story.append(Spacer(1, 10))
    
    # Tabla de Capas
    data = [
        ['Capa', 'Descripción', 'Ejemplos en el Proyecto'],
        ['Presentation', 'Control de UI y estados de componentes', 'OfficeModeScreen, WelcomeScreen, Notifiers'],
        ['Domain', 'Modelos de datos puros y lógica pura', 'ProfessionalState, Challenge, Prompt'],
        ['Data', 'Carga de JSONs y persistencia local', 'ProfessionalRepository, KnowledgeEngine']
    ]
    t = Table(data, colWidths=[100, 240, 180])
    t.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor('#1E3C72')),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'LEFT'),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('BACKGROUND', (0, 1), (-1, -1), colors.HexColor('#F5F7FA')),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor('#E0E0E0')),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, -1), 9.5),
        ('BOTTOMPADDING', (0, 1), (-1, -1), 6),
    ]))
    story.append(t)
    story.append(Spacer(1, 15))
    
    # 3. Motores Principales
    story.append(Paragraph("2. Motores Principales (Engines)", h1_style))
    engines_text = (
        "El núcleo operativo offline está compuesto por dos motores deterministas:\n"
        "1. <b>Knowledge Engine</b>: Carga el manifiesto editorial y expone colecciones inmutables.\n"
        "2. <b>Mentor Engine</b>: Adapta itinerarios basándose en fallas conceptuales y mastery."
    )
    story.append(Paragraph(engines_text, body_style))
    story.append(Spacer(1, 15))
    
    # 4. Flujo de Datos
    story.append(Paragraph("3. Flujo de Datos Offline", h1_style))
    flow_text = (
        "El flujo de datos reactivo se acopla a Riverpod Notifiers. Las acciones del usuario modifican el "
        "estado in-memory y disparan operaciones asíncronas de guardado en SharedPreferences. Al reiniciar la "
        "aplicación, el estado se hidrata directamente desde los repositorios locales sin requerir conectividad de red."
    )
    story.append(Paragraph(flow_text, body_style))
    
    doc.build(story)
    print("PROJECT_ARCHITECTURE.pdf generado exitosamente.")

if __name__ == "__main__":
    build_pdf()
