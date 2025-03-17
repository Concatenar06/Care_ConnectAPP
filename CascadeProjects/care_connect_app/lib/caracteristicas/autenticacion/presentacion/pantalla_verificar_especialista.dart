import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart';
import '../../../nucleo/errores/error_base.dart';
import '../../../presentacion/widgets/barras/barra_app.dart';
import '../../../presentacion/widgets/botones/boton_primario.dart';
import '../../../nucleo/utilidades/controladores/controlador_admin.dart';
import '../dominio/usuario.dart';

class PantallaVerificarEspecialista extends StatelessWidget {
  const PantallaVerificarEspecialista({super.key});

  @override
  Widget build(BuildContext context) {
    final controladorAdmin = Provider.of<ControladorAdmin>(context);

    return Scaffold(
      appBar: const BarraApp(
        titulo: 'Verificar Especialista',
      ),
      body: FutureBuilder<Either<ErrorBase, List<Usuario>>>(
        future: controladorAdmin.obtenerUsuariosPendientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando especialistas pendientes...'),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar los datos: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No hay datos disponibles'),
            );
          }

          return snapshot.data!.fold(
            (error) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      size: 48, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${error.mensaje}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.orange[700]),
                  ),
                ],
              ),
            ),
            (usuarios) => usuarios.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle,
                            size: 48, color: Colors.green),
                        const SizedBox(height: 16),
                        Text(
                          'No hay especialistas pendientes de verificación',
                          style: TextStyle(color: Colors.green[700]),
                        ),
                      ],
                    ),
                  )
                : _ListaEspecialistas(
                    usuarios: usuarios,
                    controladorAdmin: controladorAdmin,
                  ),
          );
        },
      ),
    );
  }
}

class _ListaEspecialistas extends StatelessWidget {
  final List<Usuario> usuarios;
  final ControladorAdmin controladorAdmin;

  const _ListaEspecialistas({
    required this.usuarios,
    required this.controladorAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: usuarios.length,
      itemBuilder: (context, index) {
        final usuario = usuarios[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: usuario.fotoPerfil != null
                          ? NetworkImage(usuario.fotoPerfil!)
                          : null,
                      child: usuario.fotoPerfil == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            usuario.nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              'Especialidad: ${usuario.especialidad ?? "No especificada"}'),
                          if (usuario.numeroLicencia != null)
                            Text('Licencia: ${usuario.numeroLicencia}'),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Pendiente',
                        style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Documentos:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (usuario.metadatos['documentos'] != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        children: [
                          ...(usuario.metadatos['documentos'] as List).map(
                            (doc) => GestureDetector(
                              onTap: () {
                                final String? url = doc is Map
                                    ? doc['url']?.toString()
                                    : (doc is String ? doc : null);

                                if (url != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Image.network(
                                            url,
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return const CircularProgressIndicator();
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Cerrar'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                              child: _DocumentoChip(
                                nombre: doc is Map
                                    ? (doc['nombre']?.toString() ?? 'Documento')
                                    : (doc?.toString() ?? 'Documento'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  const _DocumentoChip(nombre: 'Sin documentos'),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: BotonPrimario(
                        texto: 'Aprobar',
                        onPressed: () async {
                          final confirmar = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar Aprobación'),
                              content: const Text(
                                '¿Estás seguro de que deseas aprobar a este especialista? '
                                'Esta acción le permitirá comenzar a ofrecer servicios en la plataforma.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Aprobar'),
                                ),
                              ],
                            ),
                          );

                          if (confirmar == true && context.mounted) {
                            try {
                              await controladorAdmin
                                  .verificarEspecialista(usuario.uid);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Especialista verificado correctamente',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al verificar: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        habilitado: true,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: BotonPrimario(
                        texto: 'Rechazar',
                        onPressed: () async {
                          final motivo = await _mostrarDialogoRechazo(context);
                          if (motivo != null && context.mounted) {
                            try {
                              await controladorAdmin.rechazarEspecialista(
                                usuario.uid,
                                motivo,
                              );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Especialista rechazado'),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error al rechazar: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },
                        habilitado: true,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _mostrarDialogoRechazo(BuildContext context) async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Motivo del rechazo'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Ingrese el motivo del rechazo',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                Navigator.pop(context, controller.text.trim());
              }
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }
}

class _DocumentoChip extends StatelessWidget {
  final String nombre;

  const _DocumentoChip({
    required this.nombre,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.description,
            size: 16,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            nombre,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
