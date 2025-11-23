"""
Script para convertir el archivo Excel de inventario de equipos a SQL
Genera un archivo SQL compatible con la base de datos LIME

Autor: Sistema LIME
Fecha: 2025-11-22
"""

import pandas as pd
import sys
from datetime import datetime
import re

# Configuración
EXCEL_FILE = r"c:\Users\jjcor\OneDrive\Documents\Proyecto-LIME\Proyecto-LIME\F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx"
OUTPUT_SQL = r"c:\Users\jjcor\OneDrive\Documents\Proyecto-LIME\Proyecto-LIME\equipos_desde_excel.sql"
SKIP_ROWS = 8  # Saltar las primeras 8 filas (encabezados)

# Mapeo de sedes
SEDES_MAP = {
    'Prado': 1,
    'SIU': 2,
    'San Vicente': 3
}

# Mapeo de servicios (basado en el SQL existente)
SERVICIOS_MAP = {
    'LIME': 1,
    'LIME - Hematología': 2,
    'LIME - Citometría de flujo': 3,
    'LIME - Almacén': 4,
    'LIME - Atención de Pacientes': 5,
    'LIME - Biología Molecular': 6,
    'LIME - BSL3': 7,
    'LIME - Citogenómica': 8,
    'LIME - Microbiología': 9,
    'LIME - Química e inmunología': 10,
    'LIME - Farmacología y Toxicología': 11,
    'Centro de resonancia': 12,
    'Fotodermatología': 13,
    'Trasplantes GICIG': 14,
    'Inmunodeficiencias Primarias': 15,
    'Grupo Reproducción': 16,
    'Patología': 17,
    'Dermatopatología': 18
}

def clean_value(value):
    """Limpia y formatea valores para SQL"""
    if pd.isna(value) or value == '' or value == 'N/A' or value == 'NA':
        return 'NULL'
    
    # Si es número
    if isinstance(value, (int, float)):
        return str(value)
    
    # Si es string
    value_str = str(value).strip()
    
    # Escapar comillas simples
    value_str = value_str.replace("'", "''")
    
    return f"'{value_str}'"

def clean_boolean(value):
    """Convierte valores a booleano SQL"""
    if pd.isna(value):
        return '0'
    
    value_str = str(value).strip().upper()
    
    if value_str in ['SI', 'SÍ', 'YES', 'Y', '1', 'TRUE', 'X']:
        return '1'
    elif value_str in ['NO', 'N', '0', 'FALSE', '']:
        return '0'
    else:
        return '0'

def clean_date(value):
    """Convierte fechas a formato SQL"""
    if pd.isna(value):
        return 'NULL'
    
    try:
        if isinstance(value, datetime):
            return f"'{value.strftime('%Y-%m-%d')}'"
        elif isinstance(value, str):
            # Intentar parsear diferentes formatos
            for fmt in ['%Y-%m-%d', '%d/%m/%Y', '%d-%m-%Y']:
                try:
                    dt = datetime.strptime(value, fmt)
                    return f"'{dt.strftime('%Y-%m-%d')}'"
                except:
                    continue
    except:
        pass
    
    return 'NULL'

