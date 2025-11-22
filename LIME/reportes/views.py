from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.http import HttpResponse
from django.template.loader import render_to_string
from equipos.models import Equipo
from historial_mantenimientos.models import HistorialMantenimiento
from historial_traslados.models import HistorialTraslado
from sedes.models import Sede
from datetime import datetime

def generate_pdf(template_name, context, filename):
    """Helper to generate PDF using weasyprint if available"""
    try:
        import weasyprint
        html_string = render_to_string(template_name, context)
        html = weasyprint.HTML(string=html_string)
        result = html.write_pdf()
        
        response = HttpResponse(content_type='application/pdf')
        response['Content-Disposition'] = f'attachment; filename="{filename}"'
        response.write(result)
        return response
    except ImportError:
        return Response(
            {'error': 'La librería weasyprint no está instalada. No se pueden generar PDFs.'},
            status=status.HTTP_501_NOT_IMPLEMENTED
        )
    except Exception as e:
        return Response(
            {'error': f'Error generando reporte: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['GET'])
def reporte_inventario(request):
    """Genera reporte PDF del inventario general"""
    equipos = Equipo.objects.all()
    context = {
        'titulo': 'Inventario General de Equipos',
        'equipos': equipos,
        'fecha': datetime.now()
    }
    return generate_pdf('reportes/inventario.html', context, 'inventario.pdf')

@api_view(['GET'])
def reporte_mantenimientos(request):
    """Genera reporte PDF de mantenimientos"""
    mantenimientos = HistorialMantenimiento.objects.all().order_by('-fecha_mantenimiento')[:100]
    context = {
        'titulo': 'Historial de Mantenimientos (Últimos 100)',
        'mantenimientos': mantenimientos,
        'fecha': datetime.now()
    }
    return generate_pdf('reportes/mantenimientos.html', context, 'mantenimientos.pdf')

@api_view(['GET'])
def reporte_traslados(request):
    """Genera reporte PDF de traslados"""
    traslados = HistorialTraslado.objects.all().order_by('-fecha_traslado')[:100]
    context = {
        'titulo': 'Historial de Traslados (Últimos 100)',
        'traslados': traslados,
        'fecha': datetime.now()
    }
    return generate_pdf('reportes/traslados.html', context, 'traslados.pdf')

@api_view(['GET'])
def reporte_estadisticas_sedes(request):
    """Genera reporte PDF de estadísticas por sede"""
    sedes = Sede.objects.all()
    data = []
    for sede in sedes:
        total = Equipo.objects.filter(sede=sede).count()
        activos = Equipo.objects.filter(sede=sede, estado='Activo').count()
        data.append({
            'nombre': sede.nombre,
            'total': total,
            'activos': activos
        })
        
    context = {
        'titulo': 'Estadísticas por Sede',
        'sedes_data': data,
        'fecha': datetime.now()
    }
    return generate_pdf('reportes/estadisticas_sedes.html', context, 'estadisticas_sedes.pdf')
