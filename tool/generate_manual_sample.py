import json
from pathlib import Path
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, PageBreak

root=Path(__file__).resolve().parents[1]
data=json.loads((root/'knowledge/oraculo_content_v1.json').read_text(encoding='utf-8'))
out=root/'releases/ORACULO IA - Manual Maestro 2.6.pdf'
styles=getSampleStyleSheet(); story=[]
story += [Spacer(1,150),Paragraph('ORACULO IA',styles['Title']),Paragraph('Manual Maestro offline - version 2.6',styles['Heading2']),Paragraph('Generado: 12/07/2026',styles['Normal']),PageBreak(),Paragraph('Indice',styles['Title'])]
for i,a in enumerate(data['articles'],1): story.append(Paragraph(f'{i}. {a["title"]}',styles['Normal']))
story.append(PageBreak())
for a in data['articles']:
    story += [Paragraph(a['title'],styles['Heading1']),Paragraph(a['body'],styles['BodyText']),Paragraph('Conceptos y fuentes: '+', '.join(a['links']),styles['Italic']),Spacer(1,18)]
story += [PageBreak(),Paragraph('Glosario',styles['Title'])]
for t in data['dictionary']: story += [Paragraph(t['term'],styles['Heading2']),Paragraph(t['definition'],styles['BodyText'])]
def footer(canvas,doc):
    canvas.saveState();canvas.setFont('Helvetica',9);canvas.drawString(42,25,'ORACULO IA - Manual Maestro');canvas.drawRightString(A4[0]-42,25,f'Pagina {doc.page}');canvas.restoreState()
SimpleDocTemplate(str(out),pagesize=A4,rightMargin=42,leftMargin=42,topMargin=42,bottomMargin=42,title='ORACULO IA - Manual Maestro').build(story,onFirstPage=footer,onLaterPages=footer)
print(out)
