#!/usr/bin/env python3
"""
Script para migrar emojis a íconos AppIcon en archivos Vue.
Este script identifica emojis y los reemplaza con el componente AppIcon apropiado.
"""

import os
import re
import sys
from pathlib import Path

# Mapeo de emojis a nombres de íconos
EMOJI_TO_ICON = {
    # Actions
    '➕': 'plus',
    '🔍': 'search',
    '✕': 'close',
    '×': 'close',
    '✖': 'close',
    '☰': 'menu',
    '✏️': 'edit',
    '🗑️': 'trash',
    '👁️': 'eye',
    '👁‍🗨': 'eye-off',
    '👁️‍🗨️': 'eye-off',
    '✅': 'check',
    '⚠️': 'alert',
    '❌': 'x-circle',
    
    # Navigation
    '▼': 'chevron-down',
    '▶': 'chevron-right',
    '▲': 'chevron-up',
    '↑': 'sort-asc',
    
    # Objects
    '📦': 'inventory',
    '🏢': 'building',
    '📍': 'map-pin',
    '⚙️': 'settings',
    '🚪': 'logout',
    
    # Activities
    '📊': 'activity',
    '🔄': 'refresh',
    '📅': 'calendar',
    '📄': 'file',
    '⬇️': 'download',
    '⬆️': 'upload',
    '🔧': 'wrench',
    '⏰': 'clock',
    
    # Charts
    '📈': 'trending-up',
    '📉': 'trending-down',
    '🏠': 'home',
}

def find_vue_files(directory):
    """Encuentra todos los archivos .vue en el directorio especificado."""
    vue_files = []
    for root, dirs, files in os.walk(directory):
        # Ignorar node_modules y dist
        dirs[:] = [d for d in dirs if d not in ['node_modules', 'dist', '.git']]
        for file in files:
            if file.endswith('.vue'):
                vue_files.append(os.path.join(root, file))
    return vue_files

def detect_emojis_in_file(filepath):
    """Detecta todos los emojis presentes en un archivo."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        found_emojis = set()
        for emoji in EMOJI_TO_ICON.keys():
            if emoji in content:
                found_emojis.add(emoji)
        
        return found_emojis
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return set()

def replace_emoji_with_icon(text, emoji, icon_name, size=16):
    """Reemplaza un emoji con el componente AppIcon."""
    # No reemplazar en comentarios HTML
    # Intentar reemplazar solo en contexto de texto visible
    
    # Pattern: emoji como texto standalone en botones, spans, etc
    icon_component = f'<AppIcon name="{icon_name}" size="{size}" />'
    
    # Reemplazar emoji solo cuando no está ya dentro de AppIcon
    # Evitar reemplazar en strings de placeholder si ya tiene AppIcon
    lines = text.split('\n')
    new_lines = []
    
    for line in lines:
        # Si la línea ya tiene AppIcon, saltarla
        if '<AppIcon' in line and emoji in line:
            # Puede que ya esté parcialmente migrado
            new_lines.append(line)
            continue
        
        # Reemplazar emoji standalone
        new_line = line.replace(emoji, icon_component)
        new_lines.append(new_line)
    
    return '\n'.join(new_lines)

def migrate_file(filepath, dry_run=True):
    """Migra un archivo, reemplazando emojis con íconos."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        changed = False
        
        # Detectar y reemplazar cada emoji
        for emoji, icon_name in EMOJI_TO_ICON.items():
            if emoji in content:
                print(f"  Found {repr(emoji)} -> {icon_name}")
                content = replace_emoji_with_icon(content, emoji, icon_name)
                changed = True
        
        if changed:
            if not dry_run:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✓ Updated: {filepath}")
            else:
                print(f"  Would update: {filepath}")
            return True
        return False
    
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
        return False

def scan_directory(directory):
    """Escanea el directorio y produce un reporte de emojis encontrados."""
    print("=" * 80)
    print("EMOJI MIGRATION SCANNER")
    print("=" * 80)
    print(f"Scanning directory: {directory}\n")
    
    vue_files = find_vue_files(directory)
    print(f"Found {len(vue_files)} .vue files\n")
    
    files_with_emojis = {}
    all_emojis_found = set()
    
    for filepath in vue_files:
        emojis = detect_emojis_in_file(filepath)
        if emojis:
            relative_path = os.path.relpath(filepath, directory)
            files_with_emojis[relative_path] = emojis
            all_emojis_found.update(emojis)
    
    print("=" * 80)
    print("SCAN RESULTS")
    print("=" * 80)
    print(f"Files with emojis: {len(files_with_emojis)}")
    print(f"Unique emojis found: {len(all_emojis_found)}")
    print("\nEmoji mapping:")
    for emoji in sorted(all_emojis_found):
        icon_name = EMOJI_TO_ICON.get(emoji, '❓ UNMAPPED')
        print(f"  {repr(emoji)} -> {icon_name}")
    
    print("\n" + "=" * 80)
    print("FILES TO MIGRATE")
    print("=" * 80)
    for filepath, emojis in sorted(files_with_emojis.items()):
        print(f"\n{filepath}:")
        for emoji in sorted(emojis):
            icon_name = EMOJI_TO_ICON.get(emoji, '❓ UNMAPPED')
            print(f"  {repr(emoji)} -> {icon_name}")
    
    return files_with_emojis

def migrate_directory(directory, dry_run=True):
    """Migra todos los archivos .vue en el directorio."""
    print("\n" + "=" * 80)
    if dry_run:
        print("DRY RUN MODE - No files will be modified")
    else:
        print("MIGRATION MODE - Files will be modified")
    print("=" * 80 + "\n")
    
    vue_files = find_vue_files(directory)
    updated_count = 0
    
    for filepath in vue_files:
        relative_path = os.path.relpath(filepath, directory)
        emojis = detect_emojis_in_file(filepath)
        
        if emojis:
            print(f"\nProcessing: {relative_path}")
            if migrate_file(filepath, dry_run):
                updated_count += 1
    
    print("\n" + "=" * 80)
    print(f"Migration complete: {updated_count} files {'would be' if dry_run else 'were'} updated")
    print("=" * 80)

def main():
    # Directorio raíz del frontend
    frontend_dir = Path(__file__).parent.parent / 'src'
    
    if not frontend_dir.exists():
        print(f"Error: Frontend directory not found: {frontend_dir}")
        sys.exit(1)
    
    print(f"Working directory: {frontend_dir}\n")
    
    # Menú interactivo
    while True:
        print("\n" + "=" * 80)
        print("EMOJI TO ICON MIGRATION TOOL")
        print("=" * 80)
        print("1. Scan and report emojis")
        print("2. Dry run migration (preview changes)")
        print("3. Run migration (modify files)")
        print("4. Exit")
        print("=" * 80)
        
        choice = input("\nSelect option (1-4): ").strip()
        
        if choice == '1':
            scan_directory(str(frontend_dir))
        elif choice == '2':
            migrate_directory(str(frontend_dir), dry_run=True)
        elif choice == '3':
            confirm = input("\n⚠️  This will modify files. Are you sure? (yes/no): ").strip().lower()
            if confirm == 'yes':
                migrate_directory(str(frontend_dir), dry_run=False)
                print("\n✅ Migration completed!")
            else:
                print("Migration cancelled.")
        elif choice == '4':
            print("Exiting...")
            break
        else:
            print("Invalid option. Please try again.")

if __name__ == '__main__':
    main()
