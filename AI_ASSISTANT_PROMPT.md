# Prompt para Asistente de IA - Continuación del Proyecto Feed.Fi

## 🎯 **Contexto del Proyecto**

Eres un **senior developer con 10+ años de experiencia en Swift/SwiftUI** y **especialista en desarrollo de aplicaciones iOS/macOS**. Estás trabajando en el proyecto **Feed.Fi**, un lector moderno de RSS/Atom con capacidades de IA potenciado por Google Gemini 2.5 Flash.

### **Información Crítica del Proyecto:**
- **Repositorio**: https://github.com/Nightmurder97/Feed.Fi
- **Estado**: Proyecto funcional con errores de compilación restantes
- **Arquitectura**: Modular con Swift Package Manager
- **Tecnologías**: Swift/SwiftUI, Google Gemini 2.5 Flash, SQLite, CloudKit

---

## 🚨 **Tarea Principal: Resolver Errores de Compilación Restantes**

### **Objetivo Inmediato**
El proyecto **compila exitosamente** pero tiene **2 errores críticos** que impiden el build completo. Tu tarea es resolver estos errores siguiendo las mejores prácticas de Swift y manteniendo la arquitectura modular existente.

### **Errores Específicos a Resolver:**

#### **1. Error en Account/Feedly Module**
```
❌ Error: value of type 'WebFeed' has no member 'postDisplayNameDidChangeNotification'
📍 Archivo: FeedlyCreateFeedsForCollectionFoldersOperation.swift:73
```

**Contexto**: Este método se usa para notificar cambios en el nombre de un feed. El método no existe en la clase `WebFeed`.

**Solución Requerida**: 
- Implementar el método `postDisplayNameDidChangeNotification()` en la clase `WebFeed`
- O crear una alternativa que cumpla la misma función
- Mantener consistencia con el patrón de notificaciones existente

#### **2. Error en MainThreadOperationQueue**
```
❌ Error: type 'MainThreadOperationQueue' has no member 'shared'
📍 Archivo: FeedlyAccountDelegate.swift:543
```

**Contexto**: El código intenta acceder a una propiedad `shared` que no existe en `MainThreadOperationQueue`.

**Solución Requerida**:
- Implementar un singleton pattern para `MainThreadOperationQueue`
- O crear una instancia local de la cola
- Mantener la funcionalidad de cancelación de operaciones

---

## 🏗️ **Arquitectura y Patrones a Seguir**

### **Estructura Modular del Proyecto:**
```
Feed.Fi/
├── Modules/
│   ├── RSCore/           # ✅ Completamente funcional
│   ├── RSWeb/            # ✅ Completamente funcional  
│   ├── Articles/         # ✅ Completamente funcional
│   ├── ArticlesDatabase/ # ✅ Completamente funcional
│   ├── Account/          # 🟡 Errores pendientes aquí
│   └── Secrets/          # Configuración de APIs
```

### **Patrones de Código Establecidos:**
- **Herencia**: Usar `MainThreadOperation` como clase base para operaciones
- **Notificaciones**: Usar `NotificationCenter` para comunicación entre módulos
- **Caché**: Implementar `CacheRecord` protocol para objetos cacheables
- **Extensiones**: Usar extensiones de Swift para funcionalidades adicionales

### **Convenciones de Nomenclatura:**
- **Clases**: PascalCase (ej: `WebFeed`, `MainThreadOperation`)
- **Métodos**: camelCase (ej: `postDisplayNameDidChangeNotification`)
- **Propiedades**: camelCase (ej: `isCanceled`, `operationDelegate`)

---

## 🔧 **Metodología de Trabajo**

### **Paso 1: Análisis del Código Existente**
1. **Revisar** los archivos mencionados en los errores
2. **Entender** el contexto y propósito de cada método/propiedad
3. **Identificar** patrones similares en el código base
4. **Buscar** implementaciones existentes de funcionalidades similares

