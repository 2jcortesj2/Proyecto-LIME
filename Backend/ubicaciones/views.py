from rest_framework import viewsets, filters, status
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .models import Ubicacion
from .serializers import UbicacionSerializer, UbicacionDetailSerializer

class UbicacionViewSet(viewsets.ModelViewSet):
    queryset = Ubicacion.objects.select_related('sede').all()
    permission_classes = [AllowAny]
    filter_backends = [filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['nombre', 'sede__nombre']
    ordering_fields = ['nombre', 'sede__nombre']
    ordering = ['nombre']
    
    def get_serializer_class(self):
        if self.action in ['retrieve', 'list']:
            return UbicacionDetailSerializer
        return UbicacionSerializer
    
    def get_queryset(self):
        queryset = super().get_queryset()
        sede_id = self.request.query_params.get('sede', None)
        estado = self.request.query_params.get('estado', None)
        
        if sede_id is not None:
            queryset = queryset.filter(sede_id=sede_id)
        if estado is not None:
            queryset = queryset.filter(estado=estado)
            
        return queryset
    
    def destroy(self, request, *args, **kwargs):
        """
        Elimina una ubicación solo si no tiene equipos asignados
        """
        ubicacion = self.get_object()
        
        # Verificar que no tenga equipos asignados
        num_equipos = ubicacion.equipos.count()
        if num_equipos > 0:
            return Response(
                {
                    'error': 'No se puede eliminar una ubicación que tiene equipos asignados',
                    'num_equipos': num_equipos
                },
                status=status.HTTP_400_BAD_REQUEST
            )
        
        return super().destroy(request, *args, **kwargs)
