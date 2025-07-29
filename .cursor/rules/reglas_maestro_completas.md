# 🚀 Reglas Maestro para Cursor AI (Universal)

Este documento es el protocolo operativo fundamental para cualquier instancia de Cursor AI, diseñado para guiar su interacción, análisis, desarrollo y documentación en CUALQUIER proyecto de software. Se enfoca en la sistematicidad, la autonomía informada y la generación de valor directo.

---

## 🎯 1. Principios Operativos Fundamentales

Estas reglas son de CUMPLIMIENTO OBLIGATORIO en todas las interacciones y tareas.

### 1.1 Comunicación
- **Idioma**: Siempre responder en español.
- **Minimización de Chat**: Reducir la comunicación en el chat; toda la información persistente o relevante para el proyecto se documenta en archivos `.md`.
- **Formato Estándar**: Utilizar un formato de comunicación estándar y claro entre IAs.
- **Preferir Documentación**: Las explicaciones detalladas y los hallazgos deben priorizar la documentación en archivos sobre la explicación directa en el chat.

### 1.2 Seguridad
- **Manejo de Secretos**: Asegurarse de que las claves API, credenciales y otros secretos se manejen EXCLUSIVAMENTE mediante variables de entorno.
- **Control de Versiones (`.gitignore`)**: Verificar que los archivos `.env` (o equivalentes) estén SIEMPRE incluidos en `.gitignore`.
- **Operaciones de Git Críticas**: Antes de cualquier operación que reescriba el historial de Git (ej. `git filter-repo`), hacer una COPIA DE SEGURIDAD completa del repositorio y verificar si hay repositorios Git anidados (eliminar su `.git/` si no son submódulos intencionales).
- **Commits**: Realizar commits frecuentes y pequeños, y sincronizar (`git pull`) a menudo con la rama remota.

### 1.3 Diagnóstico
- **Síntomas Precisos**: SIEMPRE solicitar al usuario los síntomas observables de forma precisa (qué ve en pantalla, mensajes de error, comportamientos inesperados).
- **Evidencia Visual/Logs**: SIEMPRE solicitar capturas de pantalla o logs de la consola del navegador para errores de UI/runtime.
- **Investigación Exhaustiva**: ANTES DE CODIFICAR, realizar una investigación exhaustiva de los archivos relevantes (componentes afectados, utilidades, archivos de configuración como `package.json`, `vite.config.ts`, `tsconfig.json`, `requirements.txt`, etc.).
- **Causa Raíz**: Identificar la causa raíz técnica del problema, no solo el síntoma superficial.
- **Librerías Externas**: CONSIDERAR el contexto y las limitaciones de librerías externas (ej., `tanstack/react-virtual`, APIs de terceros, etc.).

### 1.4 Implementación
- **Soluciones Robustas**: Priorizar soluciones robustas, escalables y mantenibles sobre parches rápidos.
- **Refactorización Centralizada**: Cuando se refactorice lógica centralizada, asegurar que TODOS los componentes que la consumen sean actualizados consistentemente.
- **Aislamiento de Problemas**: Para errores de runtime o TypeScript en proyectos complejos, considerar la simplificación temporal del componente principal para aislar el problema y luego restaurar gradualmente.
- **Manejo Defensivo**: Incluir validaciones robustas y manejo de casos límite (ej., `null`, `0`, `NaN`, `Infinity`) en funciones críticas, especialmente en cálculos matemáticos.
- **Optimización de Recursos**: Optimizar el rendimiento considerando los recursos (ej., reducir llamadas a API, optimizar prompts de IA).

### 1.5 Documentación
- **Criterios de Documentación**: Documentar ÚNICAMENTE problemas complejos, apartados importantes del proceso, y grandes problemas que cuestan resolver.
- **Evitar lo Trivial**: NO documentar pasos menores, acciones obvias o pequeños chequeos rutinarios.
- **Enfoque en Valor**: Enfocarse en desafíos técnicos significativos, análisis de causa raíz y soluciones sustanciales que proporcionen valor de aprendizaje.
- **Formato Estructurado**: Usar formato Problema/Solución/Herramientas solo para cuestiones que requieren pensamiento técnico o resolución no trivial.
- **Actualización Continua**: Mantener la documentación actualizada con los cambios en el proyecto.

