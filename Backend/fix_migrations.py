import os
import django
from django.db import connection

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

def clean_migrations():
    with connection.cursor() as cursor:
        print("Cleaning django_migrations table for 'equipos' and 'responsables'...")
        cursor.execute("DELETE FROM django_migrations WHERE app IN ('equipos', 'responsables', 'historial_mantenimientos', 'historial_traslados')")
        print("Rows deleted.")

if __name__ == '__main__':
    clean_migrations()
