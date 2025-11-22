from django.urls import path
from . import views

app_name = 'servicios'

urlpatterns = [
    path('servicios/', views.servicio_list, name='servicio-list'),
    path('servicios/<int:pk>/', views.servicio_detail, name='servicio-detail'),
    path('servicios/sede/<int:sede_id>/', views.servicios_por_sede, name='servicios-por-sede'),
]