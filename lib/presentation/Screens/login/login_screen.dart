import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/login/recuperar_constrasena_screen.dart';
import 'package:recuerdamed/presentation/Screens/login/registro_screen.dart';
import 'package:recuerdamed/presentation/widgets/navigationbar/navigationbar.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
                  hintText: 'email@dominio.com',
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
                  hintText: 'contraseña',
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
                  onPressed: () {
                   
                    if (emailController.text == 'admin' &&
                        passwordController.text == '1234') {
                      Navigator.pushReplacement(
                       
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NavigationBarApp(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Credenciales incorrectas. Intenta con admin/1234.',
                          ),
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
