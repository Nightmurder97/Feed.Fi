#!/bin/bash

# Feed.Fi - Script de Limpieza Profunda del Entorno de Desarrollo
# Uso: ./scripts/clean-build.sh [--build]
# 
# Este script implementa las mejores prácticas para resolver problemas de compilación
# persistentes y mantener un entorno de desarrollo limpio.

set -e

echo "🧹 Feed.Fi - Limpieza Profunda del Entorno de Desarrollo"
echo "======================================================"

# Función para mostrar progreso
progress() {
    echo "✅ $1"
}

# 1. Limpiar DerivedData (el más importante)
progress "Eliminando DerivedData cached..."
rm -rf ~/Library/Developer/Xcode/DerivedData/Feed.Fi-*
rm -rf ~/Library/Developer/Xcode/DerivedData/NetNewsWire-* # Legacy cleanup

# 2. Limpiar Module Cache
progress "Eliminando Module Cache..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache.noindex

# 3. Limpiar iOS Simulator data (si aplica)
progress "Reseteando iOS Simulator..."
xcrun simctl erase all 2>/dev/null || true

# 4. Limpiar SPM cache
progress "Limpiando Swift Package Manager cache..."
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf ~/Library/Developer/Xcode/DerivedData/*/SourcePackages

# 5. Limpiar build folder del proyecto
progress "Limpiando build folder local..."
rm -rf build/
rm -rf .build/

# 6. Verificar archivo project.pbxproj
progress "Verificando integridad del project.pbxproj..."
if ! plutil -lint Feed.Fi.xcodeproj/project.pbxproj >/dev/null 2>&1; then
    echo "⚠️  ADVERTENCIA: project.pbxproj puede estar corrupto"
    echo "   Considera restaurar desde el último commit funcional"
    exit 1
fi

# 7. Compilar si se solicita
if [[ "$1" == "--build" ]]; then
    progress "Iniciando compilación limpia..."
    xcodebuild -scheme "Feed.Fi" clean build
fi

progress "Limpieza completada exitosamente"
echo ""
echo "💡 Próximos pasos recomendados:"
echo "   1. Abre Xcode y verifica que no hay errores de configuración"
echo "   2. Ejecuta una compilación completa: ⌘+Shift+K seguido de ⌘+B"
echo "   3. Si persisten errores, revisa DeveloperSettings.xcconfig"