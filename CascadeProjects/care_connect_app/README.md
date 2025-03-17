# CuidadoConecta App

Aplicación móvil para conectar especialistas en cuidado de adultos mayores y personas con discapacidad con pacientes y sus familias.

## Plan de Consolidación y Mejora (2024-12-28)

### Motivación del Plan
La aplicación ha crecido significativamente y necesita una mejor organización y estructura. Este plan busca:
1. Mejorar la mantenibilidad del código
2. Facilitar la escalabilidad
3. Establecer estándares claros
4. Reducir la duplicación de código
5. Mejorar el manejo de errores
6. Centralizar la configuración

### Plan de Acción

#### Fase 1: Reorganización de Configuración Base 
1. Consolidación de archivos de configuración
   - Creación de `entorno.dart`
   - Creación de `estado_proyecto.dart`
   - Creación de `inicializacion.dart`
   - Actualización de configuraciones Firebase y logging

#### Fase 2: Sistema de Errores 
1. Creación de jerarquía de errores
   - Implementación de `ErrorBase`
   - Errores específicos por dominio
   - Sistema de logging integrado
   - Serialización para persistencia

#### Fase 3: Constantes y Enumeraciones 
1. Reorganización de constantes
   - Constantes de aplicación
   - Constantes de roles y permisos
   - Constantes de servicios y tarifas
   - Constantes de mensajes y textos

2. Mejora de enumeraciones
   - Estados de reportes
   - Tipos de reportes
   - Roles de usuario
   - Utilidades y validaciones

#### Fase 4: Servicios (En Progreso)
1. Reorganización de servicios
   - Autenticación
   - Notificaciones
   - Almacenamiento
   - Reportes

#### Fase 5: Modelos y DTOs (Pendiente)
1. Estandarización de modelos
   - Interfaces base
   - Serialización
   - Validación

#### Fase 6: Widgets y UI (Pendiente)
1. Componentes reutilizables
   - Widgets base
   - Temas y estilos
   - Utilidades de UI

### Progreso Actual

#### Completado 
1. **Configuración Base**
   - Nueva estructura de configuración
   - Mejor manejo de entornos
   - Inicialización centralizada

2. **Sistema de Errores**
   - Jerarquía clara de errores
   - Mejor trazabilidad
   - Logging automático
   - Códigos únicos

3. **Constantes y Enumeraciones**
   - Organización por dominio
   - Documentación completa
   - Utilidades integradas
   - Validaciones robustas

#### En Progreso 
1. **Servicios**
   - Reorganización de estructura
   - Mejora de interfaces
   - Documentación

#### Pendiente 
1. **Modelos y DTOs**
2. **Widgets y UI**
3. **Pruebas y Documentación**

### Beneficios Logrados
1. Mejor organización del código
2. Documentación más clara
3. Reducción de duplicación
4. Mayor facilidad de mantenimiento
5. Mejor manejo de errores
6. Configuración centralizada

### Próximos Pasos
1. Continuar con la reorganización de servicios
2. Implementar modelos estandarizados
3. Mejorar componentes de UI
4. Ampliar cobertura de pruebas
5. Actualizar documentación

## Estado Actual del Proyecto (14/01/2025)

### Última Actualización
- ✅ Implementación de `ModeloBase` como interfaz base para todos los modelos
- ✅ Creación de mixins para manejo de datos de Firestore:
  - `ManejadorFechasFirestore`
  - `ManejadorListasFirestore`
  - `ManejadorMapasFirestore`
- ✅ Actualización de modelos de reportes:
  - `ReporteBase`: Base abstracta con campos comunes
  - `ReporteEspecialista`: Informes de especialistas médicos
  - `ReporteAdministrador`: Gestión y auditoría
  - `ReporteFamiliar`: Seguimiento familiar
  - `ReportePaciente`: Estado y evolución del paciente

### Próximas Fases

#### Fase 1: Completar Modelos y Servicios Base
- [ ] Crear modelos adicionales de reportes:
  - `ReporteIncidencia`
  - `ReporteMedico`
  - `ReporteSeguimiento`
