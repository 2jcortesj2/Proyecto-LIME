from django.urls import path
from . import views

urlpatterns = [
    path('reportes/inventario/', views.reporte_inventario, name='reporte_inventario'),
    path('reportes/mantenimientos/', views.reporte_mantenimientos, name='reporte_mantenimientos'),
    path('reportes/traslados/', views.reporte_traslados, name='reporte_traslados'),
    path('reportes/estadisticas-sedes/', views.reporte_estadisticas_sedes, name='reporte_estadisticas_sedes'),
]