---

## 🎯 2. Marco de Análisis y Entendimiento de Proyectos (Universal)

Al interactuar con un nuevo codebase, Cursor AI debe seguir este marco para construir una comprensión profunda y sistemática.

### 2.1 Visión General del Proyecto (`Project Prompt / Principal Instructions`)
- **Propósito**: Comprender el contexto, problemas, objetivos y tareas principales del proyecto.
- **Ubicación**: Buscar archivos como `main_project_instructions.md`, `README.md`, o similares.
- **Estructura Esperada**:
    - **Contexto del Proyecto**: Descripción, problemas actuales, objetivo.
    - **Tareas Principales**: Fases y pasos de ejecución (en orden).
    - **Instrucciones Específicas**: Variables de entorno, dependencias exactas, convenciones críticas (ej. colores RGB).
    - **Resultado Esperado**: Criterios de éxito de la aplicación.
    - **Troubleshooting**: Pasos para problemas comunes.
    - **Entregables**: Lista de artefactos a producir.

### 2.2 Estructura del Codebase y Patrones (`Project Structure Template`)
- **Propósito**: Mapear la organización de archivos y directorios, e identificar patrones de diseño y convenciones.
- **Ubicación**: Buscar `coinpedia_project_structure.md`, `project_structure.md`, o realizar `ls -R` inicial.
- **Elementos Clave a Identificar**:
    - **Carpetas Principales**: `src/`, `backend/`, `frontend/`, `data/`, `prompts/`, `config/`, `documentation/`.
    - **Patrones de Nomenclatura**: Sufijos, guiones bajos, mayúsculas/minúsculas.
    - **Componentes Mayores**: Identificar módulos, servicios, librerías personalizadas.
    - **Flujo de Datos Principal**: Cómo se mueven los datos entre componentes y servicios.

### 2.3 Flujos de Trabajo de Desarrollo (`Workflows & Execution Checklist Templates`)
- **Propósito**: Entender cómo se construye, prueba, depura y despliega el proyecto.
- **Ubicación**: Buscar `setup_guide_complete.md`, `background_agent_checklist.md`, `environment_setup_guide.md`, o scripts en `scripts/`, `utils/`.
- **Workflows Críticos a Identificar**:
    - **Configuración Inicial**: Comandos para clonar, instalar dependencias (`pip install`, `npm install`), configurar variables de entorno.
    - **Build/Compilación**: Comandos para construir el proyecto.
    - **Testing**: Comandos para ejecutar tests unitarios, de integración, end-to-end.
    - **Ejecución/Inicio**: Comandos para levantar la aplicación o scripts.
    - **Depuración**: Estrategias de logging, herramientas.

### 2.4 Patrones de Integración y Dependencias (`Integration Patterns`)
- **Propósito**: Comprender cómo el proyecto interactúa con sistemas externos y otros componentes internos.
- **Ubicación**: Revisar `package.json`, `requirements.txt`, archivos de configuración de API, módulos de integración.
- **Patrones Clave a Identificar**:
    - **APIs Externas**: Cómo se configuran y utilizan (ej. TradingView API, CoinGecko).
    - **Comunicación entre Servicios**: REST, GraphQL, WebSockets, RPC.
    - **Bases de Datos**: Conexiones, ORMs, esquemas.
    - **Manejo de Archivos**: Formatos esperados (CSV, JSON), pipelines de procesamiento.
    - **Integración con IA/Herramientas**: Cómo se utilizan otras IAs o herramientas CLI.

---

## 🎯 3. Estándares de Documentación y Reportes (Universal)

Cursor AI debe adherirse a estos estándares para generar documentación y reportes claros, concisos y útiles.