- [ ] Implementar servicios base:
  - Autenticación
  - Gestión de usuarios
  - Gestión de roles y permisos

#### Fase 2: Implementación de Interfaces de Usuario
- [ ] Diseñar e implementar pantallas principales:
  - Login y registro
  - Dashboard principal
  - Gestión de reportes
  - Perfiles de usuario
- [ ] Desarrollar widgets reutilizables
- [ ] Implementar sistema de navegación

#### Fase 3: Integración con Firebase
- [ ] Configurar Firebase:
  - Authentication
  - Firestore
  - Storage
  - Cloud Functions
- [ ] Implementar sincronización offline
- [ ] Configurar reglas de seguridad

#### Fase 4: Funcionalidades Avanzadas
- [ ] Sistema de notificaciones
- [ ] Exportación de reportes
- [ ] Calendario y programación
- [ ] Chat y mensajería
- [ ] Geolocalización

#### Fase 5: Testing y Optimización
- [ ] Implementar tests unitarios
- [ ] Realizar tests de integración
- [ ] Optimizar rendimiento
- [ ] Gestión de memoria y recursos

#### Fase 6: Preparación para Producción
- [ ] Documentación completa
- [ ] Configuración de CI/CD
- [ ] Preparación de assets y recursos
- [ ] Configuración de entornos (dev, staging, prod)

## Actualizaciones Recientes (2025-03-17)

### Refactorización del Sistema de Modelos

Se ha completado una refactorización importante del sistema de modelos para mejorar la estabilidad y mantenibilidad del código:

1. **Eliminación de Dependencias de Archivos Generados**
   - Eliminada la dependencia de `freezed` para generación de código
   - Implementación manual de todos los métodos necesarios
   - Mayor control sobre la serialización y deserialización

2. **Mejoras en Clases Principales**
   - **Clase Usuario**: Implementación completa con todos los campos y métodos necesarios
   - **Clase ReporteBase**: Convertida a clase abstracta que implementa IReporte
   - **Clase Reporte**: Implementación mejorada con validación y campos adicionales

3. **Corrección de Errores**
   - Eliminados operadores null-aware innecesarios
   - Corregidos errores de compilación relacionados con métodos faltantes
   - Mejorada la compatibilidad entre diferentes partes del sistema

### Próximos Pasos

1. **Pruebas Exhaustivas**
   - Implementar pruebas unitarias para los modelos refactorizados
   - Verificar la integración con Firebase

2. **Documentación**
   - Actualizar la documentación técnica
   - Crear guías para desarrolladores

3. **Mejoras de Rendimiento**
   - Optimizar consultas a Firestore
   - Mejorar la gestión de memoria

## Configuración del Proyecto

### Variables de Entorno
```bash
# Firebase Configuration
FIREBASE_CONFIG='{
  "projectId": "tu-proyecto-id",
  "apiKey": "tu-api-key",
  "authDomain": "tu-auth-domain",
  "storageBucket": "tu-storage-bucket",
  "messagingSenderId": "tu-sender-id",
  "appId": "tu-app-id"
}'
```

### Credenciales de Prueba
- **Cuenta de Administrador**:
  - Email: admin@ejemplo.com
  - Contraseña: Admin123#
  - Nombre: Administrador
  - Rol: Administrador
  - Código Admin: ADMIN123

### Desarrollo Local
1. Asegúrate de tener Flutter instalado
2. Ejecuta `flutter pub get`
3. Configura las variables de entorno en un archivo `.env`
4. Ejecuta `flutter run`

## Estructura del Proyecto
```
lib/
  ├── config/           # Configuraciones globales
  │   ├── config.dart   # Constantes y configuraciones
  │   └── app_timeouts.dart # Timeouts y duraciones
  ├── core/
  │   ├── enums/       # Enumeraciones
  │   └── routes/      # Rutas de la aplicación
  ├── features/        # Características principales
  │   ├── admin/       # Módulo de administración
  │   ├── auth/        # Autenticación
  │   ├── especialista/# Módulo de especialistas
  │   └── familia/     # Módulo de familia
  ├── providers/       # Proveedores de estado
  ├── services/        # Servicios de la aplicación
  └── widgets/         # Widgets compartidos
```

