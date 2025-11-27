import pandas as pd
import sys

EXCEL_FILE = r"c:\Users\jjcor\OneDrive\Documents\Proyecto-LIME\Proyecto-LIME\F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx"
SKIP_ROWS = 8

try:
    df = pd.read_excel(EXCEL_FILE, sheet_name='Hoja1', skiprows=SKIP_ROWS)
    print(f"Total rows: {len(df)}")
    
    # Check unique values of Risk Classification
    risk_col = 'Clasificación por riesgo'
    if risk_col in df.columns:
        print(f"\nUnique values in '{risk_col}':")
        print(df[risk_col].unique())
    else:
        print(f"\nColumn '{risk_col}' not found!")

except Exception as e:
    print(f"Error: {e}")