### 3.1 Documentación General
- **Archivos `.md`**: Preferir el formato Markdown para toda la documentación en archivos.
- **Ubicación**: La documentación debe residir en directorios lógicos (ej. `documentation/`, `prompts/`, `Data/md/`).
- **Nomenclatura**: Nombres de archivo descriptivos con guiones (`-`) o guiones bajos (`_`) para separar palabras.

### 3.2 Reportes de Progreso y QA (`Pull Request Template`, `Execution Checklist`)
- **Pull Requests (PRs)**: Utilizar una plantilla exhaustiva para los PRs que resuma logros, cambios técnicos, mejoras de UI/UX, nuevas características y resultados de pruebas.
    - **Secciones Clave**: Sumario, cambios técnicos, UI/UX, nuevas características, cambios de configuración, cambios en estructura de archivos, testing/QA, directrices de revisión.
- **Checklists de Ejecución**: Utilizar checklists paso a paso para verificar el progreso, la configuración y el funcionamiento, especialmente para agentes en segundo plano.

### 3.3 Reportes de Investigación y Análisis (`Research Report`, `Extraction Summary`)
- **Reportes de Investigación**: Estructurar los informes de investigación para analizar el panorama de desarrollo asistido por IA, destacando avances, tecnologías clave y recomendaciones arquitectónicas.
- **Resúmenes de Extracción Web**: Documentar los esfuerzos de extracción de datos, incluyendo contenido extraído, tasas de éxito y extractores utilizados.

---

## 🎯 4. Directrices para Workflows Especializados (Universal)

Estas directrices son para tareas comunes de desarrollo y operaciones de IA.

### 4.1 Orquestación Multi-IA (`Multi-AI Orchestration System / Technical Protocol`)
- **Objetivo**: Coordinar múltiples IAs en paralelo de forma eficiente.
- **Arquitectura**: Comprender modelos de capas (ej. 4 capas: Coordinación, Especialización, Base de Conocimiento, Interfaz).
- **Roles**: Identificar y respetar roles primarios (Creadores, Analizadores, Validadores, Integradores, Reporteros) y secundarios (Monitores, Sincronizadores).
- **Protocolos de Comunicación**: Usar un canal principal de estado global y tipos de mensaje estándar (`STATUS_UPDATE`, `TASK_COMPLETED`).
- **Descomposición de Tareas**: Aplicar algoritmos universales de división de tareas.

### 4.2 Optimización de Entorno y Rendimiento (`Indexing Optimization`, `Universal Project Initial Configuration`)
- **Configuración Inicial**: Seguir una guía universal para la configuración inicial de cualquier proyecto (entorno virtual, dependencias, control de versiones, calidad de código).
- **Optimización de Indexación**: Si hay problemas de rendimiento de IDE (ej. Cursor), crear o actualizar `.cursorignore` para excluir archivos innecesarios (ej. grandes archivos de datos, `node_modules`, `build/`).

### 4.3 Manejo y Reutilización de Scripts (`Reusable Scripts System`, `Script Cleanup Report`)
- **Sistema Reutilizable**: Preferir la reutilización de scripts existentes (ej. en una carpeta `@/Scripts` o `utils/`) en lugar de crear nuevos para cada tarea similar.
    - **Estructura**: Identificar scripts principales y scripts reutilizables.
    - **Configuración Centralizada**: Buscar archivos de configuración para adaptar scripts sin modificarlos directamente.
- **Limpieza de Scripts**: Realizar informes de limpieza de scripts para documentar la eliminación de código duplicado u obsoleto y los beneficios obtenidos.

### 4.4 Procesamiento de Datos y Análisis (Estructura de Carpetas `Data/`, `prompts/`)
- **Origen de Datos**: Reconocer los tipos de archivos esperados (ej. CSV, JSON, XML).
- **Pipelines de Procesamiento**: Identificar scripts de pipeline (ej. `process_data.py`, `etl_script.py`) para limpieza, normalización, scoring, etc.
- **Prompts Modulares**: Entender la organización de prompts en subcarpetas (ej. `prompts/core`, `prompts/analysis`, `prompts/data-processing`, `prompts/strategies`) y cargar los relevantes según la tarea.
- **Algoritmos de Scoring**: Reconocer la lógica de cálculo de scores o métricas.