def generate_sql():
    """Genera el archivo SQL desde el Excel"""
    
    print("=" * 80)
    print("CONVERSIÓN DE EXCEL A SQL - PROYECTO LIME")
    print("=" * 80)
    print(f"\nArchivo Excel: {EXCEL_FILE}")
    print(f"Archivo SQL de salida: {OUTPUT_SQL}")
    
    try:
        # Leer el Excel
        print("\n📖 Leyendo archivo Excel...")
        df = pd.read_excel(EXCEL_FILE, sheet_name='Hoja1', skiprows=SKIP_ROWS)
        
        print(f"✓ Se encontraron {len(df)} equipos")
        print(f"✓ Columnas: {len(df.columns)}")
        
        # Crear archivo SQL
        with open(OUTPUT_SQL, 'w', encoding='utf-8') as f:
            # Encabezado
            f.write("-- " + "=" * 76 + "\n")
            f.write("-- SCRIPT GENERADO AUTOMÁTICAMENTE DESDE EXCEL\n")
            f.write(f"-- Fecha de generación: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n")
            f.write(f"-- Total de equipos: {len(df)}\n")
            f.write("-- " + "=" * 76 + "\n\n")
            
            f.write("USE `lime_db`;\n\n")
            f.write("-- Deshabilitar validación de foreign keys temporalmente\n")
            f.write("SET FOREIGN_KEY_CHECKS = 0;\n\n")
            
            # Contador de equipos procesados
            equipo_counter = 1
            
            # Procesar cada fila
            print("\n🔄 Procesando equipos...")
            for idx, row in df.iterrows():
                try:
                    # Obtener valores básicos
                    sede_nombre = str(row.get('Sede', '')).strip()
                    servicio_nombre = str(row.get('Proceso', '')).strip()
                    nombre_equipo = str(row.get('Nombre del equipo', '')).strip()
                    
                    # Validar que tenga al menos nombre
                    if not nombre_equipo or nombre_equipo == 'nan':
                        continue
                    
                    # Obtener IDs
                    sede_id = SEDES_MAP.get(sede_nombre, 1)
                    servicio_id = SERVICIOS_MAP.get(servicio_nombre, 1)
                    
                    # Comentario de separación
                    f.write(f"-- EQUIPO {equipo_counter}: {nombre_equipo}\n")
                    f.write("-- " + "-" * 76 + "\n")
                    
                    # INSERT para equipos_equipo
                    f.write("INSERT INTO `equipos_equipo` (\n")
                    f.write("    `nombre_equipo`, `codigo_interno`, `codigo_ips`, `codigo_ecri`,\n")
                    f.write("    `ubicacion_fisica`, `marca`, `modelo`, `serie`,\n")
                    f.write("    `clasificacion_misional`, `clasificacion_ips`, `clasificacion_riesgo`,\n")
                    f.write("    `registro_invima`, `tiempo_vida_util`, `estado`,\n")
                    f.write("    `sede_id`, `servicio_id`, `responsable_id`\n")
                    f.write(") VALUES (\n")
                    
                    # Valores
                    codigo_interno = clean_value(row.get('Código de inventario interno del laboratorio y/o a', ''))
                    codigo_ips = clean_value(row.get('Código IPS', ''))
                    codigo_ecri = clean_value(row.get('Código ECRI', ''))
                    ubicacion = clean_value(row.get('Ubicación física', ''))
                    marca = clean_value(row.get('Marca', ''))
                    modelo = clean_value(row.get('Modelo', ''))
                    serie = clean_value(row.get('Serie', ''))
                    
                    # Clasificaciones
                    clasif_misional = clean_value(row.get('Clasificación misional', 'Extensión'))
                    clasif_ips = clean_value(row.get('Clasificación IPS', ''))
                    clasif_riesgo = clean_value(row.get('Clasificación de riesgo', ''))
                    
                    # Otros
                    registro_invima = clean_value(row.get('Registro INVIMA', ''))
                    tiempo_vida = clean_value(row.get('Tiempo de vida útil', ''))
                    
                    f.write(f"    {clean_value(nombre_equipo)}, {codigo_interno}, {codigo_ips}, {codigo_ecri},\n")
                    f.write(f"    {ubicacion}, {marca}, {modelo}, {serie},\n")
                    f.write(f"    {clasif_misional}, {clasif_ips}, {clasif_riesgo},\n")
                    f.write(f"    {registro_invima}, {tiempo_vida}, 'Activo',\n")
                    f.write(f"    {sede_id}, {servicio_id}, NULL\n")
                    f.write(");\n\n")
                    
                    f.write("SET @equipo_id = LAST_INSERT_ID();\n\n")
                    
                    # INSERT para equipos_registroadquisicion
                    f.write("INSERT INTO `equipos_registroadquisicion` (\n")
                    f.write("    `equipo_id`, `fecha_adquisicion`, `fecha_fabricacion`, `propietario`,\n")
                    f.write("    `nit_proveedor`, `nombre_proveedor`, `en_garantia`, `fecha_fin_garantia`,\n")
                    f.write("    `forma_adquisicion`, `tipo_documento`, `numero_documento`, `valor_compra`\n")
                    f.write(") VALUES (\n")
                    
                    fecha_adq = clean_date(row.get('Fecha de adquisición', ''))
                    fecha_fab = clean_date(row.get('Fecha de fabricación', ''))
                    propietario = clean_value(row.get('Propietario', 'UdeA'))
                    nit_prov = clean_value(row.get('NIT proveedor', ''))
                    nombre_prov = clean_value(row.get('Nombre proveedor', ''))
                    en_garantia = clean_boolean(row.get('En garantía', ''))
                    fecha_fin_gar = clean_date(row.get('Fecha fin garantía', ''))
                    forma_adq = clean_value(row.get('Forma de adquisición', 'Compra'))
                    tipo_doc = clean_value(row.get('Tipo de documento', ''))
                    num_doc = clean_value(row.get('Número de documento', ''))
                    valor = clean_value(row.get('Valor de compra', ''))
                    
                    f.write(f"    @equipo_id, {fecha_adq}, {fecha_fab}, {propietario},\n")
                    f.write(f"    {nit_prov}, {nombre_prov}, {en_garantia}, {fecha_fin_gar},\n")
                    f.write(f"    {forma_adq}, {tipo_doc}, {num_doc}, {valor}\n")
                    f.write(");\n\n")
                    
                    # INSERT para equipos_documentacionequipo
                    f.write("INSERT INTO `equipos_documentacionequipo` (\n")
                    f.write("    `equipo_id`, `hoja_vida`, `registro_importacion`, `manual_operacion`,\n")
                    f.write("    `manual_servicio`, `guia_rapida`, `protocolo_mto_preventivo`, `frecuencia_metrologica`\n")
                    f.write(") VALUES (\n")
                    
                    hoja_vida = clean_boolean(row.get('Hoja de vida', ''))
                    reg_import = clean_boolean(row.get('Registro de importación', ''))
                    manual_op = clean_boolean(row.get('Manual de operación', ''))
                    manual_serv = clean_boolean(row.get('Manual de servicio', ''))
                    guia_rap = clean_boolean(row.get('Guía rápida', ''))
                    protocolo_mto = clean_boolean(row.get('Protocolo de mantenimiento preventivo', ''))
                    frec_metro = clean_value(row.get('Frecuencia metrológica', ''))
                    
                    f.write(f"    @equipo_id, {hoja_vida}, {reg_import}, {manual_op},\n")
                    f.write(f"    {manual_serv}, {guia_rap}, {protocolo_mto}, {frec_metro}\n")
                    f.write(");\n\n")
                    
                    # INSERT para equipos_informacionmetrologica
                    f.write("INSERT INTO `equipos_informacionmetrologica` (\n")
                    f.write("    `equipo_id`, `magnitud`, `rango_equipo`, `resolucion`, `rango_trabajo`,\n")
                    f.write("    `error_maximo`, `requiere_mantenimiento`, `frecuencia_mantenimiento`,\n")
                    f.write("    `requiere_calibracion`, `frecuencia_calibracion`,\n")
                    f.write("    `ultimo_mantenimiento`, `proximo_mantenimiento`, `ultima_calibracion`, `proxima_calibracion`\n")
                    f.write(") VALUES (\n")
                    
                    magnitud = clean_value(row.get('Magnitud', ''))
                    rango_eq = clean_value(row.get('Rango del equipo', ''))
                    resolucion = clean_value(row.get('Resolución', ''))
                    rango_trab = clean_value(row.get('Rango de trabajo', ''))
                    error_max = clean_value(row.get('Error máximo', ''))
                    req_mto = clean_boolean(row.get('Requiere mantenimiento', ''))
                    frec_mto = clean_value(row.get('Frecuencia de mantenimiento', ''))
                    req_cal = clean_boolean(row.get('Requiere calibración', ''))
                    frec_cal = clean_value(row.get('Frecuencia de calibración', ''))
                    
                    f.write(f"    @equipo_id, {magnitud}, {rango_eq}, {resolucion}, {rango_trab},\n")
                    f.write(f"    {error_max}, {req_mto}, {frec_mto},\n")
                    f.write(f"    {req_cal}, {frec_cal},\n")
                    f.write(f"    NULL, NULL, NULL, NULL\n")
                    f.write(");\n\n")
                    
                    # INSERT para equipos_condicionesfuncionamiento
                    f.write("INSERT INTO `equipos_condicionesfuncionamiento` (\n")
                    f.write("    `equipo_id`, `voltaje`, `corriente`, `humedad_relativa`, `temperatura`,\n")
                    f.write("    `dimensiones`, `peso`, `otros`\n")
                    f.write(") VALUES (\n")
                    
                    voltaje = clean_value(row.get('Voltaje', ''))
                    corriente = clean_value(row.get('Corriente', ''))
                    humedad = clean_value(row.get('Humedad relativa', ''))
                    temperatura = clean_value(row.get('Temperatura', ''))
                    dimensiones = clean_value(row.get('Dimensiones', ''))
                    peso = clean_value(row.get('Peso', ''))
                    otros = clean_value(row.get('Otros', ''))
                    
                    f.write(f"    @equipo_id, {voltaje}, {corriente}, {humedad}, {temperatura},\n")
                    f.write(f"    {dimensiones}, {peso}, {otros}\n")
                    f.write(");\n\n")
                    
                    equipo_counter += 1
                    
                    if equipo_counter % 10 == 0:
                        print(f"  ✓ Procesados {equipo_counter - 1} equipos...")
                    
                except Exception as e:
                    print(f"  ⚠ Error en fila {idx}: {e}")
                    continue
            
            # Pie del archivo
            f.write("-- Reactivar validación de foreign keys\n")
            f.write("SET FOREIGN_KEY_CHECKS = 1;\n\n")
            
            f.write("-- " + "=" * 76 + "\n")
            f.write(f"-- TOTAL DE EQUIPOS INSERTADOS: {equipo_counter - 1}\n")
            f.write("-- " + "=" * 76 + "\n")
        
        print(f"\n✅ ¡Conversión completada!")
        print(f"✓ Total de equipos procesados: {equipo_counter - 1}")
        print(f"✓ Archivo SQL generado: {OUTPUT_SQL}")
        print(f"\n📝 Ahora puedes ejecutar el archivo SQL en MySQL:")
        print(f"   mysql -u root -p lime_db < {OUTPUT_SQL}")
        
    except Exception as e:
        print(f"\n❌ Error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

if __name__ == "__main__":
    generate_sql()
