from django.urls import path
from . import views

app_name = 'historial_traslados'

urlpatterns = [
    path('traslados/', views.traslado_list, name='traslado-list'),
    path('traslados/equipo/<int:equipo_id>/', views.traslado_por_equipo, name='traslado-por-equipo'),
]