---

## ✅ Lista de Verificación Final para Cursor AI

Antes de considerar una tarea completada, Cursor AI debe confirmar:

- [ ] Todas las **Reglas Universales** se han seguido estrictamente.
- [ ] El **Marco de Análisis de Proyectos** se ha aplicado para entender el codebase.
- [ ] Los **Estándares de Documentación y Reportes** se han cumplido.
- [ ] Las **Directrices de Workflows Especializados** se han implementado según la tarea.
- [ ] El **Usuario** ha sido informado adecuadamente (según las reglas de comunicación).
- [ ] Se han realizado los **Commits** adecuados siguiendo la estrategia definida.

---

## 📋 Reglas Específicas del Usuario

### Comunicación
- Always respond in spanish.
- Minimizar comunicación en chat - Todo se documenta en archivos .md.
- Usar formato estándar de comunicación entre IAs.
- Preferir documentación en archivos sobre explicaciones en chat.

### Seguridad
- Asegúrate de que los secretos (claves API, credenciales) se manejen siempre mediante variables de entorno y que los archivos .env estén en .gitignore.
- Antes de cualquier operación que reescriba el historial de Git (ej. git filter-repo), HAZ COPIA DE SEGURIDAD y verifica si hay repositorios Git anidados (elimina su .git/ si no son submódulos intencionales).
- Haz commits frecuentes y pequeños. Sincroniza (git pull) a menudo con la rama remota.

### Diagnóstico
- SIEMPRE pedir al usuario los síntomas observables de forma precisa (qué ve en pantalla, mensajes de error).
- SIEMPRE solicitar capturas de pantalla o logs de la consola del navegador para errores de UI/runtime.
- ANTES DE CODIFICAR, realizar una investigación exhaustiva de los archivos relevantes (componentes afectados, utilidades, configuración como package.json, vite.config.ts, tsconfig.json).
- Identificar la causa raíz técnica del problema, no solo el síntoma superficial.
- CONSIDERAR el contexto de librerías externas (ej., tanstack/react-virtual, CoinGecko API) y sus limitaciones.

### Implementación
- Priorizar soluciones robustas y escalables sobre parches rápidos.
- Cuando se refactorice lógica centralizada, asegurarse de que TODOS los componentes que la consumen sean actualizados.
- Para errores de runtime o TypeScript en proyectos complejos, considerar la simplificación temporal del componente principal para aislar el problema y luego restaurar gradualmente.
- Manejo defensivo de código: Incluir validaciones robustas y manejo de casos límite (ej., null, 0, NaN, Infinity) en funciones críticas, especialmente en cálculos matemáticos.
- Optimizar el rendimiento considerando los recursos (ej., reducir llamadas a API, optimizar prompts de IA).

### Documentación
- Documentar ÚNICAMENTE problemas complejos, apartados importantes del proceso, y grandes problemas que cuestan resolver.
- NO documentar pasos menores, acciones obvias, o pequeños chequeos rutinarios.
- Enfocarse en desafíos técnicos significativos, análisis de causa raíz, y soluciones sustanciales que proporcionen valor de aprendizaje.
- Usar formato Problema/Solución/Herramientas solo para cuestiones que requieren pensamiento técnico o resolución no trivial.

### Preferencias Específicas
- El usuario prefiere que el asistente reutilice scripts existentes en la carpeta @/Scripts en lugar de crear nuevos scripts para cada nueva lista de tokens.
- Cuando el asistente crea scripts de extracción para sitios (por ejemplo TradingView u otros), el usuario prefiere que se documente todo el proceso para su reutilización en proyectos futuros.
- The user prefers that the assistant explain what it will do before proceeding.
- The user prefers that the assistant always specifies the source of origin when providing information.
- The user prefers file names with words separated by underscores, first letter uppercase, starting with the ticker (e.g., BTC_Whitepaper_Versión_Año.extension) and keeping the original file extension.
- In this project, we use suffixes on filenames to denote alternative or versioned file variants. 