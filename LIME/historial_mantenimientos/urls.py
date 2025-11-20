from django.urls import path
from . import views

app_name = 'historial_mantenimientos'

urlpatterns = [
    path('mantenimientos/', views.mantenimiento_list, name='mantenimiento-list'),
    path('mantenimientos/<int:pk>/', views.mantenimiento_detail, name='mantenimiento-detail'),
    path('mantenimientos/equipo/<int:equipo_id>/', views.mantenimiento_por_equipo, name='mantenimiento-por-equipo'),
    path('mantenimientos/recientes/', views.mantenimientos_recientes, name='mantenimientos-recientes'),
]