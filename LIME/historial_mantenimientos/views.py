from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from .models import HistorialMantenimiento
from .serializers import HistorialMantenimientoSerializer
from equipos.models import Equipo
from datetime import datetime

@api_view(['GET', 'POST'])
def mantenimiento_list(request):
    """
    GET: Lista todos los mantenimientos
    POST: Registra un nuevo mantenimiento
    """
    if request.method == 'GET':
        equipo_id = request.GET.get('equipo_id', None)
        tipo = request.GET.get('tipo', None)
        
        mantenimientos = HistorialMantenimiento.objects.all()
        
        if equipo_id:
            mantenimientos = mantenimientos.filter(equipo_id=equipo_id)
        if tipo:
            mantenimientos = mantenimientos.filter(tipo_mantenimiento=tipo)
        
        serializer = HistorialMantenimientoSerializer(mantenimientos, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = HistorialMantenimientoSerializer(data=request.data)
        if serializer.is_valid():
            # Guardar el mantenimiento
            mantenimiento = serializer.save()
            
            # Actualizar el equipo
            equipo = mantenimiento.equipo
            equipo.ultimo_mantenimiento = mantenimiento.fecha_mantenimiento
            
            # Calcular próximo mantenimiento según frecuencia
            if equipo.frecuencia_mantenimiento:
                from dateutil.relativedelta import relativedelta
                
                if 'anual' in equipo.frecuencia_mantenimiento.lower():
                    equipo.proximo_mantenimiento = mantenimiento.fecha_mantenimiento + relativedelta(years=1)
                elif 'semestral' in equipo.frecuencia_mantenimiento.lower():
                    equipo.proximo_mantenimiento = mantenimiento.fecha_mantenimiento + relativedelta(months=6)
                elif 'trimestral' in equipo.frecuencia_mantenimiento.lower():
                    equipo.proximo_mantenimiento = mantenimiento.fecha_mantenimiento + relativedelta(months=3)
                elif 'mensual' in equipo.frecuencia_mantenimiento.lower():
                    equipo.proximo_mantenimiento = mantenimiento.fecha_mantenimiento + relativedelta(months=1)
            
            equipo.save()
            
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def mantenimiento_detail(request, pk):
    """Obtiene un mantenimiento específico"""
    try:
        mantenimiento = HistorialMantenimiento.objects.get(pk=pk)
        serializer = HistorialMantenimientoSerializer(mantenimiento)
        return Response(serializer.data)
    except HistorialMantenimiento.DoesNotExist:
        return Response({'error': 'Mantenimiento no encontrado'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def mantenimiento_por_equipo(request, equipo_id):
    """Obtiene el historial de mantenimientos de un equipo específico"""
    mantenimientos = HistorialMantenimiento.objects.filter(equipo_id=equipo_id)
    serializer = HistorialMantenimientoSerializer(mantenimientos, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def mantenimientos_recientes(request):
    """Obtiene los mantenimientos de los últimos 30 días"""
    from datetime import timedelta
    fecha_inicio = datetime.now().date() - timedelta(days=30)
    
    mantenimientos = HistorialMantenimiento.objects.filter(
        fecha_mantenimiento__gte=fecha_inicio
    ).order_by('-fecha_mantenimiento')
    
    serializer = HistorialMantenimientoSerializer(mantenimientos, many=True)
    return Response(serializer.data)