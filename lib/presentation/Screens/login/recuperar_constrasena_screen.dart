import 'package:flutter/material.dart';
import 'package:recuerdamed/data/database/database_helper.dart';
import 'package:recuerdamed/utils/password_util.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  Map<String, String?> validateFields() {
    final errors = <String, String?>{};

    if (_usernameController.text.trim().isEmpty) {
      errors['username'] = 'Ingresa tu nombre de usuario';
    }
    if (_emailController.text.trim().isEmpty) {
      errors['email'] = 'Ingresa tu correo electrónico';
    } else if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(_emailController.text)) {
      errors['email'] = 'Ingresa un correo electrónico válido';
    }

    if (_newPasswordController.text.isEmpty) {
      errors['newPassword'] = 'La contraseña es obligatoria';
    } else if (_newPasswordController.text.length < 3) {
      errors['newPassword'] = 'La contraseña debe tener al menos 3 caracteres';
    }
    if (_newPasswordController.text != _confirmPasswordController.text) {
      errors['confirmPassword'] = 'Las contraseñas no coinciden';
    }

    return errors;
  }

  Future<bool> resetPassword(
    String username,
    String email,
    String newPassword,
  ) async {
    final dbHelper = DatabaseHelper();
    final hashedPassword = PasswordUtil.hashPassword(newPassword);

    // Por seguridad se busca usuario por nombre de usuario y correo electrónico
    final users = await dbHelper.query(
      'users',
      where: 'username = ? AND email = ?',
      whereArgs: [username, email],
    );

    if (users.isEmpty) {
      return false;
    }

    final user = users.first;

    final updateResult = await dbHelper.update(
      'users',
      {
        'password': hashedPassword,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [user['id']],
    );

    return updateResult > 0;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'RecuerdaMed',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Recuperar contraseña',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa tu nombre de usuario y correo electrónico para restablecer tu contraseña.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Nombre de usuario',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Nueva contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirmar nueva contraseña',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    final scaffoldContext = context;

                    final errors = validateFields();

                    if (errors.isNotEmpty) {
                      String errorMessage =
                          errors.values.first ??
                          'Por favor verifica los campos';
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(
                          content: Text(errorMessage),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    showDialog(
                      context: scaffoldContext,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      final success = await resetPassword(
                        _usernameController.text.trim(),
                        _emailController.text.trim(),
                        _newPasswordController.text,
                      );

                      if (!mounted) return;

                      Navigator.pop(scaffoldContext);

                      if (success) {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          const SnackBar(
                            content: Text('¡Contraseña actualizada con éxito!'),
                            backgroundColor: Colors.green,
                          ),
                        );

                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            Navigator.pop(scaffoldContext);
                          }
                        });
                      } else {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'No se encontró una cuenta con ese nombre de usuario y correo',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      if (!mounted) return;

                      Navigator.pop(scaffoldContext);

                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Recuperar'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
