# 🚀 Instrucciones para Cursor - CoinpediaPRO

## 🎯 Arquitectura del Proyecto

**CoinpediaPRO** es un sistema de análisis de criptomonedas que procesa datos de TradingView para generar rankings y oportunidades de trading. La arquitectura se basa en:

### Componentes Principales
- **Pipeline de Datos**: `coinpedia_pipeline.py` - Procesa 8 archivos CSV de TradingView
- **Sistema de Prompts Modulares**: Prompts especializados en `prompts/` para diferentes tipos de análisis
- **Algoritmos de Scoring**: Momentum, Fundamental y Sentiment scores (0-10)
- **Gestión de Modelos**: Optimización automática según tipo de tarea

### Flujo de Datos
```
TradingView CSV → coinpedia_pipeline.py → Normalización → Scoring → Top-10 Ranking
```

## 🔧 Patrones de Desarrollo

### Estructura de Archivos CSV
El proyecto espera 8 archivos CSV específicos de TradingView:
- `Overview.csv` - Snapshot general del mercado
- `Performance.csv` - Returns históricos multi-timeframe
- `Technicals.csv` - Indicadores técnicos y ratings
- `Sentiment.csv` - Métricas sociales y comunitarias
- `Addresses.csv` - Adopción de red y distribución
- `Transaction.csv` - Actividad on-chain y volúmenes
- `Valuation.csv` - Métricas de valoración y capitalización
- `GainsLoss.csv` - Distribución profit/loss de holders

### Convenciones de Nomenclatura
- **Archivos de datos**: Usar sufijos descriptivos (ej: `TOP1000_Technical.csv`)
- **Scripts Python**: Nombres descriptivos con guiones bajos (`coinpedia_pipeline.py`)
- **Documentación**: Archivos `.md` con nombres descriptivos

### Algoritmos de Scoring
```python
# Momentum Score (0-10)
momentum_score = (
    rsi_normalized * 0.25 +
    technical_rating * 0.25 +
    perf_1w_normalized * 0.25 +
    perf_1m_normalized * 0.25
) * 10

# Fundamental Score (0-10)
fundamental_score = (
    rank_inverse * 0.3 +
    active_ratio * 0.25 +
    tx_efficiency * 0.25 +
    nvt_inverse * 0.2
) * 10
```

## 🚀 Workflows de Desarrollo

### Procesamiento de Datos
```bash
# Ejecutar pipeline completo
python coinpedia_pipeline.py --data_dir ./Data/csv/ --output top10.csv

# Convertir CSV a JSON
python convert_csv_to_json.py
```

### Gestión de Dependencias
```bash
# Instalar dependencias
pip install -r requirements.txt

# Dependencias principales
pandas>=1.5.0
numpy>=1.23.0
```

### Estructura de Carpetas
```
CoinpediaPRO/
├── Data/
│   ├── csv/          # Archivos CSV de TradingView
│   ├── json/         # Datos convertidos a JSON
│   └── md/           # Documentación en markdown
├── prompts/          # Sistema de prompts modulares
├── coinpedia_pipeline.py  # Pipeline principal
└── *.md             # Documentación del proyecto
```

## 🎯 Patrones de Integración

### TradingView Integration
- **Auto-detección**: El sistema detecta automáticamente el tipo de archivo CSV
- **Validación**: Verifica columnas requeridas antes del procesamiento
- **Normalización**: Convierte strings con sufijos (K, M, B) a números
- **Merge inteligente**: Combina múltiples archivos por símbolo de token

### Sistema de Prompts
- **Modular**: Prompts especializados para cada tipo de análisis
- **Context-aware**: Carga automática según tipo de consulta
- **Model-optimized**: Recomienda modelo óptimo para cada tarea

## ⚠️ Consideraciones Críticas

### Manejo de Datos
- **Validación robusta**: Siempre verificar tipos de datos y rangos
- **Manejo de outliers**: Detectar y flaggear valores anómalos
- **Normalización**: Convertir diferentes formatos de números (1.2K → 1200)

### Optimización de Modelos
- **GPT-4o**: Para procesamiento CSV y análisis de datos
- **o3**: Para cálculos cuantitativos complejos y backtesting
- **o4-mini**: Para métricas rápidas y cálculos básicos

### Seguridad
- **Variables de entorno**: Manejar secretos y claves API
- **Validación de entrada**: Sanitizar datos de TradingView
- **Backup**: Hacer copias antes de operaciones críticas

## 📊 Ejemplos de Uso

### Procesamiento de CSV
```python
# Cargar y procesar archivo
df = load_dataset('Data/csv/TOP1000_Technical.csv')
df = clean_numeric_columns(df)
scores = compute_scores(df)
```

### Análisis de Momentum
```python
# Calcular momentum score
momentum = (
    normalize_rsi(rsi_value) * 0.25 +
    technical_rating_score(rating) * 0.25 +
    normalize_performance(perf_1w) * 0.25 +
    normalize_performance(perf_1m) * 0.25
) * 10
```

## 🔄 Comandos de Desarrollo

### Setup Inicial
```bash
# Crear estructura de carpetas
mkdir -p Data/{csv,json,md} prompts/{core,analysis,data-processing,strategies}

# Instalar dependencias
pip install pandas numpy

# Ejecutar pipeline de prueba
python coinpedia_pipeline.py --data_dir ./Data/csv/ --output test_output.csv
```

### Debugging
```bash
# Verificar estructura de archivos CSV
head -5 Data/csv/TOP1000_*.csv

# Validar pipeline
python -c "import coinpedia_pipeline; print('Pipeline OK')"
```

## 📝 Documentación

### Archivos Clave
- `coinpedia_project_structure.md` - Estructura completa del proyecto
- `main_project_instructions.md` - Instrucciones principales
- `prompt_tradingview_csv.md` - Protocolo de procesamiento CSV
- `setup_guide_complete.md` - Guía de implementación

### Patrones de Documentación
- Usar formato markdown con emojis para secciones
- Incluir ejemplos de código específicos
- Documentar solo problemas complejos y soluciones sustanciales
- Mantener documentación actualizada con cambios en el pipeline 