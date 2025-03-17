import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import '../../datos/modelos/reportes/reporte.dart';
import '../../nucleo/errores/errores_reporte.dart';

class ServicioExportacionReportes {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene un reporte desde Firestore
  Future<Reporte?> obtenerReporte(String id) async {
    final doc = await _db.collection('reportes').doc(id).get();
    if (doc.exists) {
      return Reporte.fromDocumentSnapshot(doc);
    }
    return null;
  }

  /// Exporta un reporte en formato PDF
  Future<String> exportarReportePDF(String id) async {
    try {
      final reporte = await obtenerReporte(id);
      if (reporte == null) {
        throw ExportacionReporteException(
          'No se encontró el reporte con ID: $id',
        );
      }

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            _construirEncabezadoPDF(
                reporte), // 
            _construirCuerpoPDF(reporte),
            _construirPiePDF(reporte), // 
          ],
        ),
      );

      final directorio = await _obtenerDirectorioTemporal();
      final nombreArchivo =
          'reporte_${reporte.id}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final rutaArchivo = '${directorio.path}/$nombreArchivo';

      final archivo = File(rutaArchivo);
      await archivo.writeAsBytes(await pdf.save());

      return rutaArchivo;
    } catch (e) {
      throw ExportacionReporteException(
        'Error al exportar reporte a PDF',
        e,
      );
    }
  }

  /// Construye el pie del PDF
  pw.Widget _construirPiePDF(Reporte reporte) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text('Prioridad: ${reporte.prioridad}'),
        if (reporte.firmado)
          pw.Text(
              'Firmado por: ${reporte.firma} el ${_formatearFecha(reporte.fechaFirma!)}'),
      ],
    );
  }

  /// Obtiene el directorio temporal
  Future<Directory> _obtenerDirectorioTemporal() async {
    if (kIsWeb) {
      throw ExportacionReporteException(
        'La exportación de archivos no está soportada en web',
      );
    }
    return await getTemporaryDirectory();
  }

  /// Formatea una fecha en formato legible
  String _formatearFecha(DateTime fecha) {
    return DateFormat('dd/MM/yyyy HH:mm').format(fecha);
  }

  /// Construye el encabezado del PDF
  pw.Widget _construirEncabezadoPDF(Reporte reporte) {
    return pw.Header(
      level: 0,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Reporte ${reporte.tipoReporte.toUpperCase()}',
              style:
                  pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Text('ID: ${reporte.id}'),
          pw.Text('Fecha: ${_formatearFecha(reporte.fechaCreacion)}'),
          pw.Text('Creado por: ${reporte.creadoPor}'),
        ],
      ),
    );
  }

  /// Construye el cuerpo del PDF
  pw.Widget _construirCuerpoPDF(Reporte reporte) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        pw.Text('Detalles',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 10),
        pw.Text('Descripción: ${reporte.descripcion}'),
        pw.Text('Estado: ${reporte.estado}'),
        if (reporte.asignadoA != null)
          pw.Text('Asignado a: ${reporte.asignadoA}'),
      ],
    );
  }
}
