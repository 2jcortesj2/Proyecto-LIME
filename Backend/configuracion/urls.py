from django.urls import path
from . import views

urlpatterns = [
    path('configuracion/', views.configuracion_detail, name='configuracion_detail'),
]
