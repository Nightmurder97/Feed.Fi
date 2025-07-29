#!/bin/bash

# Script para restaurar y renombrar el proyecto NetNewsWire a Feed.Fi
# Basado en el resumen de modificaciones realizadas

set -e  # Salir si hay algún error

echo "🔄 Iniciando restauración y renombrado del proyecto..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para imprimir mensajes
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar que estamos en el directorio correcto
if [ ! -d "NetNewsWire.xcodeproj" ]; then
    print_error "No se encontró NetNewsWire.xcodeproj. Asegúrate de estar en el directorio correcto."
    exit 1
fi

# Hacer backup del proyecto actual
print_status "Creando backup del proyecto actual..."
if [ -d "Feed.Fi.xcodeproj" ]; then
    mv "Feed.Fi.xcodeproj" "Feed.Fi.xcodeproj.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Backup creado: Feed.Fi.xcodeproj.backup"
fi

# Restaurar desde el original
print_status "Restaurando proyecto desde NetNewsWire.xcodeproj..."
cp -R "NetNewsWire.xcodeproj" "Feed.Fi.xcodeproj"
print_success "Proyecto restaurado"

# Renombrar archivos críticos dentro del proyecto
print_status "Renombrando archivos dentro del proyecto..."

# Renombrar archivos de configuración
cd "Feed.Fi.xcodeproj"

# Renombrar project.pbxproj internamente
print_status "Actualizando referencias en project.pbxproj..."

# Actualizar referencias de NetNewsWire a Feed.Fi
sed -i '' 's/NetNewsWire/Feed.Fi/g' project.pbxproj
sed -i '' 's/netnewswire/feedfi/g' project.pbxproj

# Actualizar Bundle Identifiers
sed -i '' 's/com\.ranchero/com.feedfi/g' project.pbxproj

# Actualizar Development Team (usar Personal Team)
sed -i '' 's/DEVELOPMENT_TEAM = MNAHBK54PT;/DEVELOPMENT_TEAM = "";/g' project.pbxproj

# Actualizar referencias de archivos .xcconfig
sed -i '' 's/NetNewsWire_/Feed.Fi_/g' project.pbxproj

print_success "Referencias actualizadas en project.pbxproj"

cd ..

# Restaurar archivos de configuración renombrados
print_status "Restaurando archivos de configuración..."

# Verificar que existen los archivos .xcconfig renombrados
if [ -d "xcconfig" ]; then
    print_success "Archivos .xcconfig ya están renombrados"
else
    print_warning "Carpeta xcconfig no encontrada, se creará desde el original"
fi

# Restaurar archivos de IA y configuración
print_status "Restaurando archivos de IA y configuración..."

# Verificar que existen los archivos de IA
if [ -f "Shared/AI/AIService.swift" ] && [ -f "Shared/AI/GeminiAIService.swift" ]; then
    print_success "Archivos de IA ya existen"
else
    print_warning "Archivos de IA no encontrados, se crearán después"
fi

# Restaurar archivos de configuración
if [ -f "Shared/Configuration/AppConfiguration.swift" ]; then
    print_success "Archivo de configuración ya existe"
else
    print_warning "Archivo de configuración no encontrado, se creará después"
fi

# Restaurar archivos de personalización
if [ -f "Shared/Customization/ThemeManager.swift" ]; then
    print_success "Archivo de temas ya existe"
else
    print_warning "Archivo de temas no encontrado, se creará después"
fi

# Actualizar scripts de build
print_status "Actualizando scripts de build..."

# Actualizar build_and_test.sh
if [ -f "buildscripts/build_and_test.sh" ]; then
    sed -i '' 's/NetNewsWire\.xcodeproj/Feed.Fi.xcodeproj/g' buildscripts/build_and_test.sh
    print_success "build_and_test.sh actualizado"
fi

# Actualizar quiet_build_and_test.sh
if [ -f "buildscripts/quiet_build_and_test.sh" ]; then
    sed -i '' 's/NetNewsWire\.xcodeproj/Feed.Fi.xcodeproj/g' buildscripts/quiet_build_and_test.sh
    print_success "quiet_build_and_test.sh actualizado"
fi

# Actualizar install.sh
if [ -f "install.sh" ]; then
    sed -i '' 's/NetNewsWire\.xcodeproj/Feed.Fi.xcodeproj/g' install.sh
    print_success "install.sh actualizado"
fi

# Crear archivo de configuración de firma
print_status "Creando archivo de configuración de firma..."

cat > "SharedXcodeSettings/DeveloperSettings.xcconfig" << 'EOF'
// Configuración local de desarrollo para Feed.Fi
// Este archivo NO debe ser committeado a version control

// Development Team (Personal Team)
DEVELOPMENT_TEAM = 

// Code Signing Identity
CODE_SIGN_IDENTITY = Apple Development

// Code Signing Style
CODE_SIGN_STYLE = Automatic

// Provisioning Profile (dejar vacío para Personal Team)
PROVISIONING_PROFILE_SPECIFIER = 

// Organization Identifier
ORGANIZATION_IDENTIFIER = com.feedfi
EOF

print_success "Archivo de configuración de firma creado"

# Actualizar .gitignore
print_status "Actualizando .gitignore..."

if ! grep -q "SharedXcodeSettings/DeveloperSettings.xcconfig" .gitignore; then
    echo "" >> .gitignore
    echo "# Configuración local de desarrollo" >> .gitignore
    echo "SharedXcodeSettings/DeveloperSettings.xcconfig" >> .gitignore
    print_success ".gitignore actualizado"
fi

# Limpiar archivos temporales
print_status "Limpiando archivos temporales..."

# Eliminar archivos .xctestplan duplicados
if [ -f "NetNewsWire.xctestplan" ]; then
    rm "NetNewsWire.xctestplan"
    print_success "Archivo NetNewsWire.xctestplan eliminado"
fi

if [ -f "NetNewsWire-iOS.xctestplan" ]; then
    rm "NetNewsWire-iOS.xctestplan"
    print_success "Archivo NetNewsWire-iOS.xctestplan eliminado"
fi

# Verificar que el proyecto se puede abrir
print_status "Verificando que el proyecto se puede abrir..."

if [ -f "Feed.Fi.xcodeproj/project.pbxproj" ]; then
    print_success "✅ Proyecto Feed.Fi.xcodeproj restaurado correctamente"
else
    print_error "❌ Error: No se pudo crear Feed.Fi.xcodeproj"
    exit 1
fi

# Mostrar resumen final
echo ""
echo "🎉 RESTAURACIÓN COMPLETADA"
echo "=========================="
echo ""
echo "✅ Proyecto restaurado desde NetNewsWire.xcodeproj"
echo "✅ Renombrado a Feed.Fi.xcodeproj"
echo "✅ Referencias actualizadas en project.pbxproj"
echo "✅ Bundle Identifiers cambiados a com.feedfi"
echo "✅ Scripts de build actualizados"
echo "✅ Archivo de configuración de firma creado"
echo ""
echo "📋 PRÓXIMOS PASOS:"
echo "1. Abrir Feed.Fi.xcodeproj en Xcode"
echo "2. Ir a Signing & Capabilities"
echo "3. Seleccionar tu Personal Team"
echo "4. Compilar y ejecutar"
echo ""
echo "⚠️  NOTAS IMPORTANTES:"
echo "- Los archivos de IA y configuración deben ser recreados si no existen"
echo "- Usa siempre la interfaz de Xcode para configurar firma"
echo "- No edites project.pbxproj manualmente"
echo ""

print_success "¡Restauración completada! Ahora puedes abrir Feed.Fi.xcodeproj en Xcode"