import 'package:cloud_firestore/cloud_firestore.dart';
import '../base/i_reporte.dart';

/// Clase que representa un reporte en la plataforma
class Reporte implements IReporte {
  final String? _accion;
  final List<String>? _actividades;
  final bool _archivado;
  final List<String> _archivosAdjuntos;
  final String? _asignadoA;
  final List<String> _comentarios;
  final String _creadoPor;
  final Map<String, dynamic> _datos;
  final String _descripcion;
  final String? _diagnostico;
  final DateTime? _fechaActualizacion;
  final DateTime _fechaCreacion;
  final DateTime? _fechaFin;
  final DateTime? _fechaInicio;
  final String _id;
  final String? _idExterno;
  final String? _idPaciente;
  final String? _idServicio;
  final String? _idSesion;
  final bool _leido;
  final String? _medicacion;
  final String? _nombrePaciente;
  final String? _nombreServicio;
  final String? _nombreUsuario;
  final String? _observaciones;
  final String? _recomendaciones;
  final String _status;
  final String _tipo;
  final String _titulo;
  final String _usuarioId;
  final List<String> _etiquetas;
  final String? _revisadoPor;
  final int _prioridad;
  final bool _firmado;
  final String? _firma;
  final DateTime? _fechaFirma;

  Reporte({
    String? accion,
    List<String>? actividades,
    bool archivado = false,
    List<String>? archivosAdjuntos,
    String? asignadoA,
    List<String>? comentarios,
    required String creadoPor,
    Map<String, dynamic>? datos,
    required String descripcion,
    String? diagnostico,
    DateTime? fechaActualizacion,
    required DateTime fechaCreacion,
    DateTime? fechaFin,
    DateTime? fechaInicio,
    required String id,
    String? idExterno,
    String? idPaciente,
    String? idServicio,
    String? idSesion,
    bool leido = false,
    String? medicacion,
    String? nombrePaciente,
    String? nombreServicio,
    String? nombreUsuario,
    String? observaciones,
    String? recomendaciones,
    required String status,
    required String tipo,
    required String titulo,
    required String usuarioId,
    List<String>? etiquetas,
    String? revisadoPor,
    int prioridad = 0,
    bool firmado = false,
    String? firma,
    DateTime? fechaFirma,
  }) : _accion = accion,
       _actividades = actividades,
       _archivado = archivado,
       _archivosAdjuntos = archivosAdjuntos ?? [],
       _asignadoA = asignadoA,
       _comentarios = comentarios ?? [],
       _creadoPor = creadoPor,
       _datos = datos ?? {},
       _descripcion = descripcion,
       _diagnostico = diagnostico,
       _fechaActualizacion = fechaActualizacion,
       _fechaCreacion = fechaCreacion,
       _fechaFin = fechaFin,
       _fechaInicio = fechaInicio,
       _id = id,
       _idExterno = idExterno,
       _idPaciente = idPaciente,
       _idServicio = idServicio,
       _idSesion = idSesion,
       _leido = leido,
       _medicacion = medicacion,
       _nombrePaciente = nombrePaciente,
       _nombreServicio = nombreServicio,
       _nombreUsuario = nombreUsuario,
       _observaciones = observaciones,
       _recomendaciones = recomendaciones,
       _status = status,
       _tipo = tipo,
       _titulo = titulo,
       _usuarioId = usuarioId,
       _etiquetas = etiquetas ?? [],
       _revisadoPor = revisadoPor,
       _prioridad = prioridad,
       _firmado = firmado,
       _firma = firma,
       _fechaFirma = fechaFirma;

  // Getters para acceder a los campos privados
  String? get accion => _accion;
  List<String>? get actividades => _actividades;
  bool get archivado => _archivado;
  List<String> get archivosAdjuntos => _archivosAdjuntos;
  String? get asignadoA => _asignadoA;
  List<String> get comentarios => _comentarios;
  String get creadoPor => _creadoPor;
  Map<String, dynamic> get datos => _datos;
  @override
  String get descripcion => _descripcion;
  String? get diagnostico => _diagnostico;
  @override
  DateTime? get fechaActualizacion => _fechaActualizacion;
  @override
  DateTime get fechaCreacion => _fechaCreacion;
  DateTime? get fechaFin => _fechaFin;
  DateTime? get fechaInicio => _fechaInicio;
  @override
  String get id => _id;
  String? get idExterno => _idExterno;
  String? get idPaciente => _idPaciente;
  String? get idServicio => _idServicio;
  String? get idSesion => _idSesion;
  bool get leido => _leido;
  String? get medicacion => _medicacion;
  String? get nombrePaciente => _nombrePaciente;
  String? get nombreServicio => _nombreServicio;
  String? get nombreUsuario => _nombreUsuario;
  String? get observaciones => _observaciones;
  String? get recomendaciones => _recomendaciones;
  String get status => _status;
  String get tipo => _tipo;
  @override
  String get titulo => _titulo;
  @override
  String get usuarioId => _usuarioId;
  List<String> get etiquetas => _etiquetas;
  String? get revisadoPor => _revisadoPor;
  int get prioridad => _prioridad;
  bool get firmado => _firmado;
  String? get firma => _firma;
  DateTime? get fechaFirma => _fechaFirma;
  
