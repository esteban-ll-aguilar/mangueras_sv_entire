import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mangueras_sv_entire/core/dependencies/dependencies_inyection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  // Datos de ejemplo del usuario
  final String userName = 'Usuario sin Nombre';
  final String userEmail = 'email@example.com';

  @override
  Widget build(BuildContext context) {
    final SupabaseClient _supabase = ref.read(supabaseProvider);

    return Scaffold(
      body: ListView(
        children: [
          // -------------------
          // Sección de Usuario
          // -------------------
          Container(
            color: Colors.deepPurple.shade100,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _supabase
                                  .auth
                                  .currentUser
                                  ?.userMetadata!['full_name'] ??
                              userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () async {
                            await _showChangeFullNameDialog();
                          },
                          icon: const Icon(
                            Icons.edit,
                            size: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      _supabase.auth.currentUser?.email ?? userEmail,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // -------------------
          // Sección de Controles
          // -------------------
          _buildSectionHeader('Controles'),
          _buildListTile(
            icon: Icons.person_add,
            title: 'Crear Usuario',
            subtitle: 'Crear un nuevo usuario en el sistema',
            onTap: () {
              context.go('/create-users');
            },
          ),
          const Divider(),

          // -------------------
          // Sección de Soporte
          // -------------------
          _buildSectionHeader('Soporte'),
          _buildListTile(
            icon: Icons.help_outline,
            title: 'Ayuda y Soporte',
            subtitle: 'FAQ, contacto',
            onTap: () {
              // Navegar a ayuda
            },
          ),
          _buildListTile(
            icon: Icons.info_outline,
            title: 'Acerca de',
            subtitle: 'Versión 1.0.0',
            onTap: _showAboutDialog,
          ),
          const Divider(),

        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple.shade300,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Acerca de'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Versión: 1.0.0'),
            SizedBox(height: 8),
            Text('Desarrollado con Flutter'),
            SizedBox(height: 8),
            Text('© 2025 Tu Empresa'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implementar lógica de cierre de sesión
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }

  //Build show dialog change full name
  Future<void> _showChangeFullNameDialog() async {
    final SupabaseClient _supabase = ref.read(supabaseProvider);
    final TextEditingController _fullNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Nombre Completo'),
        content: TextField(
          controller: _fullNameController,
          decoration: const InputDecoration(
            labelText: 'Nuevo Nombre Completo',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final newFullName = _fullNameController.text.trim();
              if (newFullName.isNotEmpty) {
                await _supabase.auth.updateUser(
                  UserAttributes(
                    data: {'full_name': newFullName},
                  ),
                );
              }
              Navigator.pop(context);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

}
