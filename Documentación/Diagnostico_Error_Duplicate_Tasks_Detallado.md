# Diagnóstico Detallado: Error "Unexpected duplicate tasks"

## 🔍 **Análisis del project.pbxproj**

### **Referencias Duplicadas Encontradas:**

#### **RSCore en Frameworks (múltiples targets):**
```
848E84CD2DB749440023F3BA /* RSCore in Frameworks */
848E84D02DB7495C0023F3BA /* RSCore in Frameworks */
848E84D52DB749670023F3BA /* RSCore in Frameworks */
848E84D82DB749720023F3BA /* RSCore in Frameworks */
848E84DB2DB749860023F3BA /* RSCore in Frameworks */
848E84DF2DB749A40023F3BA /* RSCore in Frameworks */
```

#### **RSCore en Embed Frameworks (múltiples targets):**
```
848E84CE2DB749440023F3BA /* RSCore in Embed Frameworks */
848E84D32DB7495C0023F3BA /* RSCore in Embed Frameworks */
848E84D62DB749670023F3BA /* RSCore in Embed Frameworks */
```

#### **Product References Duplicadas:**
```
848E84CC2DB749440023F3BA /* RSCore */
848E84D12DB7495C0023F3BA /* RSCore */
848E84D42DB749670023F3BA /* RSCore */
848E84D72DB749720023F3BA /* RSCore */
848E84DA2DB749860023F3BA /* RSCore */
848E84DE2DB749A40023F3BA /* RSCore */
```

## 🎯 **Causa Raíz Identificada**

### **Problema Principal:**
El framework RSCore está siendo referenciado **múltiples veces** en diferentes targets del proyecto, causando:
1. **Tareas duplicadas de CodeSign**
2. **Tareas duplicadas de Copy**
3. **Conflictos en el build system**

### **Análisis de Targets:**
Basado en los GUIDs encontrados, parece que RSCore está siendo incluido en:
- Target principal (Feed.Fi)
- Share Extension
- Safari Extension
- Posiblemente otros targets

## 🛠️ **Soluciones Propuestas**

### **Opción 1: Limpieza Manual en Xcode**
1. **Abrir Xcode** y ir al proyecto
2. **Seleccionar cada target** y revisar "Build Phases"
3. **En "Embed Frameworks"**: Eliminar referencias duplicadas a RSCore
4. **En "Link Binary With Libraries"**: Eliminar referencias duplicadas a RSCore
5. **Mantener solo una referencia** por target

### **Opción 2: Limpieza en project.pbxproj**
1. **Identificar referencias duplicadas** por GUID
2. **Eliminar entradas duplicadas** en las secciones:
   - `PBXBuildFile`
   - `PBXFrameworksBuildPhase`
   - `PBXCopyFilesBuildPhase`
3. **Mantener solo una referencia** por target

### **Opción 3: Recrear Referencias de Paquetes**
1. **Eliminar todas las referencias** a RSCore del proyecto
2. **Re-importar RSCore** como Swift Package
3. **Verificar que solo se cree una referencia** por target

## 📊 **Estado Actual**

| Componente | Estado | Notas |
|------------|--------|-------|
| **Código Swift** | ✅ Funcional | Sin errores de compilación |
| **APIs CloudKit** | ✅ Modernas | Actualizadas correctamente |
| **Referencias RSCore** | ❌ Duplicadas | Múltiples GUIDs para el mismo framework |
| **Build System** | ❌ Falla | Tareas duplicadas detectadas |
| **App Ejecutable** | ❌ No disponible | Bloqueado por tareas duplicadas |

## 🔧 **Próximos Pasos Recomendados**

### **Paso 1: Análisis en Xcode**
- Abrir el proyecto en Xcode
- Revisar Build Phases de cada target
- Identificar referencias duplicadas visualmente

### **Paso 2: Limpieza Selectiva**
- Eliminar referencias duplicadas manteniendo una por target
- Verificar que Swift Package Manager gestione las dependencias

### **Paso 3: Verificación**
- Limpiar DerivedData
- Recompilar proyecto
- Verificar que no haya tareas duplicadas

## 📝 **Comandos de Diagnóstico**

```bash
# Buscar referencias duplicadas en project.pbxproj
grep -n "RSCore" Feed.Fi.xcodeproj/project.pbxproj

# Limpiar cachés
rm -rf ~/Library/Developer/Xcode/DerivedData/Feed.Fi-*

# Verificar paquetes Swift
swift package resolve
```

## 🎯 **Objetivo**

**Eliminar todas las referencias duplicadas a RSCore manteniendo solo una referencia válida por target, permitiendo que la app se compile y ejecute correctamente.**

---

**Fecha**: 28 de enero de 2025  
**Proyecto**: Feed.Fi  
**Prioridad**: Crítica (bloquea la ejecución)