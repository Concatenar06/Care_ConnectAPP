import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import '../../../nucleo/utilidades/rol_usuario.dart';

/// Clase que representa un usuario en el sistema
class Usuario {
  // Constructor
  const Usuario({
    required this.uid,
    required this.email,
    required this.nombre,
    required this.rol,
    this.activo = true,
    required this.fechaRegistro,
    this.telefono,
    this.direccion,
    this.especialidad,
    this.fotoPerfil,
    this.pacientesAsignados = const [],
    this.serviciosAsignados = const [],
    this.notificacionesActivas = true,
    this.ultimoAcceso,
    this.metadatos = const {},
    this.emailVerificado = false,
    this.numeroLicencia,
    this.cuidadoresAsignados = const [],
    this.fechaNacimiento,
    this.grupoSanguineo,
    this.alergias = const [],
    this.condicionesMedicas = const [],
    this.pacientesFamiliares = const [],
  });

  // Propiedades
  final String uid;
  final String email;
  final String nombre;
  final RolUsuario rol;
  final bool activo;
  final DateTime fechaRegistro;
  final String? telefono;
  final String? direccion;
  final String? especialidad;
  final String? fotoPerfil;
  final List<String> pacientesAsignados;
  final List<String> serviciosAsignados;
  final bool notificacionesActivas;
  final DateTime? ultimoAcceso;
  final Map<String, dynamic> metadatos;
  final bool emailVerificado;
  final String? numeroLicencia;
  final List<String> cuidadoresAsignados;
  final DateTime? fechaNacimiento;
  final String? grupoSanguineo;
  final List<String> alergias;
  final List<String> condicionesMedicas;
  final List<String> pacientesFamiliares;

