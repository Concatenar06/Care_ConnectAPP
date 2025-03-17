import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../caracteristicas/autenticacion/datos/servicio_usuarios.dart';
import '../../../caracteristicas/autenticacion/dominio/usuario.dart';
import '../../../servicios/configuracion/servicio_almacenamiento.dart';
import '../../errores/error_base.dart';
import 'controlador_base.dart';

/// Controlador para operaciones relacionadas con el perfil del usuario
@injectable
class ControladorPerfil {
  final ControladorBase _base;
  final ServicioUsuarios _servicioUsuarios;
  final ServicioAlmacenamiento _servicioAlmacenamiento;

  ControladorPerfil(
    this._base,
    this._servicioUsuarios,
    this._servicioAlmacenamiento,
  );

  /// Actualiza los datos del perfil del usuario
  Future<Either<ErrorBase, Usuario>> actualizarPerfil({
    required String id,
    required String nombre,
    String? telefono,
    Map<String, dynamic>? metadatos,
  }) {
    return _base.ejecutarOperacion(
      operacion: () async {
        final usuario = await _servicioUsuarios.obtenerUsuario(id);
        final usuarioActualizado = usuario.copyWith(
          nombre: nombre,
          metadatos: {
            ...usuario.metadatos,
            if (telefono != null) 'telefono': telefono,
            if (metadatos != null) ...metadatos,
          },
        );
        await _servicioUsuarios.actualizarUsuario(usuarioActualizado);
        return usuarioActualizado;
      },
      mensajeError: 'Error al actualizar perfil',
    );
  }

  /// Actualiza la foto de perfil del usuario
  Future<Either<ErrorBase, String>> actualizarFotoPerfil({
    required String id,
    required File foto,
  }) {
    return _base.ejecutarOperacion(
      operacion: () async {
        // Subir foto al almacenamiento
        final urlFoto = await _servicioAlmacenamiento.subirFoto(
          foto: foto,
          ruta: 'fotos_perfil/$id.jpg',
        );

        // Actualizar URL en el usuario
        final usuario = await _servicioUsuarios.obtenerUsuario(id);
        final usuarioActualizado = usuario.copyWith(
          metadatos: {
            ...usuario.metadatos,
            'urlFoto': urlFoto,
          },
        );
        await _servicioUsuarios.actualizarUsuario(usuarioActualizado);

        return urlFoto;
      },
      mensajeError: 'Error al actualizar foto de perfil',
    );
  }

  /// Obtiene los datos del perfil del usuario
  Future<Either<ErrorBase, Usuario>> obtenerPerfil(String id) {
    return _base.ejecutarOperacion(
      operacion: () => _servicioUsuarios.obtenerUsuario(id),
      mensajeError: 'Error al obtener perfil',
    );
  }
}
