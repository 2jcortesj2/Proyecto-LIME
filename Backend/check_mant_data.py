import requests

r = requests.get('http://127.0.0.1:8000/api/equipos/')
data = r.json()

# Find equipment with maintenance history
for eq in data[:5]:  # Check first 5
    info_met = eq.get('informacion_metrologica', {})
    print(f"\nEquipo: {eq['codigo_interno']} - {eq['nombre_equipo']}")
    print(f"  Ultimo mantenimiento (campo): {info_met.get('ultimo_mantenimiento')}")
    print(f"  Proximo mantenimiento (campo): {info_met.get('proximo_mantenimiento')}")
    print(f"  Fecha calculada: {info_met.get('fecha_proximo_mantenimiento_calculada')}")
    print(f"  Estado: {info_met.get('estado_mantenimiento')}")
    print(f"  Requiere mant: {info_met.get('requiere_mantenimiento')}")