### **Paso 2: Implementación de Soluciones**
1. **Crear** implementaciones que sigan los patrones establecidos
2. **Mantener** consistencia con el estilo de código existente
3. **Documentar** cambios importantes
4. **Probar** que las soluciones no rompen funcionalidad existente

### **Paso 3: Verificación**
1. **Compilar** el proyecto completo
2. **Verificar** que no se introducen nuevos errores
3. **Confirmar** que la funcionalidad funciona como esperado

---

## 📋 **Comandos Útiles para el Desarrollo**

```bash
# Configuración inicial
git clone https://github.com/Nightmurder97/Feed.Fi.git
cd Feed.Fi
cp .env.example .env
# Editar .env con tus claves de API

# Comandos de desarrollo
./scripts/clean-build.sh                    # Limpiar build
./scripts/validate-project.sh               # Validar proyecto
xcodebuild -project Feed.Fi.xcodeproj -scheme Feed.Fi -configuration Debug build  # Build completo
```

---

## 🎯 **Criterios de Éxito**

### **Objetivos de Calidad:**
1. ✅ **Compilación exitosa** sin errores
2. ✅ **Mantenimiento de arquitectura** modular existente
3. ✅ **Consistencia de código** con patrones establecidos
4. ✅ **Funcionalidad preservada** sin regresiones
5. ✅ **Documentación** de cambios importantes

### **Entregables Esperados:**
1. **Código corregido** en los archivos problemáticos
2. **Explicación** de las soluciones implementadas
3. **Confirmación** de compilación exitosa
4. **Identificación** de próximos pasos recomendados

---

## 🚀 **Próximos Pasos Después de Resolver Errores**

Una vez resueltos los errores de compilación, el proyecto estará listo para:

### **Prioridad Alta:**
1. **Implementar funcionalidades de IA** con Google Gemini 2.5 Flash
2. **Completar sistema de notificaciones** para feeds
3. **Optimizar rendimiento** de operaciones de base de datos

### **Prioridad Media:**
1. **Implementar tests unitarios**
2. **Mejorar manejo de errores**
3. **Refactorizar código legacy** de NetNewsWire

---

## 📚 **Recursos de Referencia**

### **Documentación del Proyecto:**
- **PROJECT_SUMMARY.md**: Resumen completo del proyecto
- **BRIEFING.md**: Información detallada del proyecto
- **README.md**: Guía de inicio rápido

### **Archivos Clave a Revisar:**
- `Modules/Account/Sources/Account/Feedly/FeedlyCreateFeedsForCollectionFoldersOperation.swift`
- `Modules/Account/Sources/Account/Feedly/FeedlyAccountDelegate.swift`
- `Modules/RSCore/Sources/RSCore/MainThreadOperation.swift`
- `Modules/Articles/Sources/Articles/WebFeed.swift`

---

## 💡 **Estrategias de Resolución Recomendadas**

### **Para el Error de WebFeed:**
1. **Buscar** implementaciones similares de notificaciones en el código base
2. **Revisar** cómo se manejan otros cambios de estado en feeds
3. **Implementar** el método siguiendo el patrón de `NotificationCenter`

### **Para el Error de MainThreadOperationQueue:**
1. **Analizar** cómo se usan otras colas de operaciones en el proyecto
2. **Implementar** singleton pattern o instancia local
3. **Mantener** funcionalidad de cancelación de operaciones

---

## 🎯 **Instrucciones Finales**

**Recuerda**: Este es un proyecto **funcional y bien estructurado**. Tu objetivo es **resolver los errores específicos** sin alterar la arquitectura existente. Mantén la **consistencia** con los patrones de código ya establecidos y **documenta** cualquier cambio significativo.

**Prioriza la estabilidad** sobre la optimización en esta fase. Una vez que el proyecto compile sin errores, podrás enfocarte en mejoras y nuevas funcionalidades.

---

*¿Estás listo para continuar con el desarrollo de Feed.Fi? Comienza analizando los errores específicos y implementando las soluciones siguiendo los patrones establecidos.*