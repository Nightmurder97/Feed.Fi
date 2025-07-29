# Feed.Fi (NetNewsWire Fork)

Feed.Fi es un lector de feeds RSS/Atom moderno, minimalista y enfocado en las noticias de criptomonedas, inversión y trading.  
Incluye integración de Inteligencia Artificial para resúmenes automáticos, análisis de sentimiento y sugerencias inteligentes sobre el mercado.

## Características principales

- Interfaz visual clara, moderna y minimalista (ver capturas en la carpeta `/screenshots`).
- Soporte para feeds RSS/Atom tradicionales.
- **Botón "Resumen IA"**: Genera un resumen automático del artículo usando IA (Gemini API de Google o modelo local).
- **Análisis de sentimiento**: Muestra un icono de tendencia (alcista/bajista/neutral) según el análisis automático del titular.
- **Panel de Insights IA**: Sugerencias breves sobre el posible impacto de la noticia en el mercado cripto.
- Preparado para personalizaciones visuales (paleta clara, tipografía grande, iconos minimalistas, sidebar translúcido).
- Listo para integración de otros servicios de IA o módulos de predicción.

---

## Prompt para Coding Assistant

> **Prompt para coding assistant (Copilot u otro):**
>
> 1. Refactoriza la interfaz de NetNewsWire para que tenga una estética moderna y minimalista, tipo macOS, similar a las capturas proporcionadas:
>     - Sidebar translúcido con fondo blur, navegación simple y espaciados amplios.
>     - Tipografía sans-serif grande, títulos destacados y mucho espacio en blanco.
>     - Lista de artículos con previsualización de imagen, iconos claros, y efecto hover.
>     - Vista de detalle centrada, con título grande, fuente del feed y destacados.
>     - Iconos minimalistas en barra de acciones (corazón, guardar, leer después, etc.) usando SF Symbols.
>
> 2. Integra funciones de Inteligencia Artificial:
>     - **Resumen IA**: Añadir botón en la vista de artículo para generar un resumen usando una API (ej: Gemini API de Google).
>     - **Análisis de sentimiento**: Detecta si el titular es positivo, negativo o neutral y muestra el resultado en la lista.
>     - **Panel de Insight IA**: En la vista de artículo, permite al usuario solicitar predicciones/sugerencias de la IA sobre el impacto de la noticia.
>     - El código de integración IA debe ser modular y permitir cambiar el proveedor (Gemini, Huggingface, modelo local).
>
> 3. Permite personalización de colores, icono y fuentes desde los assets del proyecto.
>
> 4. Añade instrucciones para desarrollo local, instalación de dependencias y uso de entornos virtuales si es necesario.

---

## Instalación y Entorno de Desarrollo

### 1. Requisitos previos

- Xcode (para desarrollo macOS/iOS; versión recomendada: 14+)
- Swift 5.7+
- [CocoaPods](https://cocoapods.org/) o [Swift Package Manager](https://swift.org/package-manager/) (según las dependencias)
- Python 3.10+ (si vas a usar scripts de IA externos o backend auxiliar)
- [pip](https://pip.pypa.io/en/stable/installation/) (para instalar dependencias Python)

### 2. Crear entorno virtual (opcional, para scripts IA Python)

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### 3. Instalación de dependencias (Swift)

- Si usas CocoaPods:  
  `pod install`
- Si usas Swift Package Manager:  
  Abre el proyecto en Xcode y resuelve los paquetes.

### 4. Variables de entorno

Crea un archivo `.env` (no lo subas a git) con tus claves de API para Gemini u otros proveedores:

```
GEMINI_API_KEY=tu_clave_aqui
```

### 5. Ejecutar la app

Abre el proyecto `Feed.Fi.xcodeproj` en Xcode y ejecuta.

---

## requirements.txt ejemplo (para funciones IA con Python)

```
google-generativeai>=0.3.0
python-dotenv>=1.0.0
requests>=2.31.0
```

---

## Notas

- La integración IA puede hacerse directamente en Swift o usando un microservicio Python si se prefiere.
- El icono y los assets visuales deben reemplazarse en `Assets.xcassets`.
- El código está preparado para futuras integraciones y personalizaciones.

---

## Licencia

[MIT License](LICENSE)

---