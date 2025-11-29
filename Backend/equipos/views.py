from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Q
from .models import Equipo
from .serializers import EquipoSerializer, EquipoListSerializer
from datetime import datetime

@api_view(['GET', 'POST'])
def equipo_list(request):
    """
    GET: Lista todos los equipos con filtros opcionales
    POST: Crea un nuevo equipo
    """
    if request.method == 'GET':
        equipos = Equipo.objects.select_related(
            'sede', 'servicio', 'responsable',
            'registro_adquisicion', 'informacion_metrologica'
        ).all()
        
        # Filtros opcionales
        sede_id = request.GET.get('sede_id', None)
        servicio_id = request.GET.get('servicio_id', None)
        estado_equipo = request.GET.get('estado', None)
        busqueda = request.GET.get('busqueda', None)
        
        if sede_id:
            equipos = equipos.filter(sede_id=sede_id)
        if servicio_id:
            equipos = equipos.filter(servicio_id=servicio_id)
        if estado_equipo:
            equipos = equipos.filter(estado=estado_equipo)
        if busqueda:
            equipos = equipos.filter(
                Q(codigo_inventario__icontains=busqueda) |
                Q(nombre_equipo__icontains=busqueda) |
                Q(marca__icontains=busqueda) |
                Q(modelo__icontains=busqueda) |
                Q(serie__icontains=busqueda)
            )
        
        # Usar serializer simplificado para listados
        serializer = EquipoListSerializer(equipos, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = EquipoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def equipo_detail(request, pk):
    """
    GET: Obtiene un equipo específico con toda su información
    PUT: Actualiza un equipo
    DELETE: Elimina un equipo
    """
    try:
        equipo = Equipo.objects.get(pk=pk)
    except Equipo.DoesNotExist:
        return Response({'error': 'Equipo no encontrado'}, status=status.HTTP_404_NOT_FOUND)
    
    if request.method == 'GET':
        serializer = EquipoSerializer(equipo)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        serializer = EquipoSerializer(equipo, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'DELETE':
        equipo.estado = 'Inactivo'
        equipo.save()
        return Response({'message': 'Equipo desactivado correctamente'}, status=status.HTTP_200_OK)

@api_view(['GET'])
def equipo_por_codigo(request, codigo_inventario):
    """Busca un equipo por su código de inventario"""
    try:
        equipo = Equipo.objects.get(codigo_inventario=codigo_inventario)
        serializer = EquipoSerializer(equipo)
        return Response(serializer.data)
    except Equipo.DoesNotExist:
        return Response({'error': 'Equipo no encontrado'}, status=status.HTTP_404_NOT_FOUND)

@api_view(['GET'])
def equipos_proximos_mantenimiento(request):
    """Lista equipos que requieren mantenimiento próximo"""
    from datetime import timedelta
    fecha_limite = datetime.now().date() + timedelta(days=30)
    
    equipos = Equipo.objects.select_related(
        'sede', 'servicio', 'responsable',
        'registro_adquisicion', 'informacion_metrologica'
    ).filter(
        informacion_metrologica__proximo_mantenimiento__lte=fecha_limite,
        informacion_metrologica__requiere_mantenimiento=True,
        estado='Activo'
    )
    serializer = EquipoListSerializer(equipos, many=True)
    return Response(serializer.data)

@api_view(['GET'])
def maintenance_stats(request):
    """
    Retorna estadísticas de mantenimiento usando la misma lógica del modelo.
    Esto garantiza consistencia entre el dashboard y las tablas de equipos.
    """
    equipos = Equipo.objects.select_related('informacion_metrologica').filter(estado='Activo')
    
    vencidos = 0
    proximos = 0
    normales = 0
    
    for equipo in equipos:
        if hasattr(equipo, 'informacion_metrologica') and equipo.informacion_metrologica:
            if equipo.informacion_metrologica.requiere_mantenimiento:
                estado = equipo.informacion_metrologica.estado_mantenimiento
                if estado == 'Vencido':
                    vencidos += 1
                elif estado == 'Próximo':
                    proximos += 1
                elif estado == 'Normal':
                    normales += 1
    
    return Response({
        'vencidos': vencidos,
        'proximos': proximos,
        'normales': normales,
        'total_requieren_mantenimiento': vencidos + proximos + normales
    })

@api_view(['POST'])
def equipo_upload_documento(request, pk):
    """Actualiza el estado de documentos del equipo"""
    try:
        equipo = Equipo.objects.get(pk=pk)
    except Equipo.DoesNotExist:
        return Response({'error': 'Equipo no encontrado'}, status=status.HTTP_404_NOT_FOUND)
    
    documento_tipo = request.data.get('tipo_documento')
    documentos_validos = [
        'hoja_vida', 'manual_operacion', 'manual_servicio',
        'manual_usuario', 'manual_partes', 'manual_despiece',
        'planos', 'guia_rapida', 'registro_importacion',
        'protocolo_preventivo', 'instructivo_manejo', 'frecuencia_metrologica'
    ]
    
    if documento_tipo in documentos_validos:
        if hasattr(equipo, 'documentacion'):
            setattr(equipo.documentacion, documento_tipo, True)
            equipo.documentacion.save()
            
        return Response({'message': f'{documento_tipo} actualizado correctamente'})
    
    return Response({'error': 'Tipo de documento inválido'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def dashboard_stats(request):
    """
    Retorna estadísticas para el dashboard principal:
    - Total de equipos
    - Equipos activos
    - Mantenimientos pendientes (próximos 30 días)
    - Calibraciones próximas (próximos 30 días)
    """
    from datetime import timedelta
    
    total_equipos = Equipo.objects.count()
    equipos_activos = Equipo.objects.filter(estado='Activo').count()
    
    fecha_limite = datetime.now().date() + timedelta(days=30)
    
    # Mantenimientos pendientes
    mantenimientos_pendientes = Equipo.objects.filter(
        informacion_metrologica__proximo_mantenimiento__lte=fecha_limite,
        informacion_metrologica__requiere_mantenimiento=True,
        estado='Activo'
    ).count()
    
    # Calibraciones próximas
    calibraciones_proximas = Equipo.objects.filter(
        informacion_metrologica__proxima_calibracion__lte=fecha_limite,
        informacion_metrologica__requiere_calibracion=True
    ).count()
    
    return Response({
        'total_equipos': total_equipos,
        'equipos_activos': equipos_activos,
        'mantenimientos_pendientes': mantenimientos_pendientes,
        'calibraciones_proximas': calibraciones_proximas
    })