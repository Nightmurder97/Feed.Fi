#!/bin/bash

# Script mejorado para limpiar referencias duplicadas de RSCore en project.pbxproj

echo "🔧 Limpiando referencias duplicadas de RSCore (v2)..."

PROJECT_FILE="Feed.Fi.xcodeproj/project.pbxproj"
BACKUP_FILE="Feed.Fi.xcodeproj/project.pbxproj.backup.$(date +%Y%m%d_%H%M%S)"

# Crear backup
echo "📋 Creando backup: $BACKUP_FILE"
cp "$PROJECT_FILE" "$BACKUP_FILE"

# IDs de RSCore que encontramos (mantener solo el primero)
KEEP_ID="848E84CC2DB749440023F3BA"
REMOVE_IDS=(
    "848E84D12DB7495C0023F3BA"
    "848E84D42DB749670023F3BA"
    "848E84D72DB749720023F3BA"
    "848E84DA2DB749860023F3BA"
    "848E84DE2DB749A40023F3BA"
)

echo "✅ Manteniendo RSCore ID: $KEEP_ID"
echo "🗑️  Eliminando IDs duplicados:"

for id in "${REMOVE_IDS[@]}"; do
    echo "   - $id"
    
    # Eliminar líneas completas que contengan el ID y RSCore
    sed -i '' "/${id}.*RSCore/d" "$PROJECT_FILE"
    
    # Eliminar líneas que solo contengan el ID (referencias en listas)
    sed -i '' "/^[[:space:]]*${id}[[:space:]]*\/\* RSCore/d" "$PROJECT_FILE"
    sed -i '' "/^[[:space:]]*${id}[[:space:]]*,$/d" "$PROJECT_FILE"
done

echo "🧹 Limpiando líneas vacías y comas extra..."
sed -i '' '/^[[:space:]]*$/d' "$PROJECT_FILE"
sed -i '' 's/,[[:space:]]*};/};/g' "$PROJECT_FILE"
sed -i '' 's/,[[:space:]]*)/)/g' "$PROJECT_FILE"

echo "✅ Limpieza completada!"
echo "📋 Backup guardado en: $BACKUP_FILE"
echo ""
echo "🔄 Ahora ejecuta: xcodebuild clean"