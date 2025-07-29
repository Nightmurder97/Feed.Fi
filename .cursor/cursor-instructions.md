# 🚀 Instrucciones para Cursor - Laravel Notification Log

## 🎯 Arquitectura del Proyecto

**Laravel Notification Log** es un paquete de Spatie que registra automáticamente todas las notificaciones enviadas por una aplicación Laravel. La arquitectura se basa en:

### Componentes Principales
- **Event Subscriber**: `NotificationEventSubscriber` - Escucha eventos de Laravel para capturar notificaciones
- **Modelo de Log**: `NotificationLogItem` - Almacena registros de notificaciones enviadas
- **Traits de Historia**: `HasHistory` y `HasNotifiableHistory` - Proporcionan métodos de consulta
- **Actions**: `ConvertNotificationSendingEventToLogItemAction` - Convierte eventos en registros

### Flujo de Datos
```
Notification Event → Event Subscriber → Convert Action → NotificationLogItem → Database
```

## 🔧 Patrones de Desarrollo

### Estructura de Eventos
El paquete escucha dos eventos principales de Laravel:
- `NotificationSending` - Se dispara antes de enviar una notificación
- `NotificationSent` - Se dispara después de enviar una notificación

### Convenciones de Nomenclatura
- **Namespaces**: `Spatie\NotificationLog\` para todas las clases del paquete
- **Traits**: Usar sufijos `Has*` para traits que añaden funcionalidad a modelos
- **Actions**: Usar sufijo `Action` para clases que ejecutan lógica específica
- **Configuración**: Archivos en `config/` con nombres descriptivos

### Patrones de Consulta
```php
// Consulta básica de notificaciones enviadas
$user->notificationLogItems();

// Consulta con filtros avanzados
$user->latestLoggedNotification(
    fingerprint: 'unique-fingerprint',
    notificationTypes: ['App\Notifications\Welcome'],
    channel: 'mail'
);

// Verificar si ya se envió
$notification->wasAlreadySentTo($user)->inThePastMinutes(60);
```

## 🚀 Workflows de Desarrollo

### Configuración del Entorno
```bash
# Instalar dependencias
composer install

# Ejecutar tests
composer test

# Formatear código
composer format

# Análisis estático
composer analyse
```

### Testing
- **Framework**: Pest PHP con Orchestra Testbench
- **Estructura**: Tests en `tests/` con soporte en `tests/TestSupport/`
- **Factories**: `NotificationLogItemFactory` y `UserFactory` para datos de prueba
- **Channels de Prueba**: `DummyChannel` para simular envío de notificaciones

### Migraciones
- **Ubicación**: `database/migrations/create_notification_log_items_table.php`
- **Campos Clave**: `notifiable_type`, `notifiable_id`, `notification_type`, `channel`, `fingerprint`
- **Relaciones**: Polymorphic con `notifiable` para soportar cualquier modelo

## 🔍 Patrones de Integración

### Configuración del Paquete
```php
// config/notification-log.php
return [
    'model' => NotificationLogItem::class,
    'prune_after_days' => 30,
    'log_all_by_default' => true,
    'actions' => [
        'convertEventToModel' => ConvertNotificationSendingEventToLogItemAction::class,
    ],
];
```

### Uso en Notificaciones
```php
// Añadir trait a notificaciones
use Spatie\NotificationLog\Models\Concerns\HasHistory;

class WelcomeNotification extends Notification
{
    use HasHistory;
    
    // Método opcional para controlar logging
    public function shouldLog(NotificationSending $event): bool
    {
        return true; // o lógica personalizada
    }
    
    // Fingerprint para agrupar notificaciones similares
    public function fingerprint(): ?string
    {
        return 'welcome-' . $this->user->id;
    }
}
```

### Uso en Modelos Notificables
```php
// Añadir trait a modelos que reciben notificaciones
use Spatie\NotificationLog\Models\Concerns\HasNotifiableHistory;

class User extends Authenticatable
{
    use HasNotifiableHistory;
    
    // Consultar historial de notificaciones
    public function getNotificationHistory()
    {
        return $this->notificationLogItems;
    }
}
```

## 🛠️ Personalización Avanzada

### Modelo Personalizado
```php
// Crear modelo personalizado
class CustomNotificationLogItem extends NotificationLogItem
{
    // Lógica personalizada
}

// Configurar en config/notification-log.php
'model' => CustomNotificationLogItem::class,
```

### Action Personalizada
```php
// Extender action para lógica personalizada
class CustomConvertAction extends ConvertNotificationSendingEventToLogItemAction
{
    protected function getExtra(NotificationSending $event): array
    {
        return [
            'custom_field' => 'custom_value',
            'user_agent' => request()->userAgent(),
        ];
    }
}

// Configurar en config/notification-log.php
'actions' => [
    'convertEventToModel' => CustomConvertAction::class,
],
```

## 📊 Estructura de Base de Datos

### Tabla `notification_log_items`
- `id` - Primary key
- `notifiable_type` - Clase del modelo notificable
- `notifiable_id` - ID del modelo notificable
- `notification_type` - Clase de la notificación
- `channel` - Canal usado (mail, database, etc.)
- `fingerprint` - Identificador único para agrupar notificaciones similares
- `extra` - JSON con datos adicionales
- `confirmed_at` - Timestamp cuando se confirmó el envío
- `created_at` / `updated_at` - Timestamps estándar de Laravel

## 🔧 Comandos Útiles

### Desarrollo
```bash
# Ejecutar tests con coverage
composer test-coverage

# Ejecutar tests específicos
./vendor/bin/pest tests/Models/NotificationLogItemTest.php

# Análisis de arquitectura
./vendor/bin/pest tests/ArchTest.php
```

### Debugging
```bash
# Ver logs de notificaciones
php artisan tinker
>>> $user->notificationLogItems()->get();

# Verificar configuración
php artisan config:show notification-log
```

## 🎯 Mejores Prácticas

### Performance
- Usar `fingerprint` para evitar duplicados
- Implementar pruning automático con `prune_after_days`
- Usar índices en `notifiable_type`, `notifiable_id`, `created_at`

### Seguridad
- Validar datos en `getExtra()` antes de almacenar
- Usar `guarded = []` en el modelo para control total de campos
- Implementar `shouldLog()` para control granular

### Testing
- Usar `DummyChannel` para tests sin envío real
- Crear factories para datos de prueba consistentes
- Testear tanto casos positivos como negativos de `shouldLog()`

## 📚 Referencias Clave

- **Documentación**: `docs/` - Guías completas de uso
- **Tests**: `tests/` - Ejemplos de implementación y casos de uso
- **Configuración**: `config/notification-log.php` - Opciones disponibles
- **Service Provider**: `src/NotificationLogServiceProvider.php` - Registro del paquete 