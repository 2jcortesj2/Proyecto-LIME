from django.urls import path
from . import views

app_name = 'sedes'

urlpatterns = [
    path('sedes/', views.sede_list, name='sede-list'),
    path('sedes/activas/', views.sede_active, name='sede-active'),
    path('sedes/<int:pk>/', views.sede_detail, name='sede-detail'),
]