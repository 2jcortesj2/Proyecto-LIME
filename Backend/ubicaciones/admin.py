from django.contrib import admin
from .models import Ubicacion

@admin.register(Ubicacion)
class UbicacionAdmin(admin.ModelAdmin):
    list_display = ['nombre', 'sede', 'estado']
    list_filter = ['sede', 'estado']
    search_fields = ['nombre', 'sede__nombre']
    ordering = ['nombre']
