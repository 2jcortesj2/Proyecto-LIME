@api_view(['GET'])
def maintenance_stats(request):
    """
    Retorna estadísticas de mantenimiento usando la misma lógica del modelo.
    Esto garantiza consistencia entre el dashboard y las tablas de equipos.
    """
    equipos = Equipo.objects.filter(estado='Activo')
    
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
