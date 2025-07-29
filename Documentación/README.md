# Feed.Fi

<img src="Technotes/Images/icon_1024.png" height="128" width="128" style="display: block; margin: auto;">

Feed.Fi es un lector de feeds RSS/Atom moderno, minimalista y enfocado en noticias de criptomonedas, inversión y trading. Incluye integración de Inteligencia Artificial para resúmenes automáticos, análisis de sentimiento y sugerencias inteligentes sobre el mercado.

## ✨ Características Principales

### 🎨 Interfaz Moderna y Minimalista
- **Sidebar translúcido** con efectos de blur y navegación simple
- **Tipografía clara** con fuentes sans-serif grandes y mucho espacio en blanco
- **Lista de artículos** con previsualización de imágenes y efectos hover
- **Vista de detalle centrada** con títulos grandes y destacados
- **Iconos minimalistas** usando SF Symbols en la barra de acciones

### 🤖 Integración de Inteligencia Artificial
- **Resumen IA**: Genera resúmenes automáticos de artículos usando Gemini API
- **Análisis de sentimiento**: Detecta tendencias alcistas/bajistas/neutrales en los titulares
- **Panel de Insights IA**: Sugerencias sobre el impacto potencial en el mercado cripto
- **Arquitectura modular**: Fácil cambio entre proveedores de IA (Gemini, OpenAI, etc.)

### 🎯 Enfoque en Criptomonedas
- Feeds especializados en noticias crypto, DeFi, NFTs y blockchain
- Análisis de impacto específico para diferentes criptomonedas
- Indicadores visuales de sentimiento del mercado
- Sugerencias de trading basadas en IA

### 🔧 Personalización Completa
- **Temas predefinidos**: Feed.Fi, Oscuro, Claro, y Personalizado
- **Colores customizables**: Personaliza cada elemento de la interfaz
- **Tipografía ajustable**: Controla tamaños y pesos de fuente
- **Layout configurable**: Espaciado, bordes redondeados, y más

## 🚀 Instalación y Configuración

### Requisitos Previos

