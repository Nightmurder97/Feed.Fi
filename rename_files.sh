#!/bin/bash

# Script para renombrar todos los archivos de NetNewsWire a Feed.Fi
# Ejecutar desde el directorio raíz del proyecto

echo "🔄 Renombrando archivos de NetNewsWire a Feed.Fi..."

# Renombrar archivos de test
echo "📁 Renombrando directorios de tests..."
if [ -d "Tests/NetNewsWireTests" ]; then
    mv "Tests/NetNewsWireTests" "Tests/Feed.Fi.Tests"
    echo "✅ Tests/NetNewsWireTests → Tests/Feed.Fi.Tests"
fi

if [ -d "Tests/NetNewsWire-iOSTests" ]; then
    mv "Tests/NetNewsWire-iOSTests" "Tests/Feed.Fi-iOSTests"
    echo "✅ Tests/NetNewsWire-iOSTests → Tests/Feed.Fi-iOSTests"
fi

# Renombrar archivos de tests
echo "📄 Renombrando archivos de tests..."
if [ -f "Tests/Feed.Fi-iOSTests/NetNewsWire_iOSTests.swift" ]; then
    mv "Tests/Feed.Fi-iOSTests/NetNewsWire_iOSTests.swift" "Tests/Feed.Fi-iOSTests/Feed.Fi_iOSTests.swift"
    echo "✅ NetNewsWire_iOSTests.swift → Feed.Fi_iOSTests.swift"
fi

# Renombrar archivos de configuración
echo "📄 Renombrando archivos de configuración..."
if [ -f "NetNewsWire-iOS.xctestplan" ]; then
    mv "NetNewsWire-iOS.xctestplan" "Feed.Fi-iOS.xctestplan"
    echo "✅ NetNewsWire-iOS.xctestplan → Feed.Fi-iOS.xctestplan"
fi

# Renombrar archivos en Mac/
echo "📄 Renombrando archivos en Mac/..."
if [ -f "Mac/NetNewsWire-Bridging-Header.h" ]; then
    mv "Mac/NetNewsWire-Bridging-Header.h" "Mac/Feed.Fi-Bridging-Header.h"
    echo "✅ NetNewsWire-Bridging-Header.h → Feed.Fi-Bridging-Header.h"
fi

if [ -f "Mac/Resources/NetNewsWire.provisionprofile" ]; then
    mv "Mac/Resources/NetNewsWire.provisionprofile" "Mac/Resources/Feed.Fi.provisionprofile"
    echo "✅ NetNewsWire.provisionprofile → Feed.Fi.provisionprofile"
fi

if [ -f "Mac/Resources/NetNewsWire.sdef" ]; then
    mv "Mac/Resources/NetNewsWire.sdef" "Mac/Resources/Feed.Fi.sdef"
    echo "✅ NetNewsWire.sdef → Feed.Fi.sdef"
fi

# Renombrar archivos en iOS/
echo "📄 Renombrando archivos en iOS/..."
if [ -f "iOS/Resources/NetNewsWire-iOS-Bridging-Header.h" ]; then
    mv "iOS/Resources/NetNewsWire-iOS-Bridging-Header.h" "iOS/Resources/Feed.Fi-iOS-Bridging-Header.h"
    echo "✅ NetNewsWire-iOS-Bridging-Header.h → Feed.Fi-iOS-Bridging-Header.h"
fi

if [ -f "iOS/Resources/NetNewsWire-dev.entitlements" ]; then
    mv "iOS/Resources/NetNewsWire-dev.entitlements" "iOS/Resources/Feed.Fi-dev.entitlements"
    echo "✅ iOS NetNewsWire-dev.entitlements → Feed.Fi-dev.entitlements"
fi

if [ -f "iOS/Resources/NetNewsWire.entitlements" ]; then
    mv "iOS/Resources/NetNewsWire.entitlements" "iOS/Resources/Feed.Fi.entitlements"
    echo "✅ iOS NetNewsWire.entitlements → Feed.Fi.entitlements"
fi

