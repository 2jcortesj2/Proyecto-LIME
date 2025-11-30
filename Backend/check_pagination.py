import os
import django
import time

# Setup Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

from django.conf import settings
if 'testserver' not in settings.ALLOWED_HOSTS:
    settings.ALLOWED_HOSTS.append('testserver')

from django.test import RequestFactory
from rest_framework.test import APIRequestFactory
from historial_mantenimientos.views import mantenimiento_list
from historial_mantenimientos.models import HistorialMantenimiento
from django.db import connection, reset_queries

def verify_pagination():
    print("--- Verifying Pagination ---")
    factory = APIRequestFactory()
    request = factory.get('/api/mantenimientos/?page=1&page_size=10')
    
    # Measure time and queries
    reset_queries()
    start_time = time.time()
    
    response = mantenimiento_list(request)
    
    end_time = time.time()
    query_count = len(connection.queries)
    
    print(f"Status Code: {response.status_code}")
    if response.status_code == 200:
        data = response.data
        if 'results' in data and 'count' in data:
            print("SUCCESS: Pagination keys found.")
            print(f"Total Items: {data['count']}")
            print(f"Items on page: {len(data['results'])}")
            print(f"Next Link: {data['next']}")
        else:
            print("FAILURE: Pagination keys NOT found. Response might be a plain list.")
            print(f"Keys: {data.keys() if isinstance(data, dict) else 'List'}")
            
    print(f"Time taken: {end_time - start_time:.4f}s")
    print(f"Queries executed: {query_count}")
    
    # Check for N+1
    # We expect a small number of queries regardless of result size due to select_related
    # 1 query for count, 1 query for data (with joins)
    if query_count <= 5:
        print("SUCCESS: Query count is low (likely optimized).")
    else:
        print(f"WARNING: Query count is high ({query_count}). Check for N+1.")

if __name__ == "__main__":
    try:
        verify_pagination()
    except Exception as e:
        print(f"Error: {e}")