  // Propiedades adicionales para compatibilidad con código existente
  String get estado => _status;
  String get tipoReporte => _tipo;
  
  // Implementación de métodos requeridos por IReporte
  @override
  bool get resuelto => _status.toLowerCase() == 'completado' || _status.toLowerCase() == 'cerrado';
  
  @override
  String? get resolutorId => _revisadoPor;
  
  @override
  bool validar() {
    return _id.isNotEmpty &&
           _usuarioId.isNotEmpty &&
           _titulo.isNotEmpty &&
           _descripcion.isNotEmpty &&
           _status.isNotEmpty &&
           _tipo.isNotEmpty;
  }

  /// Método para convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'accion': _accion,
      'actividades': _actividades,
      'archivado': _archivado,
      'archivosAdjuntos': _archivosAdjuntos,
      'asignadoA': _asignadoA,
      'comentarios': _comentarios,
      'creadoPor': _creadoPor,
      'datos': _datos,
      'descripcion': _descripcion,
      'diagnostico': _diagnostico,
      'fechaActualizacion': _fechaActualizacion?.toIso8601String(),
      'fechaCreacion': _fechaCreacion.toIso8601String(),
      'fechaFin': _fechaFin?.toIso8601String(),
      'fechaInicio': _fechaInicio?.toIso8601String(),
      'id': _id,
      'idExterno': _idExterno,
      'idPaciente': _idPaciente,
      'idServicio': _idServicio,
      'idSesion': _idSesion,
      'leido': _leido,
      'medicacion': _medicacion,
      'nombrePaciente': _nombrePaciente,
      'nombreServicio': _nombreServicio,
      'nombreUsuario': _nombreUsuario,
      'observaciones': _observaciones,
      'recomendaciones': _recomendaciones,
      'status': _status,
      'tipo': _tipo,
      'titulo': _titulo,
      'usuarioId': _usuarioId,
      'etiquetas': _etiquetas,
      'revisadoPor': _revisadoPor,
      'estado': _status,
      'tipoReporte': _tipo,
      'prioridad': _prioridad,
      'firmado': _firmado,
      'firma': _firma,
      'fechaFirma': _fechaFirma?.toIso8601String(),
    };
  }

  /// Constructor desde JSON
  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      accion: json['accion'] as String?,
      actividades: (json['actividades'] as List<dynamic>?)?.map((e) => e as String).toList(),
      archivado: json['archivado'] as bool? ?? false,
      archivosAdjuntos: (json['archivosAdjuntos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      asignadoA: json['asignadoA'] as String?,
      comentarios: (json['comentarios'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      creadoPor: json['creadoPor'] as String,
      datos: json['datos'] as Map<String, dynamic>? ?? {},
      descripcion: json['descripcion'] as String,
      diagnostico: json['diagnostico'] as String?,
      fechaActualizacion: json['fechaActualizacion'] != null
          ? DateTime.parse(json['fechaActualizacion'] as String)
          : null,
      fechaCreacion: DateTime.parse(json['fechaCreacion'] as String),
      fechaFin: json['fechaFin'] != null
          ? DateTime.parse(json['fechaFin'] as String)
          : null,
      fechaInicio: json['fechaInicio'] != null
          ? DateTime.parse(json['fechaInicio'] as String)
          : null,
      id: json['id'] as String,
      idExterno: json['idExterno'] as String?,
      idPaciente: json['idPaciente'] as String?,
      idServicio: json['idServicio'] as String?,
      idSesion: json['idSesion'] as String?,
      leido: json['leido'] as bool? ?? false,
      medicacion: json['medicacion'] as String?,
      nombrePaciente: json['nombrePaciente'] as String?,
      nombreServicio: json['nombreServicio'] as String?,
      nombreUsuario: json['nombreUsuario'] as String?,
      observaciones: json['observaciones'] as String?,
      recomendaciones: json['recomendaciones'] as String?,
      status: json['status'] as String? ?? json['estado'] as String? ?? 'pendiente',
      tipo: json['tipo'] as String? ?? json['tipoReporte'] as String? ?? 'general',
      titulo: json['titulo'] as String,
      usuarioId: json['usuarioId'] as String,
      etiquetas: (json['etiquetas'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      revisadoPor: json['revisadoPor'] as String?,
      prioridad: (json['prioridad'] as num?)?.toInt() ?? 0,
      firmado: json['firmado'] as bool? ?? false,
      firma: json['firma'] as String?,
      fechaFirma: json['fechaFirma'] != null
          ? DateTime.parse(json['fechaFirma'] as String)
          : null,
    );
  }

  /// Constructor desde Firestore
  factory Reporte.fromFirestore(Map<String, dynamic> map) {
    return Reporte(
      accion: map['accion'] as String?,
      actividades: (map['actividades'] as List<dynamic>?)?.map((e) => e as String).toList(),
      archivado: map['archivado'] as bool? ?? false,
      archivosAdjuntos: (map['archivosAdjuntos'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      asignadoA: map['asignadoA'] as String?,
      comentarios: (map['comentarios'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      creadoPor: map['creadoPor'] as String? ?? '',
      datos: map['datos'] as Map<String, dynamic>? ?? {},
      descripcion: map['descripcion'] as String? ?? '',
      diagnostico: map['diagnostico'] as String?,
      fechaActualizacion: map['fechaActualizacion'] != null
          ? (map['fechaActualizacion'] is Timestamp
              ? (map['fechaActualizacion'] as Timestamp).toDate()
              : (map['fechaActualizacion'] is DateTime
                  ? map['fechaActualizacion'] as DateTime
                  : DateTime.parse(map['fechaActualizacion'].toString())))
          : null,
      fechaCreacion: map['fechaCreacion'] != null
          ? (map['fechaCreacion'] is Timestamp
              ? (map['fechaCreacion'] as Timestamp).toDate()
              : (map['fechaCreacion'] is DateTime
                  ? map['fechaCreacion'] as DateTime
                  : DateTime.parse(map['fechaCreacion'].toString())))
          : DateTime.now(),
      fechaFin: map['fechaFin'] != null
          ? (map['fechaFin'] is Timestamp
              ? (map['fechaFin'] as Timestamp).toDate()
              : (map['fechaFin'] is DateTime
                  ? map['fechaFin'] as DateTime
                  : DateTime.parse(map['fechaFin'].toString())))
          : null,
      fechaInicio: map['fechaInicio'] != null
          ? (map['fechaInicio'] is Timestamp
              ? (map['fechaInicio'] as Timestamp).toDate()
              : (map['fechaInicio'] is DateTime
                  ? map['fechaInicio'] as DateTime
                  : DateTime.parse(map['fechaInicio'].toString())))
          : null,
      id: map['id'] as String? ?? '',
      idExterno: map['idExterno'] as String?,
      idPaciente: map['idPaciente'] as String?,
      idServicio: map['idServicio'] as String?,
      idSesion: map['idSesion'] as String?,
      leido: map['leido'] as bool? ?? false,
      medicacion: map['medicacion'] as String?,
      nombrePaciente: map['nombrePaciente'] as String?,
      nombreServicio: map['nombreServicio'] as String?,
      nombreUsuario: map['nombreUsuario'] as String?,
      observaciones: map['observaciones'] as String?,
      recomendaciones: map['recomendaciones'] as String?,
      status: map['status'] as String? ?? map['estado'] as String? ?? 'pendiente',
      tipo: map['tipo'] as String? ?? map['tipoReporte'] as String? ?? 'general',
      titulo: map['titulo'] as String? ?? '',
      usuarioId: map['usuarioId'] as String? ?? '',
      etiquetas: (map['etiquetas'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      revisadoPor: map['revisadoPor'] as String?,
      prioridad: (map['prioridad'] as num?)?.toInt() ?? 0,
      firmado: map['firmado'] as bool? ?? false,
      firma: map['firma'] as String?,
      fechaFirma: map['fechaFirma'] != null
          ? (map['fechaFirma'] is Timestamp
              ? (map['fechaFirma'] as Timestamp).toDate()
              : (map['fechaFirma'] is DateTime
                  ? map['fechaFirma'] as DateTime
                  : DateTime.parse(map['fechaFirma'].toString())))
          : null,
    );
  }

  /// Constructor desde DocumentSnapshot
  factory Reporte.fromDocumentSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Reporte.fromFirestore({...data, 'id': doc.id});
  }

  /// Método para convertir a Firestore
  @override
  Map<String, dynamic> toFirestore() {
    final Map<String, dynamic> data = {
      'accion': _accion,
      'actividades': _actividades,
      'archivado': _archivado,
      'archivosAdjuntos': _archivosAdjuntos,
      'asignadoA': _asignadoA,
      'comentarios': _comentarios,
      'creadoPor': _creadoPor,
      'datos': _datos,
      'descripcion': _descripcion,
      'diagnostico': _diagnostico,
      'fechaActualizacion': _fechaActualizacion,
      'fechaCreacion': _fechaCreacion,
      'fechaFin': _fechaFin,
      'fechaInicio': _fechaInicio,
      'id': _id,
      'idExterno': _idExterno,
      'idPaciente': _idPaciente,
      'idServicio': _idServicio,
      'idSesion': _idSesion,
      'leido': _leido,
      'medicacion': _medicacion,
      'nombrePaciente': _nombrePaciente,
      'nombreServicio': _nombreServicio,
      'nombreUsuario': _nombreUsuario,
      'observaciones': _observaciones,
      'recomendaciones': _recomendaciones,
      'status': _status,
      'tipo': _tipo,
      'titulo': _titulo,
      'usuarioId': _usuarioId,
      'etiquetas': _etiquetas,
      'revisadoPor': _revisadoPor,
      'estado': _status,
      'tipoReporte': _tipo,
      'prioridad': _prioridad,
      'firmado': _firmado,
      'firma': _firma,
      'fechaFirma': _fechaFirma,
    };
    
    return data;
  }

  /// Método para crear una copia del reporte con algunos campos actualizados
  Reporte copyWith({
    String? accion,
    List<String>? actividades,
    bool? archivado,
    List<String>? archivosAdjuntos,
    String? asignadoA,
    List<String>? comentarios,
    String? creadoPor,
    Map<String, dynamic>? datos,
    String? descripcion,
    String? diagnostico,
    DateTime? fechaActualizacion,
    DateTime? fechaCreacion,
    DateTime? fechaFin,
    DateTime? fechaInicio,
    String? id,
    String? idExterno,
    String? idPaciente,
    String? idServicio,
    String? idSesion,
    bool? leido,
    String? medicacion,
    String? nombrePaciente,
    String? nombreServicio,
    String? nombreUsuario,
    String? observaciones,
    String? recomendaciones,
    String? status,
    String? tipo,
    String? titulo,
    String? usuarioId,
    List<String>? etiquetas,
    String? revisadoPor,
    int? prioridad,
    bool? firmado,
    String? firma,
    DateTime? fechaFirma,
  }) {
    return Reporte(
      accion: accion ?? _accion,
      actividades: actividades ?? _actividades,
      archivado: archivado ?? _archivado,
      archivosAdjuntos: archivosAdjuntos ?? _archivosAdjuntos,
      asignadoA: asignadoA ?? _asignadoA,
      comentarios: comentarios ?? _comentarios,
      creadoPor: creadoPor ?? _creadoPor,
      datos: datos ?? _datos,
      descripcion: descripcion ?? _descripcion,
      diagnostico: diagnostico ?? _diagnostico,
      fechaActualizacion: fechaActualizacion ?? _fechaActualizacion,
      fechaCreacion: fechaCreacion ?? _fechaCreacion,
      fechaFin: fechaFin ?? _fechaFin,
      fechaInicio: fechaInicio ?? _fechaInicio,
      id: id ?? _id,
      idExterno: idExterno ?? _idExterno,
      idPaciente: idPaciente ?? _idPaciente,
      idServicio: idServicio ?? _idServicio,
      idSesion: idSesion ?? _idSesion,
      leido: leido ?? _leido,
      medicacion: medicacion ?? _medicacion,
      nombrePaciente: nombrePaciente ?? _nombrePaciente,
      nombreServicio: nombreServicio ?? _nombreServicio,
      nombreUsuario: nombreUsuario ?? _nombreUsuario,
      observaciones: observaciones ?? _observaciones,
      recomendaciones: recomendaciones ?? _recomendaciones,
      status: status ?? _status,
      tipo: tipo ?? _tipo,
      titulo: titulo ?? _titulo,
      usuarioId: usuarioId ?? _usuarioId,
      etiquetas: etiquetas ?? _etiquetas,
      revisadoPor: revisadoPor ?? _revisadoPor,
      prioridad: prioridad ?? _prioridad,
      firmado: firmado ?? _firmado,
      firma: firma ?? _firma,
      fechaFirma: fechaFirma ?? _fechaFirma,
    );
  }
}