# Renombrar archivos de extensiones
echo "📄 Renombrando archivos de extensiones..."
if [ -f "iOS/IntentsExtension/NetNewsWire_iOS_IntentsExtension.entitlements" ]; then
    mv "iOS/IntentsExtension/NetNewsWire_iOS_IntentsExtension.entitlements" "iOS/IntentsExtension/Feed.Fi_iOS_IntentsExtension.entitlements"
    echo "✅ NetNewsWire_iOS_IntentsExtension.entitlements → Feed.Fi_iOS_IntentsExtension.entitlements"
fi

if [ -f "iOS/ShareExtension/NetNewsWire_iOS_ShareExtension.entitlements" ]; then
    mv "iOS/ShareExtension/NetNewsWire_iOS_ShareExtension.entitlements" "iOS/ShareExtension/Feed.Fi_iOS_ShareExtension.entitlements"
    echo "✅ NetNewsWire_iOS_ShareExtension.entitlements → Feed.Fi_iOS_ShareExtension.entitlements"
fi

if [ -f "Widget/NetNewsWire_iOS_WidgetExtension.entitlements" ]; then
    mv "Widget/NetNewsWire_iOS_WidgetExtension.entitlements" "Widget/Feed.Fi_iOS_WidgetExtension.entitlements"
    echo "✅ NetNewsWire_iOS_WidgetExtension.entitlements → Feed.Fi_iOS_WidgetExtension.entitlements"
fi

# Renombrar archivos JavaScript y otros
echo "📄 Renombrando otros archivos..."
if [ -f "Mac/SafariExtension/netnewswire-subscribe-to-feed.js" ]; then
    mv "Mac/SafariExtension/netnewswire-subscribe-to-feed.js" "Mac/SafariExtension/feedfi-subscribe-to-feed.js"
    echo "✅ netnewswire-subscribe-to-feed.js → feedfi-subscribe-to-feed.js"
fi

# Renombrar archivos de extensiones Swift
echo "📄 Renombrando archivos Swift con referencias..."
if [ -f "Shared/Extensions/NSAttributedString+NetNewsWire.swift" ]; then
    mv "Shared/Extensions/NSAttributedString+NetNewsWire.swift" "Shared/Extensions/NSAttributedString+Feed.Fi.swift"
    echo "✅ NSAttributedString+NetNewsWire.swift → NSAttributedString+Feed.Fi.swift"
fi

if [ -f "Mac/Scriptability/NSScriptCommand+NetNewsWire.swift" ]; then
    mv "Mac/Scriptability/NSScriptCommand+NetNewsWire.swift" "Mac/Scriptability/NSScriptCommand+Feed.Fi.swift"
    echo "✅ NSScriptCommand+NetNewsWire.swift → NSScriptCommand+Feed.Fi.swift"
fi

# Renombrar archivos de Appcasts
echo "📄 Renombrando archivos de Appcasts..."
if [ -f "Appcasts/netnewswire-beta.xml" ]; then
    mv "Appcasts/netnewswire-beta.xml" "Appcasts/feedfi-beta.xml"
    echo "✅ netnewswire-beta.xml → feedfi-beta.xml"
fi

if [ -f "Appcasts/netnewswire-release.xml" ]; then
    mv "Appcasts/netnewswire-release.xml" "Appcasts/feedfi-release.xml"
    echo "✅ netnewswire-release.xml → feedfi-release.xml"
fi

# Renombrar archivos de perfil de construcción
echo "📄 Renombrando archivos de buildscripts..."
if [ -f "buildscripts/profile/NetNewsWire.provisionprofile.enc" ]; then
    mv "buildscripts/profile/NetNewsWire.provisionprofile.enc" "buildscripts/profile/Feed.Fi.provisionprofile.enc"
    echo "✅ NetNewsWire.provisionprofile.enc → Feed.Fi.provisionprofile.enc"
fi

if [ -f "buildscripts/profile/NetNewsWireiOS.mobileprovision.enc" ]; then
    mv "buildscripts/profile/NetNewsWireiOS.mobileprovision.enc" "buildscripts/profile/Feed.Fi-iOS.mobileprovision.enc"
    echo "✅ NetNewsWireiOS.mobileprovision.enc → Feed.Fi-iOS.mobileprovision.enc"
fi

echo ""
echo "🎉 ¡Renombrado de archivos completado!"
echo "📋 Ahora necesitas actualizar las referencias internas en los archivos."