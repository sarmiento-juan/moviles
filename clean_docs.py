#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Script para remover emojis y tildes de archivos markdown
"""

import os

# Rutas de archivos a limpiar
files_to_clean = [
    r'lib\Taller_http\README.md',
    r'lib\Taller_http\QUICK_START.md',
    r'lib\Taller_http\REQUISITOS_CUMPLIDOS.md',
]

# Mapeo de reemplazos
replacements = {
    # Emojis comunes
    '😄': '', '🚀': '', '✅': '', '❌': '', '📋': '', 
    '🔧': '', '🛠️': '', '🛠': '', '🎯': '', '📱': '', 
    '🌐': '', '💻': '', '🔍': '', '⚙️': '', '⚙': '', 
    '📦': '', '🎨': '', '💾': '', '⏳': '', '✨': '', 
    '🎉': '', '📝': '', '👨‍💻': '', '👩‍💻': '', '🔑': '', 
    '📚': '', '🎓': '', '📄': '', '🎬': '', '💡': '',
    '🔔': '', '⚠️': '', '⚠': '', '📊': '', '🔗': '',
    '🎮': '', '🎥': '', '🖥️': '', '🖥': '', '📲': '',
    '💬': '', '🧪': '', '🔐': '', '🚫': '', '🗑️': '',
    '🗑': '', '➕': '', '➖': '', '✖️': '', '✖': '',
    '➗': '', '📈': '', '📉': '', '🌟': '', '💸': '',
    '🏆': '', '🎪': '', '🎭': '', '🍔': '', '🍕': '',
    
    # Numeros emoji
    '1️⃣': '1.', '2️⃣': '2.', '3️⃣': '3.', '4️⃣': '4.', 
    '5️⃣': '5.', '6️⃣': '6.', '7️⃣': '7.', '8️⃣': '8.',
    '9️⃣': '9.', '0️⃣': '0.',
    
    # Tildes minusculas
    'á': 'a', 'é': 'e', 'í': 'i', 'ó': 'o', 'ú': 'u', 'ñ': 'n',
    
    # Tildes mayusculas
    'Á': 'A', 'É': 'E', 'Í': 'I', 'Ó': 'O', 'Ú': 'U', 'Ñ': 'N',
    
    # Otros caracteres especiales
    '¿': '', '¡': '',
}

def clean_file(filepath):
    """Limpia un archivo removiendo emojis y tildes"""
    try:
        # Leer contenido
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Aplicar reemplazos
        for old, new in replacements.items():
            content = content.replace(old, new)
        
        # Guardar archivo limpio
        with open(filepath, 'w', encoding='utf-8', newline='\n') as f:
            f.write(content)
        
        print(f"✓ Limpiado: {filepath}")
        return True
        
    except Exception as e:
        print(f"✗ Error en {filepath}: {e}")
        return False

def main():
    """Funcion principal"""
    print("Limpiando archivos markdown...")
    print("-" * 50)
    
    success_count = 0
    for file_path in files_to_clean:
        if clean_file(file_path):
            success_count += 1
    
    print("-" * 50)
    print(f"Completado: {success_count}/{len(files_to_clean)} archivos limpiados")

if __name__ == '__main__':
    main()
