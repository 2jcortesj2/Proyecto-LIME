from django.urls import path
from . import views

app_name = 'usuarios'

urlpatterns = [
    path('usuarios/', views.usuario_list, name='usuario-list'),
    path('usuarios/<int:pk>/', views.usuario_detail, name='usuario-detail'),
    path('usuarios/login/', views.usuario_login, name='usuario-login'),
    path('usuarios/sede/<int:sede_id>/', views.encargados_por_sede, name='encargados-por-sede'),
    path('usuarios/tecnicos/', views.encargados_tecnicos, name='encargados-tecnicos'),
]