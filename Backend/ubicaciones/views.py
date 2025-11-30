from rest_framework import viewsets, filters
from rest_framework.permissions import AllowAny
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
