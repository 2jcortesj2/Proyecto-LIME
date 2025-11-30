import os
import django
import pandas as pd

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'LIME.settings')
django.setup()

# Read Excel with different header rows to find the right one
file_path = '../F-147 INVENTARIO EQUIPOS BIOMÉDICOS, INDUSTRIALES Y GASES V4.xlsx'

print("Finding the correct header row...")

# Try rows 5-8 which are most likely for this format
for header_row in [5, 6, 7, 8]:
    try:
        df = pd.read_excel(file_path, header=header_row)
        df = df.dropna(how='all')  # Remove empty rows
        
        if len(df) > 0:
            print(f"\n{'='*80}")
            print(f"HEADER ROW {header_row}")
            print(f"{'='*80}")
            print(f"Rows: {len(df)} | Columns: {len(df.columns)}")
            
            # Show first 20 columns
            print("\nFirst 20 columns:")
            for i, col in enumerate(list(df.columns)[:20]):
                col_name = str(col).strip()
                # Get first non-null value for this column
                sample = df[col].dropna().iloc[0] if len(df[col].dropna()) > 0 else "N/A"
                print(f"  {i:2d}. {col_name:40s} | Sample: {str(sample)[:50]}")
            
            # Check for key columns
            col_str_upper = ' '.join([str(c).upper() for c in df.columns])
            has_sede = 'SEDE' in col_str_upper
            has_ubicacion = 'UBICACION' in col_str_upper or 'UBICACIÓN' in col_str_upper
            has_nombre = 'NOMBRE' in col_str_upper or 'EQUIPO' in col_str_upper
            
            print(f"\n✓ Has SEDE: {has_sede}")
            print(f"✓ Has UBICACION: {has_ubicacion}")
            print(f"✓ Has NOMBRE/EQUIPO: {has_nombre}")
            
            if has_sede or has_ubicacion or has_nombre:
                print(f"\n🎯 Header row {header_row} looks good!\n")
                
                # Save this for detailed analysis
                with open('excel_columns.txt', 'w', encoding='utf-8') as f:
                    f.write(f"Header Row: {header_row}\n")
                    f.write(f"Total Rows: {len(df)}\n")
                    f.write(f"Total Columns: {len(df.columns)}\n\n")
                    f.write("ALL COLUMNS:\n")
                    f.write("="*80 + "\n")
                    for i, col in enumerate(df.columns):
                        sample = df[col].dropna().iloc[0] if len(df[col].dropna()) > 0 else "N/A"
                        f.write(f"{i:2d}. {str(col):50s} | Sample: {str(sample)}\n")
                
                print("✅ Saved detailed column list to excel_columns.txt")
                break
                
    except Exception as e:
        print(f"Row {header_row}: Error - {str(e)[:100]}")
