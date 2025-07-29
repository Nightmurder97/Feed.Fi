#!/bin/bash

# Script para eliminar completamente todas las referencias de RSCore y volver a agregarlas limpiamente

echo "🔧 Eliminando completamente todas las referencias de RSCore..."

PROJECT_FILE="Feed.Fi.xcodeproj/project.pbxproj"
BACKUP_FILE="Feed.Fi.xcodeproj/project.pbxproj.backup.$(date +%Y%m%d_%H%M%S)"

# Crear backup
echo "📋 Creando backup: $BACKUP_FILE"
cp "$PROJECT_FILE" "$BACKUP_FILE"

# Eliminar todas las líneas que contengan RSCore (excepto RSCoreResources)
echo "🗑️  Eliminando todas las referencias de RSCore..."
sed -i '' '/RSCore[^R]/d' "$PROJECT_FILE"

# Eliminar líneas que solo contengan IDs de RSCore (referencias en listas)
echo "🗑️  Eliminando IDs de RSCore en listas..."
sed -i '' '/^[[:space:]]*848E84.*RSCore/d' "$PROJECT_FILE"
sed -i '' '/^[[:space:]]*848E84.*\/\* RSCore/d' "$PROJECT_FILE"

# Limpiar líneas vacías y comas extra
echo "🧹 Limpiando líneas vacías y comas extra..."
sed -i '' '/^[[:space:]]*$/d' "$PROJECT_FILE"
sed -i '' 's/,[[:space:]]*};/};/g' "$PROJECT_FILE"
sed -i '' 's/,[[:space:]]*)/)/g' "$PROJECT_FILE"

echo "✅ Eliminación completada!"
echo "📋 Backup guardado en: $BACKUP_FILE"
echo ""
echo "⚠️  Ahora necesitas agregar manualmente las referencias de RSCore en Xcode:"
echo "   1. Abre el proyecto en Xcode"
echo "   2. Ve a Build Phases del target Feed.Fi"
echo "   3. En 'Link Binary With Libraries', agrega RSCore"
echo "   4. En 'Embed Frameworks', agrega RSCore"
echo "   5. Haz lo mismo para otros targets que necesiten RSCore"