## Roles y Permisos

### Roles Disponibles
- **Administrador**: Gestión completa del sistema
  - Gestión de usuarios y servicios
  - Generación de reportes
  - Configuración del sistema
  
- **Especialista**: Profesionales de cuidado
  - Gestión de servicios asignados
  - Visualización de reportes propios
  - Gestión de calendario
  
- **Familia**: Usuarios que buscan servicios
  - Solicitud de servicios
  - Visualización de historial
  - Gestión de citas

### Sistema de Seguridad
- Variables de entorno para credenciales
- Validación de códigos de administrador
- Sistema de permisos basado en roles
- Timeouts configurables

## Timeouts y Configuraciones

### Timeouts de Red
- Timeout por defecto: 30 segundos
- Timeout largo: 2 minutos

### Sesión y Autenticación
- Duración de sesión: 24 horas
- Intervalo de refresco de token: 1 hora
- Expiración de código de verificación: 10 minutos

### Servicios
- Duración mínima: 1 hora
- Duración máxima: 12 horas
- Notificación previa: 30 minutos

## Estado Actual del Proyecto (2024-12-12)

### Servicios Implementados y Funcionales
1. **Autenticación** 
   - Inicialización asíncrona implementada
   - Manejo de estados de usuario
   - Gestión de roles y permisos

2. **Notificaciones** 
   - Sistema de notificaciones push
   - Notificaciones locales
   - Configuración de preferencias

### Servicios Pendientes de Implementación
1. **Reportes** 
   - Estado: En desarrollo
   - Pendiente: Implementación completa del servicio
   - Prioridad: Alta

2. **Almacenamiento** 
   - Estado: Parcialmente implementado
   - Pendiente: Gestión de archivos y caché
   - Prioridad: Alta

3. **Costos** 
   - Estado: No iniciado
   - Pendiente: Sistema completo
   - Prioridad: Media

### Errores Conocidos y Soluciones

#### Errores Corregidos
1. **AUTH001**: Constructor indefinido en ServicioAutenticacion
   - Solución: Implementación de inicialización asíncrona
   - Estado: Resuelto

2. **NOTIF001**: Métodos faltantes en ServicioNotificaciones
   - Solución: Implementación de métodos de configuración
   - Estado: Resuelto

#### Errores Pendientes
1. **REPORT001**: Implementación incompleta de reportes
   - Impacto: Funcionalidad de reportes limitada
   - Solución propuesta: Implementar servicio completo
   - Prioridad: Alta

2. **UI001**: Inconsistencias en navegación
   - Impacto: Experiencia de usuario subóptima
   - Solución propuesta: Sistema de navegación unificado
   - Prioridad: Media

### Plan de Correcciones Futuras

#### Corto Plazo (1-2 semanas)
1. Implementar sistema completo de reportes
   - Crear modelos necesarios
   - Implementar lógica de negocio
   - Desarrollar interfaces de usuario

2. Completar servicio de almacenamiento
   - Gestión de archivos
   - Sistema de caché
   - Manejo de permisos

#### Mediano Plazo (2-4 semanas)
1. Sistema de costos
   - Implementar modelos
   - Desarrollar lógica de cálculos
   - Crear interfaces de usuario

2. Mejoras de UX/UI
   - Unificar navegación
   - Optimizar flujos de usuario
   - Mejorar feedback visual

#### Largo Plazo (1-2 meses)
1. Optimizaciones generales
   - Rendimiento
   - Consumo de recursos
   - Tiempo de carga

2. Nuevas características
   - Sistema de mensajería
   - Calendario integrado
   - Estadísticas avanzadas

### Recomendaciones para Desarrollo

1. **Prioridades**
   - Enfocarse primero en reportes y almacenamiento
   - Mantener la coherencia en la nomenclatura
   - Seguir patrones establecidos

