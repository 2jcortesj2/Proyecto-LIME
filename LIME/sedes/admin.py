from django.contrib import admin
from .models import Sede

@admin.register(Sede)
class SedeAdmin(admin.ModelAdmin):
    list_display = ['id', 'nombre', 'ciudad', 'telefono', 'estado']
    list_filter = ['estado', 'ciudad']
    search_fields = ['nombre', 'ciudad']