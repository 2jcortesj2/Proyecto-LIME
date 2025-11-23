from django.contrib import admin
from .models import Encargado

@admin.register(Encargado)
class EncargadoAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre_completo', 'email', 'rol')
    search_fields = ('nombre_completo', 'email')
    list_filter = ('rol',)
    ordering = ('-id',)
