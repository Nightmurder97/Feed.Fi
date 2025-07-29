#!/bin/bash

# Script para solucionar problemas de GUID duplicado en paquetes locales
# Feed.Fi - Fix Package References

echo "🔧 Solucionando problemas de GUID duplicado en paquetes locales..."

# Limpiar cachés de Xcode
echo "📦 Limpiando cachés de Xcode..."
rm -rf ~/Library/Developer/Xcode/DerivedData/Feed.Fi-*
rm -rf ~/Library/Caches/com.apple.dt.Xcode

# Limpiar archivos de estado de paquetes
echo "🗑️ Limpiando archivos de estado de paquetes..."
find . -name ".swiftpm" -type d -exec rm -rf {} + 2>/dev/null || true
find . -name "Package.resolved" -type f -delete 2>/dev/null || true

# Limpiar archivos de build
echo "🏗️ Limpiando archivos de build..."
xcodebuild clean -project Feed.Fi.xcodeproj -scheme Feed.Fi 2>/dev/null || true

# Regenerar archivos de paquetes
echo "🔄 Regenerando archivos de paquetes..."
for module in Modules/*/; do
    if [ -f "$module/Package.swift" ]; then
        echo "  📁 Procesando $(basename "$module")..."
        cd "$module"
        swift package resolve 2>/dev/null || true
        cd ../..
    fi
done

# Resolver dependencias del proyecto principal
echo "🔗 Resolviendo dependencias del proyecto principal..."
xcodebuild -resolvePackageDependencies -project Feed.Fi.xcodeproj 2>/dev/null || true

echo "✅ Limpieza completada. Intenta compilar el proyecto ahora."
echo ""
echo "💡 Si el problema persiste, considera:"
echo "   1. Abrir el proyecto en Xcode"
echo "   2. Ir a File > Packages > Reset Package Caches"
echo "   3. File > Packages > Resolve Package Versions"
echo "   4. Product > Clean Build Folder"