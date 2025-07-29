#!/bin/bash

# Feed.Fi - Script de Validación del Proyecto
# Uso: ./scripts/validate-project.sh
# 
# Este script implementa verificaciones automáticas para prevenir
# la corrupción del project.pbxproj y otros problemas comunes.

set -e

echo "🔍 Feed.Fi - Validación del Proyecto"
echo "===================================="

ERRORS=0

# Función para reportar errores
error() {
    echo "❌ ERROR: $1"
    ERRORS=$((ERRORS + 1))
}

# Función para reportar warnings
warning() {
    echo "⚠️  WARNING: $1"
}

# Función para reportar éxito
success() {
    echo "✅ $1"
}

# 1. Verificar integridad del project.pbxproj
echo "📋 Verificando project.pbxproj..."
if ! plutil -lint Feed.Fi.xcodeproj/project.pbxproj >/dev/null 2>&1; then
    error "project.pbxproj está corrupto (no es XML válido)"
else
    success "project.pbxproj tiene formato XML válido"
fi

# 2. Buscar referencias duplicadas
echo "🔍 Buscando referencias duplicadas..."
DUPLICATES=$(grep -o '[A-F0-9]\{24\}' Feed.Fi.xcodeproj/project.pbxproj | sort | uniq -d | wc -l)
if [ "$DUPLICATES" -gt 0 ]; then
    error "Encontradas $DUPLICATES referencias GUID duplicadas en project.pbxproj"
    echo "   💡 Ejecuta: grep -o '[A-F0-9]\{24\}' Feed.Fi.xcodeproj/project.pbxproj | sort | uniq -d"
else
    success "No se encontraron GUIDs duplicados"
fi

# 3. Verificar configuración de desarrollo
echo "⚙️  Verificando configuración de desarrollo..."
if [ ! -f "DeveloperSettings.xcconfig" ]; then
    warning "DeveloperSettings.xcconfig no existe. Copia DeveloperSettings.xcconfig.example"
else
    success "DeveloperSettings.xcconfig encontrado"
fi

# 4. Verificar que no hay configuración hardcodeada
echo "🔒 Verificando configuración hardcodeada..."
if grep -q "DEVELOPMENT_TEAM.*=.*[A-Z0-9]" Feed.Fi.xcodeproj/project.pbxproj; then
    warning "DEVELOPMENT_TEAM hardcodeado encontrado en project.pbxproj"
    echo "   💡 Mueve la configuración a DeveloperSettings.xcconfig"
fi

# 5. Verificar estructura de módulos Swift
echo "📦 Verificando estructura de módulos..."
for module in RSCore RSWeb RSParser RSDatabase Articles Account; do
    if [ ! -d "Modules/$module/Sources/$module" ]; then
        error "Estructura incorrecta en módulo $module (falta Sources/$module)"
    else
        success "Módulo $module tiene estructura correcta"
    fi
done

# 6. Verificar archivos críticos
echo "📁 Verificando archivos críticos..."
CRITICAL_FILES=(
    "Feed.Fi.xcodeproj/project.pbxproj"
    "Feed.Fi.xcodeproj/xcshareddata/xcschemes/Feed.Fi.xcscheme"
    "DeveloperSettings.xcconfig.example"
)

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        error "Archivo crítico faltante: $file"
    else
        success "Archivo crítico presente: $file"
    fi
done

# 7. Verificar .gitignore
echo "🙈 Verificando .gitignore..."
if ! grep -q "DeveloperSettings.xcconfig" .gitignore; then
    warning "DeveloperSettings.xcconfig no está en .gitignore"
fi

# Resumen
echo ""
echo "📊 RESUMEN DE VALIDACIÓN"
echo "======================="
if [ $ERRORS -eq 0 ]; then
    echo "✅ Todos los checks pasaron exitosamente"
    echo "🚀 El proyecto está listo para compilación"
    exit 0
else
    echo "❌ Se encontraron $ERRORS errores críticos"
    echo "🔧 Resuelve los errores antes de continuar"
    echo ""
    echo "💡 ACCIONES RECOMENDADAS:"
    echo "   1. Si project.pbxproj está corrupto: git checkout HEAD -- Feed.Fi.xcodeproj/project.pbxproj"
    echo "   2. Si hay GUIDs duplicados: ./scripts/clean-build.sh && valida manualmente"
    echo "   3. Para configuración: cp DeveloperSettings.xcconfig.example DeveloperSettings.xcconfig"
    exit 1
fi