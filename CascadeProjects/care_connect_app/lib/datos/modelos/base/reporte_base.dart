import 'modelo_base.dart';
import 'i_reporte.dart';

/// Clase base para los reportes en la aplicación
/// @deprecated Use Reporte o ReporteAdmin en su lugar
abstract class ReporteBase implements IReporte, ModeloBase {
  const ReporteBase();

  @override
  String get id;

  @override
  String get usuarioId;

  @override
  String get titulo;

  @override
  String get descripcion;

  @override
  DateTime get fechaCreacion;

  @override
  DateTime? get fechaActualizacion;

  @override
  bool get resuelto;

  @override
  String? get resolutorId;

  /// Convierte el reporte a un formato compatible con Firestore
  @override
  Map<String, dynamic> toFirestore();

  /// Valida la integridad del reporte
  @override
  bool validar() {
    return id.isNotEmpty && 
           usuarioId.isNotEmpty && 
           titulo.isNotEmpty && 
           descripcion.isNotEmpty;
  }
}
