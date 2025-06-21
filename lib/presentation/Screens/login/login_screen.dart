import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/login/recuperar_constrasena_screen.dart';
import 'package:recuerdamed/presentation/Screens/login/registro_screen.dart';
import 'package:recuerdamed/presentation/widgets/navigationbar/navigationbar.dart';
import 'package:recuerdamed/data/database/database_helper.dart';

// Function to validate if user exists in the database
Future<bool> validateUser(String email, String password) async {
  final dbHelper = DatabaseHelper();
  final result = await dbHelper.query(
    'users',
    where: '(email = ? OR username = ?) AND password = ?',
    whereArgs: [email, password],
  );

  // If the query returns any results, the user exists
  return result.isNotEmpty;
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 60),
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
                'Inicio de sesión',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ingresa tu correo electrónico y contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Usuario o email',
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
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
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
                    // Store context before async operation
                    final scaffoldContext = context;

                    // Show loading indicator
                    showDialog(
                      context: scaffoldContext,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      // Use the validateUser function to check credentials
                      final isValidUser = await validateUser(
                        emailController.text,
                        passwordController.text,
                      );

                      // Check if the widget is still in the tree
                      if (!mounted) return;

                      // Close the loading dialog
                      Navigator.pop(scaffoldContext);

                      if (isValidUser) {
                        // Navigate to home screen
                        Navigator.pushReplacement(
                          scaffoldContext,
                          MaterialPageRoute(
                            builder: (context) => const NavigationBarApp(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Credenciales incorrectas. Por favor, inténtalo de nuevo.',
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      // Check if the widget is still in the tree
                      if (!mounted) return;

                      // Close the loading dialog and show error
                      Navigator.pop(scaffoldContext);
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Continuar'),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    side: BorderSide(color: colors.primary),
                    foregroundColor: colors.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text('Registrar'),
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PasswordRecoveryScreen(),
                    ),
                  );
                },
                child: Text(
                  '¿Olvidaste tu contraseña? Haz clic aquí para restablecerla.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: colors.secondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