- **macOS 12.0+** con Xcode 14+
- **Swift 5.7+**
- **Python 3.10+** (opcional, para scripts de IA)
- Cuenta de [Google AI Studio](https://makersuite.google.com/) para Gemini API

### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/Feed.Fi.git
cd Feed.Fi
```

### 2. Configurar Variables de Entorno

Copia el archivo de ejemplo y configura tu API key:

```bash
cp .env.example .env
```

Edita `.env` y añade tu clave de Gemini API:

```env
# Feed.Fi Environment Configuration
GEMINI_API_KEY=tu_clave_de_gemini_aqui
DEBUG_AI_LOGS=true
AI_REQUEST_TIMEOUT=30
```

### 3. Configurar Xcode

Crea un archivo `DeveloperSettings.xcconfig` para configuración local:

```bash
./setup.sh
```

O manualmente crea `SharedXcodeSettings/DeveloperSettings.xcconfig`:

```
CODE_SIGN_IDENTITY = Mac Developer
DEVELOPMENT_TEAM = TU_TEAM_ID
CODE_SIGN_STYLE = Automatic
ORGANIZATION_IDENTIFIER = com.tu-dominio.feedfi
DEVELOPER_ENTITLEMENTS = -dev
PROVISIONING_PROFILE_SPECIFIER =
```

### 4. Instalar Dependencias Python (Opcional)

Si planeas usar scripts de IA externos:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements_Version2.txt
```

### 5. Ejecutar la Aplicación

Abre `Feed.Fi.xcodeproj` en Xcode y ejecuta el proyecto.

## 🧠 Configuración de IA

### Gemini API Setup

1. Ve a [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Crea una nueva API key
3. Añádela a tu archivo `.env` como `GEMINI_API_KEY`

### Funciones de IA Disponibles

#### Resumen Automático
- Genera resúmenes concisos de artículos largos
- Enfocado en puntos clave para inversores y traders
- Disponible con un clic en la vista de artículo

#### Análisis de Sentimiento
- Analiza titulares para detectar tendencias alcistas/bajistas
- Indicadores visuales en la lista de artículos
- Colores: Verde (positivo), Rojo (negativo), Gris (neutral)

#### Market Insights
- Predicciones sobre impacto en el mercado
- Identificación de criptomonedas relacionadas
- Nivel de confianza del análisis
- Horizonte temporal del impacto

## 🎨 Personalización

### Temas Disponibles

- **Feed.Fi**: Tema por defecto con colores azules y diseño limpio
- **Oscuro**: Perfecto para uso nocturno
- **Claro**: Diseño minimalista con fondo blanco
- **Personalizado**: Crea tu propio esquema de colores

### Configuración de Apariencia

Accede a **Preferencias → Apariencia** para:

- Cambiar esquemas de color
- Ajustar tipografía y tamaños de fuente
- Modificar espaciado y elementos de layout
- Personalizar iconos y efectos visuales

### Customización de Colors

```swift
// Ejemplo de personalización programática
let themeManager = ThemeManager.shared
themeManager.updateColor(.accent, color: .purple)
themeManager.updateColor(.positive, color: .green)
```

## 📁 Estructura del Proyecto

```
Feed.Fi/
├── Mac/                          # Aplicación macOS
│   ├── MainWindow/
│   │   ├── Sidebar/             # Sidebar moderna con blur
│   │   ├── Timeline/            # Lista de artículos
│   │   └── Detail/              # Vista de detalle con IA
│   └── Preferences/             # Configuraciones
├── Shared/                      # Código compartido
│   ├── AI/                      # Integración de IA
│   │   ├── AIService.swift      # Protocolo base
│   │   └── GeminiAIService.swift # Implementación Gemini
│   ├── Configuration/           # Configuración de app
│   └── Customization/           # Sistema de temas
├── Modules/                     # Dependencias modulares
└── Widget/                      # Widget de macOS
```

## 🔧 Desarrollo

### Arquitectura de IA

El sistema de IA está diseñado de forma modular:

```swift
protocol AIServiceProtocol {
    func summarizeArticle(_ content: String) -> AnyPublisher<String, Error>
    func analyzeSentiment(_ text: String) -> AnyPublisher<SentimentResult, Error>
    func generateMarketInsight(_ article: String) -> AnyPublisher<MarketInsight, Error>
}
```

### Añadir Nuevos Proveedores de IA

1. Implementa `AIServiceProtocol`
2. Añade el proveedor a `AIProvider` enum
3. Actualiza `AIServiceManager` para instanciar tu servicio

### Testing

```bash
# Ejecutar tests unitarios
xcodebuild test -scheme NetNewsWire -destination 'platform=macOS'

# Tests de UI (si están disponibles)
xcodebuild test -scheme NetNewsWire-UI-Tests -destination 'platform=macOS'
```

## 🤝 Contribuir

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit tus cambios (`git commit -am 'feat: añadir nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crea un Pull Request

### Estilo de Código

- Sigue las convenciones de Swift
- Usa TypeScript para scripts cuando sea posible
- Mantén líneas bajo 100 caracteres
- Usa trailing commas en objetos y arrays
- Documenta APIs públicas con JSDoc/DocC

## 📄 Licencia

Este proyecto está basado en [NetNewsWire](https://github.com/Ranchero-Software/NetNewsWire) y mantiene la misma licencia MIT.

```
MIT License

Copyright (c) 2024 Feed.Fi Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

## 🙏 Agradecimientos

- **Equipo NetNewsWire**: Por crear la base sólida sobre la que construimos
- **Google**: Por proporcionar la Gemini API para funcionalidades de IA
- **Comunidad de desarrolladores**: Por las librerías y herramientas utilizadas

## 📞 Soporte

- **Issues**: [GitHub Issues](https://github.com/tu-usuario/Feed.Fi/issues)
- **Discusiones**: [GitHub Discussions](https://github.com/tu-usuario/Feed.Fi/discussions)
- **Email**: soporte@feedfi.com

---

**Feed.Fi** - *El futuro de las noticias crypto con IA* 🚀