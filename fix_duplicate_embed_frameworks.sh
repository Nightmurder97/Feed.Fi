#!/bin/bash

# Script específico para eliminar referencias duplicadas de RSCore en Embed Frameworks

echo "🔧 Eliminando referencias duplicadas de RSCore en Embed Frameworks..."

PROJECT_FILE="Feed.Fi.xcodeproj/project.pbxproj"
BACKUP_FILE="Feed.Fi.xcodeproj/project.pbxproj.backup.$(date +%Y%m%d_%H%M%S)"

# Crear backup
echo "📋 Creando backup: $BACKUP_FILE"
cp "$PROJECT_FILE" "$BACKUP_FILE"

# IDs específicos de RSCore que están causando duplicados
DUPLICATE_IDS=(
    "848E84D32DB7495C0023F3BA"
    "848E84D62DB749670023F3BA"
)

# Mantener solo el ID principal
KEEP_ID="848E84CC2DB749440023F3BA"

echo "✅ Manteniendo RSCore ID: $KEEP_ID"
echo "🗑️  Eliminando IDs duplicados en Embed Frameworks:"

for id in "${DUPLICATE_IDS[@]}"; do
    echo "   - $id"
    
    # Eliminar líneas específicas de Embed Frameworks
    sed -i '' "/${id}.*RSCore.*Embed Frameworks/d" "$PROJECT_FILE"
done

# Limpiar líneas vacías y comas extra
echo "🧹 Limpiando líneas vacías y comas extra..."
sed -i '' '/^[[:space:]]*$/d' "$PROJECT_FILE"
sed -i '' 's/,[[:space:]]*};/};/g' "$PROJECT_FILE"
sed -i '' 's/,[[:space:]]*)/)/g' "$PROJECT_FILE"

echo "✅ Limpieza completada!"
echo "📋 Backup guardado en: $BACKUP_FILE"
echo ""
echo "🔄 Ahora ejecuta: xcodebuild clean"