import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';
import '../../datos/modelos/reportes/reporte_admin.dart';
import '../../datos/modelos/reportes/reporte.dart';
import '../../nucleo/errores/error_base.dart';
import 'servicio_base.dart';

/// 📌 **Servicio para manejar reportes administrativos**
/// 
/// Este servicio proporciona métodos para obtener estadísticas detalladas, 
/// guardar reportes administrativos y obtener reportes administrativos por rango de fechas.
class ServicioReportes extends ServicioBase {
  /// Instancia única del servicio
  static final ServicioReportes _instancia = ServicioReportes();

  /// Firestore para operaciones en la base de datos
  final FirebaseFirestore _db;

  /// Logger para registrar información y errores
  final Logger _logger = Logger('ServicioReportes');

  /// Nombre de la colección en Firestore
  final String _coleccionReportes = 'reportes';

  /// 📌 **Constructor con inyección opcional de Firestore**
  ServicioReportes({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  /// 📌 **Método para obtener una instancia del servicio**
  factory ServicioReportes.instancia() => _instancia;

  /// 📌 **Obtiene estadísticas detalladas para un rango de fechas**
  /// 
  /// Este método devuelve un mapa con estadísticas detalladas para un rango de fechas.
  /// Las estadísticas incluyen información sobre usuarios, servicios y tendencias de uso.
  Future<Map<String, dynamic>> obtenerEstadisticasDetalladas({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    try {
      // Consultas en paralelo para mejor rendimiento
      final resultados = await Future.wait([
        _obtenerEstadisticasUsuarios(),
        _obtenerEstadisticasServicios(inicio, fin),
        _obtenerTendenciasUso(inicio, fin),
      ]);

      return {
        ...resultados[0], // Estadísticas de usuarios
        ...resultados[1], // Estadísticas de servicios
        'tendenciasUso': resultados[2], // Tendencias de uso
      };
    } catch (e) {
      _logger.severe('Error al obtener estadísticas detalladas', e);
      throw ErrorBase(
        'Error al obtener estadísticas',
        mensaje: 'No se pudieron obtener las estadísticas detalladas',
        codigo: 'ERR_ESTADISTICAS_DETALLADAS',
        causa: e,
      );
    }
  }

  /// 📌 **Obtiene un reporte administrativo desde Firestore**
  Future<ReporteAdmin?> obtenerReporteAdmin(String id) async {
    try {
      final doc = await _db.collection(_coleccionReportes).doc(id).get();
      if (doc.exists) {
        return ReporteAdmin.fromMap(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      _logger.severe('Error al obtener reporte administrativo', e);
      throw ErrorBase(
        'Error al obtener reporte',
        mensaje: 'No se pudo obtener el reporte administrativo',
        codigo: 'ERR_OBTENER_REPORTE_ADMIN',
        causa: e,
      );
    }
  }

  /// 📌 **Obtiene reportes administrativos por rango de fechas**
  Future<List<ReporteAdmin>> obtenerReportesAdmin({
    required DateTime inicio,
    required DateTime fin,
  }) async {
    try {
      final query = _db.collection(_coleccionReportes)
          .where('fechaInicio', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
          .where('fechaFin', isLessThanOrEqualTo: Timestamp.fromDate(fin));

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => ReporteAdmin.fromMap(doc.data()))
          .toList();
    } catch (e) {
      _logger.severe('Error al obtener reportes administrativos', e);
      throw ErrorBase(
        'Error al obtener reportes',
        mensaje: 'No se pudieron obtener los reportes administrativos',
        codigo: 'ERR_OBTENER_REPORTES_ADMIN',
        causa: e,
      );
    }
  }

  /// Obtiene estadísticas de usuarios
  Future<Map<String, dynamic>> _obtenerEstadisticasUsuarios() async {
    try {
      final snapshot = await _db.collection('usuarios').get();
      final usuarios = snapshot.docs;

      final totalUsuarios = usuarios.length;
      final totalEspecialistas = usuarios.where((u) => u.data()['rol'] == 'especialista').length;
      final totalFamilias = usuarios.where((u) => u.data()['rol'] == 'familia').length;
      
      // Calcular usuarios activos (que han iniciado sesión en los últimos 30 días)
      final treintaDiasAtras = DateTime.now().subtract(const Duration(days: 30));
      final usuariosActivos = usuarios.where((u) {
        final ultimoAcceso = (u.data()['ultimoAcceso'] as Timestamp?)?.toDate();
        return ultimoAcceso != null && ultimoAcceso.isAfter(treintaDiasAtras);
      }).length;

      return {
        'totalUsuarios': totalUsuarios,
        'totalEspecialistas': totalEspecialistas,
        'totalFamilias': totalFamilias,
        'porcentajeUsuariosActivos': totalUsuarios > 0 
          ? (usuariosActivos / totalUsuarios) * 100 
          : 0.0,
      };
    } catch (e) {
      throw ErrorBase(
        'Error en estadísticas de usuarios',
        mensaje: 'No se pudieron obtener las estadísticas de usuarios',
        codigo: 'ERR_ESTADISTICAS_USUARIOS',
        causa: e,
      );
    }
  }

  /// Obtiene estadísticas de servicios para un rango de fechas
  Future<Map<String, dynamic>> _obtenerEstadisticasServicios(
    DateTime inicio,
    DateTime fin,
  ) async {
    try {
      final query = _db.collection('servicios')
          .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
          .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fin));

      final snapshot = await query.get();
      final servicios = snapshot.docs;

      // Servicios completados
      final completados = servicios.where((s) => s.data()['estado'] == 'completado');
      
      // Calificación promedio
      var calificacionTotal = 0.0;
      var serviciosCalificados = 0;
      for (final servicio in completados) {
        final calificacion = servicio.data()['calificacion'] as num?;
        if (calificacion != null) {
          calificacionTotal += calificacion.toDouble();
          serviciosCalificados++;
        }
      }

      // Servicios por tipo
      final serviciosPorTipo = <String, int>{};
      for (final servicio in servicios) {
        final tipo = servicio.data()['tipo'] as String? ?? 'otro';
        serviciosPorTipo[tipo] = (serviciosPorTipo[tipo] ?? 0) + 1;
      }

      return {
        'serviciosCompletados': completados.length,
        'calificacionPromedio': serviciosCalificados > 0 
          ? calificacionTotal / serviciosCalificados 
          : 0.0,
        'serviciosPorTipo': serviciosPorTipo,
      };
    } catch (e) {
      throw ErrorBase(
        'Error en estadísticas de servicios',
        mensaje: 'No se pudieron obtener las estadísticas de servicios',
        codigo: 'ERR_ESTADISTICAS_SERVICIOS',
        causa: e,
      );
    }
  }

  /// Obtiene tendencias de uso del sistema
  Future<Map<String, double>> _obtenerTendenciasUso(
    DateTime inicio,
    DateTime fin,
  ) async {
    try {
      final query = _db.collection('registros_uso')
          .where('fecha', isGreaterThanOrEqualTo: Timestamp.fromDate(inicio))
          .where('fecha', isLessThanOrEqualTo: Timestamp.fromDate(fin));

      final snapshot = await query.get();
      final registros = snapshot.docs;

      // Calcular tendencias por tipo de actividad
      final tendencias = <String, double>{};
      for (final registro in registros) {
        final tipo = registro.data()['tipoActividad'] as String? ?? 'otro';
        final duracion = registro.data()['duracion'] as num? ?? 0;
        tendencias[tipo] = (tendencias[tipo] ?? 0) + duracion.toDouble();
      }

      // Normalizar las tendencias a porcentajes
      final total = tendencias.values.fold<double>(0, (acumulado, value) => acumulado + value);
      if (total > 0) {
        tendencias.forEach((key, value) {
          tendencias[key] = (value / total) * 100;
        });
      }

      return tendencias;
    } catch (e) {
      throw ErrorBase(
        'Error en tendencias de uso',
        mensaje: 'No se pudieron obtener las tendencias de uso',
        codigo: 'ERR_TENDENCIAS_USO',
        causa: e,
      );
    }
  }

  /// 📌 **Genera un archivo PDF para un reporte administrativo**
  Future<String> generarReporteAdminPDF(ReporteAdmin reporte) async {
    try {
      // TODO: Implementar generación de PDF
      // Por ahora, retornamos un path temporal
      return '/temp/reporte_admin_${reporte.id}.pdf';
    } catch (e) {
      throw ErrorBase(
        'Error al generar PDF',
        mensaje: 'No se pudo generar el archivo PDF del reporte administrativo',
        codigo: 'ERR_GENERAR_PDF_ADMIN',
        causa: e,
      );
    }
  }

  /// 📌 **Guarda un reporte en la base de datos**
  /// 
  /// Este método guarda un reporte en la base de datos.
  /// Soporta tanto objetos de tipo ReporteAdmin como Reporte.
  Future<void> guardarReporte(dynamic reporte) async {
    try {
      if (reporte is ReporteAdmin) {
        await _db.collection(_coleccionReportes).doc(reporte.id).set(reporte.toMap());
      } else if (reporte is Reporte) {
        await _db.collection(_coleccionReportes).doc(reporte.id).set(reporte.toFirestore());
      } else {
        throw ErrorBase(
          'Tipo de reporte no válido',
          mensaje: 'El objeto proporcionado no es un tipo de reporte válido',
          codigo: 'ERR_TIPO_REPORTE_INVALIDO',
        );
      }
      _logger.info('Reporte guardado con éxito: ${reporte.id}');
    } catch (e) {
      _logger.severe('Error al guardar reporte', e);
      throw ErrorBase(
        'Error al guardar reporte',
        mensaje: 'No se pudo guardar el reporte',
        codigo: 'ERR_GUARDAR_REPORTE',
        causa: e,
      );
    }
  }

  /// 📌 **Obtiene reportes por filtros**
  /// 
  /// Este método obtiene reportes basados en los filtros proporcionados.
  Future<List<Reporte>> obtenerReportes({
    required Map<String, dynamic> filtros,
    int limite = 50,
  }) async {
    try {
      Query query = _db.collection('reportes');
      
      // Aplicar filtros de fecha si están presentes
      if (filtros.containsKey('fecha')) {
        final fechaFiltro = filtros['fecha'] as Map<String, dynamic>;
        if (fechaFiltro.containsKey('inicio')) {
          query = query.where('fechaCreacion', 
              isGreaterThanOrEqualTo: Timestamp.fromDate(fechaFiltro['inicio'] as DateTime));
        }
        if (fechaFiltro.containsKey('fin')) {
          query = query.where('fechaCreacion', 
              isLessThanOrEqualTo: Timestamp.fromDate(fechaFiltro['fin'] as DateTime));
        }
      }
      
      // Aplicar filtros de especialista si están presentes
      if (filtros.containsKey('idEspecialista')) {
        query = query.where('asignadoA', isEqualTo: filtros['idEspecialista']);
      }
      
      // Aplicar filtros de paciente si están presentes
      if (filtros.containsKey('idPaciente')) {
        query = query.where('pacienteId', isEqualTo: filtros['idPaciente']);
      }
      
      // Limitar resultados
      query = query.limit(limite);
      
      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => Reporte.fromDocumentSnapshot(doc))
          .toList();
    } catch (e) {
      _logger.severe('Error al obtener reportes', e);
      throw ErrorBase(
        'Error al obtener reportes',
        mensaje: 'No se pudieron obtener los reportes',
        codigo: 'ERR_OBTENER_REPORTES',
        causa: e,
      );
    }
  }

  /// 📌 **Obtiene estadísticas para un rango de fechas**
  /// 
  /// Este método devuelve un mapa con estadísticas para un rango de fechas.
  Future<Map<String, dynamic>> obtenerEstadisticas({
    required DateTime inicio,
    required DateTime fin,
    String? idEspecialista,
  }) async {
    try {
      // Construir filtros para las consultas
      final filtros = <String, dynamic>{
        'fecha': {
          'inicio': inicio,
          'fin': fin,
        },
      };
      
      if (idEspecialista != null) {
        filtros['idEspecialista'] = idEspecialista;
      }
      
      // Obtener reportes según los filtros
      final reportes = await obtenerReportes(filtros: filtros, limite: 1000);
      
      // Calcular estadísticas básicas
      final estadisticas = <String, dynamic>{
        'totalReportes': reportes.length,
        'reportesPorEstado': _contarReportesPorEstado(reportes),
        'reportesPorTipo': _contarReportesPorTipo(reportes),
      };
      
      return estadisticas;
    } catch (e) {
      _logger.severe('Error al obtener estadísticas', e);
      throw ErrorBase(
        'Error al obtener estadísticas',
        mensaje: 'No se pudieron obtener las estadísticas',
        codigo: 'ERR_OBTENER_ESTADISTICAS',
        causa: e,
      );
    }
  }

  /// Cuenta reportes por estado
  Map<String, int> _contarReportesPorEstado(List<Reporte> reportes) {
    final conteo = <String, int>{};
    for (final reporte in reportes) {
      conteo[reporte.estado] = (conteo[reporte.estado] ?? 0) + 1;
    }
    return conteo;
  }

  /// Cuenta reportes por tipo
  Map<String, int> _contarReportesPorTipo(List<Reporte> reportes) {
    final conteo = <String, int>{};
    for (final reporte in reportes) {
      conteo[reporte.tipoReporte] = (conteo[reporte.tipoReporte] ?? 0) + 1;
    }
    return conteo;
  }

  /// 📌 **Genera un reporte PDF para un rango de fechas**
  /// 
  /// Este método genera un reporte PDF para un rango de fechas y devuelve la ruta del archivo.
  Future<String> generarReportePDF({
    required DateTime inicio,
    required DateTime fin,
    String? idEspecialista,
    String? idPaciente,
  }) async {
    try {
      // Construir filtros para las consultas
      final filtros = <String, dynamic>{
        'fecha': {
          'inicio': inicio,
          'fin': fin,
        },
      };
      
      if (idEspecialista != null) {
        filtros['idEspecialista'] = idEspecialista;
      }
      
      if (idPaciente != null) {
        filtros['idPaciente'] = idPaciente;
      }
      
      // Obtenemos los reportes pero no los utilizamos directamente en este método
      // ya que la implementación de la generación del PDF está pendiente
      await obtenerReportes(filtros: filtros, limite: 1000);
      
      // TODO: Implementar generación de PDF
      // Por ahora, retornamos un path temporal
      return '/temp/reporte_${DateTime.now().millisecondsSinceEpoch}.pdf';
    } catch (e) {
      _logger.severe('Error al generar reporte PDF', e);
      throw ErrorBase(
        'Error al generar reporte PDF',
        mensaje: 'No se pudo generar el reporte PDF',
        codigo: 'ERR_GENERAR_REPORTE_PDF',
        causa: e,
      );
    }
  }

  /// 📌 **Genera un reporte administrativo para un rango de fechas**
  /// 
  /// Este método genera un reporte administrativo para un rango de fechas.
  Future<ReporteAdmin> generarReporteAdmin({
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    try {
      // Obtener estadísticas detalladas
      final estadisticas = await obtenerEstadisticasDetalladas(
        inicio: fechaInicio,
        fin: fechaFin,
      );
      
      // Crear reporte administrativo
      return ReporteAdmin(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
        totalUsuarios: estadisticas['totalUsuarios'] as int? ?? 0,
        totalEspecialistas: estadisticas['totalEspecialistas'] as int? ?? 0,
        totalFamilias: estadisticas['totalFamilias'] as int? ?? 0,
        serviciosCompletados: estadisticas['serviciosCompletados'] as int? ?? 0,
        calificacionPromedio: estadisticas['calificacionPromedio'] as double? ?? 0.0,
        porcentajeUsuariosActivos: estadisticas['porcentajeUsuariosActivos'] as double? ?? 0.0,
        serviciosPorTipo: (estadisticas['serviciosPorTipo'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toInt()),
            ) ?? {},
        tendenciasUso: (estadisticas['tendenciasUso'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ) ?? {},
      );
    } catch (e) {
      _logger.severe('Error al generar reporte administrativo', e);
      throw ErrorBase(
        'Error al generar reporte administrativo',
        mensaje: 'No se pudo generar el reporte administrativo',
        codigo: 'ERR_GENERAR_REPORTE_ADMIN',
        causa: e,
      );
    }
  }

  /// 📌 **Guarda un reporte administrativo en la base de datos**
  /// 
  /// Este método guarda un reporte administrativo en la base de datos.
  /// @deprecated Utilizar guardarReporte en su lugar
  Future<void> guardarReporteAdmin(ReporteAdmin reporte) async {
    try {
      // Redirigimos al método unificado
      await guardarReporte(reporte);
    } catch (e) {
      _logger.severe('Error al guardar reporte administrativo', e);
      throw ErrorBase(
        'Error al guardar reporte',
        mensaje: 'No se pudo guardar el reporte administrativo',
        codigo: 'ERR_GUARDAR_REPORTE_ADMIN',
        causa: e,
      );
    }
  }
}
