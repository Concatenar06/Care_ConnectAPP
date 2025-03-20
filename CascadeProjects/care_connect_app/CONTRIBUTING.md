# Guía de Contribución

## Estructura de Ramas

El proyecto utiliza el siguiente modelo de ramas:

- `main`: Rama principal que contiene el código estable y listo para producción
- `feature/todo-implementation`: Rama para implementar las tareas pendientes (TODO)
- `feature/firebase-tests`: Rama para realizar pruebas con Firebase y Firestore

## Flujo de Trabajo

1. **Desarrollo de Nuevas Funcionalidades**
   - Crea una nueva rama a partir de `main` con el prefijo `feature/`
   - Implementa la funcionalidad
   - Realiza pruebas
   - Crea un Pull Request para fusionar con `main`

2. **Corrección de Errores**
   - Crea una nueva rama a partir de `main` con el prefijo `bugfix/`
   - Corrige el error
   - Realiza pruebas
   - Crea un Pull Request para fusionar con `main`

3. **Pruebas con Firebase**
   - Utiliza la rama `feature/firebase-tests` para realizar pruebas con Firebase
   - Documenta los resultados de las pruebas
   - Si las pruebas son exitosas, crea un Pull Request para fusionar con `main`

## Convenciones de Código

1. **Estilo de Código**
   - Sigue las convenciones de estilo de Dart y Flutter
   - Utiliza el formateador de código de Dart (`dart format`)
   - Ejecuta el análisis de código (`flutter analyze`) antes de hacer commit

2. **Documentación**
   - Documenta todas las clases y métodos públicos
   - Actualiza el README.md cuando sea necesario
   - Añade comentarios explicativos para código complejo

3. **Pruebas**
   - Escribe pruebas unitarias para todas las nuevas funcionalidades
   - Asegúrate de que todas las pruebas pasen antes de hacer commit

## Pull Requests

1. **Título y Descripción**
   - Utiliza un título descriptivo
   - Incluye una descripción detallada de los cambios
   - Menciona cualquier problema relacionado

2. **Revisión de Código**
   - Solicita revisión de al menos un miembro del equipo
   - Responde a los comentarios y realiza los cambios necesarios
   - Asegúrate de que todas las pruebas pasen

3. **Fusión**
   - Utiliza "Squash and merge" para mantener un historial limpio
   - Elimina la rama después de fusionar
