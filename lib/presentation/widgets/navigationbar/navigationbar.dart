import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/inicio/inicio_screen.dart';
import 'package:recuerdamed/presentation/Screens/perfil/perfil_screen.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: NavigationExample());
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  final List<Widget> _pages = <Widget>[
    InicioScreen(),
    const Center(child: Text('Contenido de Mensajes')),
    PerfilScreen(),
  ];

  final List<NavigationDestination> _destinations =
      const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home, color: Colors.white),
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),

        NavigationDestination(
          selectedIcon: Icon(Icons.calendar_month, color: Colors.white),
          icon: Icon(Icons.calendar_month_outlined),
          label: 'Notificaciones',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person, color: Colors.white),
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: colors.primary,
        selectedIndex: currentPageIndex,
        destinations: _destinations,
      ),
      body: _pages[currentPageIndex],
    );
  }
}