  /// Crea una instancia de Usuario a partir de un mapa JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      uid: json['uid'] as String,
      email: json['email'] as String,
      nombre: json['nombre'] as String,
      rol: RolUsuario.values.firstWhere(
        (e) => e.toString() == 'RolUsuario.${json['rol']}',
        orElse: () => RolUsuario.paciente,
      ),
      activo: json['activo'] as bool? ?? true,
      fechaRegistro: _convertirTimestamp(json['fechaRegistro']),
      telefono: json['telefono'] as String?,
      direccion: json['direccion'] as String?,
      especialidad: json['especialidad'] as String?,
      fotoPerfil: json['fotoPerfil'] as String?,
      pacientesAsignados: _convertirLista(json['pacientesAsignados']),
      serviciosAsignados: _convertirLista(json['serviciosAsignados']),
      notificacionesActivas: json['notificacionesActivas'] as bool? ?? true,
      ultimoAcceso: json['ultimoAcceso'] != null
          ? _convertirTimestamp(json['ultimoAcceso'])
          : null,
      metadatos: (json['metadatos'] as Map<String, dynamic>?) ?? {},
      emailVerificado: json['emailVerificado'] as bool? ?? false,
      numeroLicencia: json['numeroLicencia'] as String?,
      cuidadoresAsignados: _convertirLista(json['cuidadoresAsignados']),
      fechaNacimiento: json['fechaNacimiento'] != null
          ? _convertirTimestamp(json['fechaNacimiento'])
          : null,
      grupoSanguineo: json['grupoSanguineo'] as String?,
      alergias: _convertirLista(json['alergias']),
      condicionesMedicas: _convertirLista(json['condicionesMedicas']),
      pacientesFamiliares: _convertirLista(json['pacientesFamiliares']),
    );
  }

  /// Crea una instancia de Usuario a partir de un DocumentSnapshot de Firestore
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Usuario.fromJson({...data, 'uid': doc.id});
  }

  /// Crea una instancia de Usuario a partir de un usuario de Firebase Auth
  factory Usuario.fromFirebaseUser(auth.User firebaseUser, {RolUsuario rol = RolUsuario.paciente}) {
    return Usuario(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      nombre: firebaseUser.displayName ?? '',
      rol: rol,
      fechaRegistro: DateTime.now(),
      fotoPerfil: firebaseUser.photoURL,
      emailVerificado: firebaseUser.emailVerified,
    );
  }

  /// Crea una instancia de Usuario a partir de un usuario de Firebase Auth
  factory Usuario.fromFirebase(auth.User firebaseUser, {RolUsuario rol = RolUsuario.paciente}) {
    return Usuario(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      nombre: firebaseUser.displayName ?? '',
      rol: rol,
      fechaRegistro: DateTime.now(),
      fotoPerfil: firebaseUser.photoURL,
      emailVerificado: firebaseUser.emailVerified,
    );
  }

  /// Convierte el usuario a un mapa JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'nombre': nombre,
      'rol': rol.toString().split('.').last,
      'activo': activo,
      'fechaRegistro': fechaRegistro,
      'telefono': telefono,
      'direccion': direccion,
      'especialidad': especialidad,
      'fotoPerfil': fotoPerfil,
      'pacientesAsignados': pacientesAsignados,
      'serviciosAsignados': serviciosAsignados,
      'notificacionesActivas': notificacionesActivas,
      'ultimoAcceso': ultimoAcceso,
      'metadatos': metadatos,
      'emailVerificado': emailVerificado,
      'numeroLicencia': numeroLicencia,
      'cuidadoresAsignados': cuidadoresAsignados,
      'fechaNacimiento': fechaNacimiento,
      'grupoSanguineo': grupoSanguineo,
      'alergias': alergias,
      'condicionesMedicas': condicionesMedicas,
      'pacientesFamiliares': pacientesFamiliares,
    };
  }

  /// Convierte el usuario a un formato compatible con Firestore
  Map<String, dynamic> toFirestore() {
    return toJson()
      ..addAll({
        'fechaRegistro': Timestamp.fromDate(fechaRegistro),
        if (ultimoAcceso != null)
          'ultimoAcceso': Timestamp.fromDate(ultimoAcceso!),
        if (fechaNacimiento != null)
          'fechaNacimiento': Timestamp.fromDate(fechaNacimiento!),
      });
  }

  /// Crea una copia del usuario con algunos campos actualizados
  Usuario copyWith({
    String? uid,
    String? email,
    String? nombre,
    RolUsuario? rol,
    bool? activo,
    DateTime? fechaRegistro,
    String? telefono,
    String? direccion,
    String? especialidad,
    String? fotoPerfil,
    List<String>? pacientesAsignados,
    List<String>? serviciosAsignados,
    bool? notificacionesActivas,
    DateTime? ultimoAcceso,
    Map<String, dynamic>? metadatos,
    bool? emailVerificado,
    String? numeroLicencia,
    List<String>? cuidadoresAsignados,
    DateTime? fechaNacimiento,
    String? grupoSanguineo,
    List<String>? alergias,
    List<String>? condicionesMedicas,
    List<String>? pacientesFamiliares,
  }) {
    return Usuario(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      rol: rol ?? this.rol,
      activo: activo ?? this.activo,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      telefono: telefono ?? this.telefono,
      direccion: direccion ?? this.direccion,
      especialidad: especialidad ?? this.especialidad,
      fotoPerfil: fotoPerfil ?? this.fotoPerfil,
      pacientesAsignados: pacientesAsignados ?? this.pacientesAsignados,
      serviciosAsignados: serviciosAsignados ?? this.serviciosAsignados,
      notificacionesActivas: notificacionesActivas ?? this.notificacionesActivas,
      ultimoAcceso: ultimoAcceso ?? this.ultimoAcceso,
      metadatos: metadatos ?? this.metadatos,
      emailVerificado: emailVerificado ?? this.emailVerificado,
      numeroLicencia: numeroLicencia ?? this.numeroLicencia,
      cuidadoresAsignados: cuidadoresAsignados ?? this.cuidadoresAsignados,
      fechaNacimiento: fechaNacimiento ?? this.fechaNacimiento,
      grupoSanguineo: grupoSanguineo ?? this.grupoSanguineo,
      alergias: alergias ?? this.alergias,
      condicionesMedicas: condicionesMedicas ?? this.condicionesMedicas,
      pacientesFamiliares: pacientesFamiliares ?? this.pacientesFamiliares,
    );
  }
}

// Métodos auxiliares para conversión de datos
DateTime _convertirTimestamp(dynamic value) {
  if (value is Timestamp) {
    return value.toDate();
  } else if (value is DateTime) {
    return value;
  } else if (value is String) {
    return DateTime.parse(value);
  }
  return DateTime.now();
}

List<String> _convertirLista(dynamic value) {
  if (value is List) {
    return value.map((e) => e.toString()).toList();
  }
  return [];
}
