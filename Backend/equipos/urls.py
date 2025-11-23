from django.urls import path
from . import views

app_name = 'equipos'

urlpatterns = [
    path('equipos/', views.equipo_list, name='equipo-list'),
    path('equipos/dashboard-stats/', views.dashboard_stats, name='dashboard-stats'),
    path('equipos/proximos-mantenimiento/', views.equipos_proximos_mantenimiento, name='equipos-proximos-mantenimiento'),
    path('equipos/<int:pk>/', views.equipo_detail, name='equipo-detail'),
    path('equipos/codigo/<str:codigo_inventario>/', views.equipo_por_codigo, name='equipo-por-codigo'),
    path('equipos/<int:pk>/documento/', views.equipo_upload_documento, name='equipo-documento'),
]