2. **Buenas Prácticas**
   - Usar inicialización asíncrona para servicios
   - Implementar manejo de errores consistente
   - Mantener documentación actualizada

3. **Testing**
   - Crear pruebas unitarias para nuevos servicios
   - Validar flujos de usuario completos
   - Documentar casos de prueba

### Notas de Configuración
- Asegurar configuración correcta de Firebase
- Mantener variables de entorno actualizadas
- Verificar permisos necesarios en cada plataforma

## Historial de Actualizaciones

### 2024-12-12: Migración del Sistema de Reportes

#### Cambios Realizados
- Migración completa de `consolidated_report_service.dart` a `servicio_reportes_consolidados.dart`
- Actualización de rutas de importación en múltiples archivos
- Reorganización de estructura de carpetas (`servicios/reportes/`, `datos/modelos/`)

#### Problemas Resueltos
1. **Errores de Importación**
   - URIs inexistentes para modelos
   - Referencias a archivos en rutas obsoletas
   - Caracteres ilegales en el código

2. **Inconsistencias en la Estructura**
   - Unificación de nombres (inglés/español)
   - Estandarización de rutas
   - Eliminación de duplicidad en servicios

#### ¿Por qué Reiniciar?
Es necesario reiniciar el IDE para:
- Limpiar la caché de archivos eliminados
- Recargar las nuevas rutas de importación
- Actualizar el índice de archivos
- Eliminar referencias obsoletas en memoria

#### Pasos Post-Reinicio
1. Ejecutar:
   ```bash
   flutter clean
   flutter pub get
   flutter analyze
   ```
2. Verificar funcionalidad de reportes
3. Comprobar exportación de PDFs
4. Validar cálculos estadísticos

#### Próximos Pasos
1. **Mejoras Planificadas**
   - Implementar nuevos tipos de reportes
   - Mejorar visualización de estadísticas
   - Agregar filtros adicionales
   - Optimizar consultas y rendimiento

2. **Características Futuras**
   - Sistema de notificaciones para reportes
   - Exportación en múltiples formatos
   - Dashboards interactivos

## Notas Importantes
- La aplicación requiere verificación de correo electrónico
- Los administradores necesitan un código especial para registrarse
- El registro de especialistas requiere validación adicional
- Las credenciales de Firebase deben configurarse mediante variables de entorno

## Guía de Solución de Problemas y Lanzamiento

### Preparación del Entorno

1. **Verificación de Dependencias**
   ```bash
   flutter pub get
   flutter pub outdated
   flutter pub upgrade
   ```

2. **Limpieza del Proyecto**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Verificación de la Configuración**
   - Comprobar archivo `.env`
   - Verificar `google-services.json` (Android)
   - Verificar `GoogleService-Info.plist` (iOS)
   - Revisar permisos en `AndroidManifest.xml` y `Info.plist`

### Solución de Problemas Comunes

1. **Errores de Compilación**
   - Limpiar caché de Gradle (Android):
     ```bash
     cd android
     ./gradlew clean
     cd ..
     ```
   - Limpiar caché de Pods (iOS):
     ```bash
     cd ios
     pod deintegrate
     pod install
     cd ..
     ```

2. **Errores de Firebase**
   - Verificar configuración en Firebase Console
   - Comprobar SHA-1 y SHA-256 en proyecto Android
   - Verificar Bundle ID en iOS
   - Asegurar que los servicios necesarios están habilitados

3. **Errores de Estado**
   - Reiniciar el estado de la aplicación:
     ```bash
     flutter run --no-fast-start
     ```
   - Borrar datos de la aplicación en el dispositivo
   - Verificar la conexión a Firebase

4. **Problemas de Rendimiento**
   - Ejecutar el analizador de rendimiento:
     ```bash
     flutter run --profile
     ```
   - Verificar uso de memoria y CPU
   - Optimizar imágenes y recursos

### Proceso de Lanzamiento

1. **Preparación**
   ```bash
   # Actualizar versión en pubspec.yaml
   flutter clean
   flutter pub get
   ```

