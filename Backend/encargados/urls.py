from django.urls import path
from . import views

app_name = 'encargados'

urlpatterns = [
    path('encargados/', views.encargado_list, name='encargado-list'),
    path('encargados/<int:pk>/', views.encargado_detail, name='encargado-detail'),
    path('encargados/login/', views.encargado_login, name='encargado-login'),
    path('encargados/sede/<int:sede_id>/', views.encargados_por_sede, name='encargados-por-sede'),
    path('encargados/tecnicos/', views.encargados_tecnicos, name='encargados-tecnicos'),
]