"""
Script temporal para analizar la estructura del archivo Excel
"""
import pandas as pd
import sys

excel_file = r"c:\Users\jjcor\OneDrive\Documents\Proyecto-LIME\Proyecto-LIME\F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx"

try:
    print("=" * 80)
    print("ANÁLISIS DEL ARCHIVO EXCEL")
    print("=" * 80)
    
    # Leer primeras 20 filas sin procesar para ver estructura
    df_raw = pd.read_excel(excel_file, sheet_name='Hoja1', header=None, nrows=20)
    
    print("\nPRIMERAS 20 FILAS (sin procesar):")
    print("-" * 80)
    for idx, row in df_raw.iterrows():
        print(f"Fila {idx}: {row[0] if pd.notna(row[0]) else '[vacío]'} | {row[1] if pd.notna(row[1]) else '[vacío]'} | {row[2] if pd.notna(row[2]) else '[vacío]'}")
    
    # Intentar leer desde diferentes filas
    print("\n" + "=" * 80)
    print("INTENTANDO LEER DATOS DESDE DIFERENTES FILAS")
    print("=" * 80)
    
    for skiprows in [4, 5, 6, 7, 8]:
        print(f"\n--- Saltando {skiprows} filas ---")
        try:
            df = pd.read_excel(excel_file, sheet_name='Hoja1', skiprows=skiprows, nrows=5)
            
            print(f"Columnas ({len(df.columns)}):")
            cols_preview = list(df.columns[:10])  # Primeras 10 columnas
            for i, col in enumerate(cols_preview, 1):
                col_str = str(col)[:50]  # Limitar longitud
                print(f"  {i:2d}. {col_str}")
            
            if len(df.columns) > 10:
                print(f"  ... y {len(df.columns) - 10} columnas más")
            
            print(f"\nPrimera fila de datos:")
            if len(df) > 0:
                first_row = df.iloc[0]
                for col in list(df.columns[:10]):
                    val = first_row[col]
                    if pd.notna(val):
                        print(f"  {str(col)[:30]}: {str(val)[:50]}")
            
        except Exception as e:
            print(f"Error: {e}")

except Exception as e:
    print(f"\nError general: {e}")
    import traceback
    traceback.print_exc()
    sys.exit(1)