2. **Pruebas**
   ```bash
   # Ejecutar pruebas unitarias
   flutter test
   
   # Ejecutar pruebas de integración
   flutter drive --target=test_driver/app.dart
   ```

3. **Compilación para Android**
   ```bash
   # Generar APK de lanzamiento
   flutter build apk --release
   
   # Generar Bundle para Google Play
   flutter build appbundle --release
   ```

4. **Compilación para iOS**
   ```bash
   # Generar archivo IPA
   flutter build ios --release
   cd ios
   xcodebuild -workspace Runner.xcworkspace -scheme Runner -config Release
   ```

### Lista de Verificación Pre-Lanzamiento

1. **Verificación de Código**
   - [ ] Ejecutar análisis estático: `flutter analyze`
   - [ ] Verificar warnings y errores
   - [ ] Comprobar TODOs pendientes
   - [ ] Revisar prints de depuración

2. **Verificación de Recursos**
   - [ ] Iconos y splash screens
   - [ ] Imágenes y assets
   - [ ] Traducciones
   - [ ] Fuentes

3. **Verificación de Configuración**
   - [ ] Variables de entorno
   - [ ] Claves de API
   - [ ] Configuración de Firebase
   - [ ] Permisos de aplicación

4. **Verificación de Funcionalidad**
   - [ ] Flujo de autenticación
   - [ ] Gestión de usuarios
   - [ ] Sistema de citas
   - [ ] Notificaciones
   - [ ] Reportes
   - [ ] Mensajería

### Comandos Útiles

```bash
# Verificar dispositivos conectados
flutter devices

# Verificar estado de Flutter
flutter doctor -v

# Generar código
flutter pub run build_runner build

# Limpiar y regenerar código
flutter pub run build_runner build --delete-conflicting-outputs

# Ejecutar con hot reload
flutter run

# Ejecutar con modo de depuración de rendimiento
flutter run --profile

# Ejecutar con modo de lanzamiento
flutter run --release
```

### Notas de Mantenimiento

1. **Actualizaciones Regulares**
   - Actualizar Flutter SDK mensualmente
   - Revisar dependencias obsoletas
   - Actualizar configuración de Firebase
   - Mantener documentación actualizada

2. **Monitoreo**
   - Revisar Firebase Analytics
   - Monitorear crashlytics
   - Verificar rendimiento
   - Analizar feedback de usuarios

3. **Backups**
   - Mantener copias de seguridad de:
     - Configuraciones
     - Claves de firma
     - Certificados
     - Recursos críticos

4. **Seguridad**
   - Actualizar dependencias con vulnerabilidades
   - Revisar permisos y accesos
   - Verificar cumplimiento de GDPR/CCPA
   - Mantener políticas de privacidad actualizadas

## Estructura del Proyecto

```
lib/
├── datos/
│   ├── modelos/
│   │   ├── base/
│   │   │   ├── modelo_base.dart
│   │   │   └── reporte_base.dart
│   │   └── reportes/
│   │       ├── reporte_administrador.dart
│   │       ├── reporte_especialista.dart
│   │       ├── reporte_familiar.dart
│   │       └── reporte_paciente.dart
│   └── servicios/
├── nucleo/
│   ├── tema/
│   └── config/
├── presentacion/
│   ├── pantallas/
│   └── widgets/
└── utilidades/
```

## Guías de Desarrollo

### Convenciones de Código
- Usar nombres descriptivos en español
- Seguir principios SOLID
- Documentar todas las clases y métodos públicos
- Implementar manejo de errores consistente

### Arquitectura
- Patrón BLoC para gestión de estado
- Clean Architecture
- Dependency Injection
- Repository Pattern

## Requisitos

- Flutter: ^3.0.0
- Dart: ^3.0.0
- Firebase: ^10.0.0

## Configuración del Entorno

1. Clonar el repositorio
2. Ejecutar `flutter pub get`
3. Configurar Firebase
4. Ejecutar la aplicación

## Contribución

Por favor, seguir las guías de contribución y el código de conducta del proyecto.

## Licencia

Este proyecto está bajo la licencia [Especificar Licencia].
