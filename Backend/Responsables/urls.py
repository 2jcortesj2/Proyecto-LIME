from django.urls import path
from . import views

app_name = 'responsables'

urlpatterns = [
    path('responsables/', views.responsable_list, name='responsable-list'),
    path('responsables/<int:pk>/', views.responsable_detail, name='responsable-detail'),
    path('responsables/login/', views.responsable_login, name='responsable-login'),
    path('responsables/sede/<int:sede_id>/', views.responsables_por_sede, name='responsables-por-sede'),
    path('responsables/tecnicos/', views.responsables_tecnicos, name='responsables-tecnicos'),
]