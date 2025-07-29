# Feed.Fi - Guía de Arquitectura y Mejores Prácticas

## 🏗️ Arquitectura del Proyecto

Feed.Fi es un lector de RSS moderno basado en NetNewsWire, refactorizado con integración de IA y diseño actualizado. La arquitectura sigue principios de modularización y separación de responsabilidades.

### Estructura de Módulos

```
Feed.Fi/
├── Feed.Fi/                    # Aplicación principal
├── Modules/                    # Módulos Swift Package Manager
│   ├── RSCore/                # Utilidades y operaciones base
│   ├── RSWeb/                 # Networking y cache web
│   ├── RSParser/              # Parseo RSS/Atom/JSON
│   ├── RSDatabase/            # Abstracción de base de datos  
│   ├── Articles/              # Modelos de artículos
│   ├── Account/               # Gestión de cuentas y sync
│   └── ArticlesDatabase/      # Persistencia de artículos
└── scripts/                   # Scripts de automatización
```

## 🔧 Mejores Prácticas de Desarrollo

### 1. Gestión del project.pbxproj

**❌ NUNCA HAGAS ESTO:**
- Editar manualmente `Feed.Fi.xcodeproj/project.pbxproj`
- Hacer merge de conflictos en este archivo sin revisar
- Copiar/pegar referencias GUID entre proyectos

**✅ SIEMPRE HAZ ESTO:**
- Usar la interfaz gráfica de Xcode para todos los cambios
- Ejecutar `./scripts/validate-project.sh` antes de commits importantes
- En caso de corrupción: `git checkout HEAD -- Feed.Fi.xcodeproj/project.pbxproj`

### 2. Configuración del Entorno

**Estructura de Configuración:**
```
DeveloperSettings.xcconfig      # Tu configuración local (gitignored)
DeveloperSettings.xcconfig.example  # Plantilla para nuevos desarrolladores  
Feed-Fi-Config.xcconfig         # Configuración compartida del proyecto
Release.xcconfig               # Configuración para releases
```

**Flujo de Onboarding:**
1. `cp DeveloperSettings.xcconfig.example DeveloperSettings.xcconfig`
2. Editar `DeveloperSettings.xcconfig` con tu DEVELOPMENT_TEAM
3. `./scripts/validate-project.sh` para verificar configuración
4. `./scripts/clean-build.sh --build` para primera compilación

### 3. Resolución de Problemas de Compilación

**Protocolo de Resolución:**
1. **Limpieza Estándar:** `⌘+Shift+K` en Xcode
2. **Limpieza Profunda:** `./scripts/clean-build.sh`
3. **Validación:** `./scripts/validate-project.sh`
4. **Reset Completo:** Restaurar `project.pbxproj` desde Git

**Errores Comunes y Soluciones:**

| Error | Causa Probable | Solución |
|-------|---------------|----------|
| "GUID duplicado" | `project.pbxproj` corrupto | Restaurar desde Git |
| "Code signing error" | `DEVELOPMENT_TEAM` incorrecto | Verificar `DeveloperSettings.xcconfig` |
| "Module not found" | Cache de SPM corrupto | `./scripts/clean-build.sh` |
| "Unexpected duplicate tasks" | Referencias duplicadas | Usar herramienta de limpieza automática |

## 🧩 Arquitectura de Módulos

### RSCore - Utilidades Base
- **MainThreadOperation**: Sistema de operaciones asíncronas
- **Cache**: Sistema de cache genérico con TTL
- **Extensiones**: Utilidades para Date, String, etc.

### RSWeb - Networking
- **Downloader**: Descarga simple con cache
- **HTMLMetadataCache**: Cache específico para metadatos HTML
- **UserAgent**: Gestión de user agents

### RSParser - Parseo de Feeds
- **FeedParser**: Parser principal RSS/Atom/JSON
- **HTMLMetadataParser**: Extracción de metadatos web
- **DateParser**: Parseo inteligente de fechas

### Account - Gestión de Cuentas
- **LocalAccount**: Cuenta local
- **CloudKitAccount**: Sincronización con CloudKit
- **FeedbinAccount**: Integración con Feedbin
- **FeedlyAccount**: Integración con Feedly

## 🔄 Patterns de Interoperabilidad

### SwiftUI ↔ AppKit Bridge

**Problema:** Mezcla de tipos `SwiftUI.Font` vs `AppKit.NSFont`

**Solución:**
```swift
// ❌ Incorrecto
let font: Font = systemFont

// ✅ Correcto  
let font: Font = Font(systemFont as NSFont)
```

**Capa de Abstracción:**
- ViewModels manejan conversiones de tipos
- Views solo usan tipos de su framework
- Extensiones proporcionan conversiones seguras

### MainThreadOperation Pattern

**Uso:**
```swift
class MyOperation: MainThreadOperation {
    override func run() {
        // Tu lógica aquí
        finish() // Siempre llamar finish()
    }
}
```

**Consideraciones:**
- Siempre heredar de `MainThreadOperation` para operaciones async
- Usar `finish()` para notificar completación
- Implementar `isCanceled` para cancelación graceful

## 🔒 Consideraciones de Seguridad

### Gestión de Secretos
- **API Keys:** Variables de entorno o Keychain, nunca hardcodeadas
- **Certificates:** Solo en `DeveloperSettings.xcconfig` (gitignored)
- **Bundle IDs:** Configurados via `.xcconfig`, no en `project.pbxproj`

### Code Signing
- Usar `Apple Development` para desarrollo local
- Configurar `DEVELOPMENT_TEAM` en archivos `.xcconfig`
- Nunca commitear certificados o profiles

## 📊 Integración Continua

### Pre-commit Hooks
```bash
#!/bin/sh
# .git/hooks/pre-commit
./scripts/validate-project.sh
```

### CI/CD Pipeline
1. **Validation:** `validate-project.sh`
2. **Clean Build:** `clean-build.sh`
3. **Test:** Run unit tests
4. **Archive:** Build release version

## 🐛 Debugging y Profiling

### Herramientas Recomendadas
- **Instruments:** Para profiling de memoria y rendimiento
- **OSLog:** Para logging estructurado
- **SwiftLint:** Para análisis estático de código
- **Debug Menu:** Habilitado en `DeveloperSettings.xcconfig`

### Logging Strategy
```swift
import os

private static let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!, 
    category: "ModuleName"
)

logger.debug("Debug message")
logger.info("Info message") 
logger.error("Error: \(error.localizedDescription)")
```

---

## 📚 Referencias Adicionales

- [Swift Package Manager Guide](https://swift.org/package-manager/)
- [Xcode Build Configuration](https://developer.apple.com/documentation/xcode/build-configuration-reference)
- [iOS App Architecture Patterns](https://docs.anthropic.com/claude-code)

## 🤝 Contribution Guidelines

1. **Antes de codificar:** Ejecutar `./scripts/validate-project.sh`
2. **Durante desarrollo:** Seguir patterns establecidos en esta guía
3. **Antes de commit:** Verificar que no hay cambios manuales en `project.pbxproj`
4. **En Pull Requests:** Incluir evidencia de que `./scripts/clean-build.sh --build` funciona

---
*Última actualización: Julio 2025*