#!/usr/bin/env python3
"""
Script para migrar emojis a íconos AppIcon en archivos Vue.
USO: python migrate_icons_auto.py [scan|migrate]
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
    '🔬': 'package',  # Lab equipment
    '🛠️': 'wrench',  # Tools/maintenance
    '📋': 'file',  # Clipboard/history
    '👥': 'user',  # People/responsibles
    
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
    """Encuentra todos los archivos .vue."""
    vue_files = []
    for root, dirs, files in os.walk(directory):
        dirs[:] = [d for d in dirs if d not in ['node_modules', 'dist', '.git']]
        for file in files:
            if file.endswith('.vue'):
                vue_files.append(os.path.join(root, file))
    return vue_files

def scan_files(directory):
    """Escanea archivos y reporta emojis encontrados."""
    print("Scanning for emojis...")
    vue_files = find_vue_files(directory)
    
    files_with_emojis = {}
    for filepath in vue_files:
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            found = set()
            for emoji in EMOJI_TO_ICON.keys():
                if emoji in content:
                    found.add(emoji)
            
            if found:
                files_with_emojis[filepath] = found
        except Exception as e:
            print(f"Error reading {filepath}: {e}")
    
    print(f"\nFound {len(files_with_emojis)} files with emojis")
    for filepath, emojis in files_with_emojis.items():
        print(f"\n{os.path.basename(filepath)}:")
        for emoji in emojis:
            print(f"  {repr(emoji)} -> {EMOJI_TO_ICON[emoji]}")
    
    return files_with_emojis

def migrate_files(directory):
    """Migra todos los archivos Vue."""
    print("Migrating files...")
    vue_files = find_vue_files(directory)
    updated = 0
    
    for filepath in vue_files:
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original = content
            
            # Reemplazar cada emoji
            for emoji, icon_name in EMOJI_TO_ICON.items():
                if emoji in content:
                    # No reemplazar si ya está en AppIcon
                    lines = content.split('\n')
                    new_lines = []
                    for line in lines:
                        if '<AppIcon' not in line or emoji not in line:
                            line = line.replace(emoji, f'<AppIcon name="{icon_name}" size="16" />')
                        new_lines.append(line)
                    content = '\n'.join(new_lines)
            
            if content != original:
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✓ {os.path.basename(filepath)}")
                updated += 1
                
        except Exception as e:
            print(f"Error processing {filepath}: {e}")
    
    print(f"\nUpdated {updated} files")

def main():
    frontend_dir = Path(__file__).parent.parent / 'src'
    
    if len(sys.argv) < 2:
        print("Usage: python migrate_icons_auto.py [scan|migrate]")
        sys.exit(1)
    
    mode = sys.argv[1]
    
    if mode == 'scan':
        scan_files(str(frontend_dir))
    elif mode == 'migrate':
        migrate_files(str(frontend_dir))
    else:
        print("Invalid mode. Use 'scan' or 'migrate'")
        sys.exit(1)

if __name__ == '__main__':
    main()
