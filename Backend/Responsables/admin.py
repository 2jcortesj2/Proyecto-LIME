from django.contrib import admin
from .models import Responsable

@admin.register(Responsable)
class ResponsableAdmin(admin.ModelAdmin):
    list_display = ('id', 'nombre_completo', 'email', 'rol')
    search_fields = ('nombre_completo', 'email')
    list_filter = ('rol',)
    ordering = ('-id',)
