import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/proximatoma/proxima_toma_screen.dart';
import 'package:recuerdamed/presentation/Screens/crearMedicamento/medicamento_screen.dart';
import 'package:recuerdamed/presentation/Screens/inicio/inicio_screen.dart';

import 'package:recuerdamed/presentation/Screens/perfil/perfil_screen.dart';

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context);
    return MaterialApp(home: const NavigationExample(), theme: colors);
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;
  List<Medicamento> _medicamentos = [];
  @override
  void initState() {
    super.initState();
    _medicamentos = [
      Medicamento(nombre: 'Ibuprofeno', cantidad: 1, cadaCuantoHoras: 8, horaInicio: TimeOfDay(hour: 9, minute: 0), fechaInicio: DateTime.now().subtract(const Duration(days: 5))),
      Medicamento(nombre: 'Amoxicilina', cantidad: 500, cadaCuantoHoras: 12, horaInicio: TimeOfDay(hour: 8, minute: 0), fechaInicio: DateTime.now().subtract(const Duration(days: 2))),
      Medicamento(nombre: 'Paracetamol', cantidad: 1, cadaCuantoHoras: 6, horaInicio: TimeOfDay(hour: 10, minute: 0), fechaInicio: DateTime.now()),
    ];
  }

  void _addMedicamento(Medicamento newMedicamento) {
    setState(() {
      _medicamentos = List.from(_medicamentos)..add(newMedicamento);
    });
  }

  void _onSearchQueryChanged(String query) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final List<Widget> _pages = <Widget>[
      InicioScreen(
        medicamentos: _medicamentos, 
        onMedicamentoAdded: _addMedicamento,
        onSearchChanged: _onSearchQueryChanged,
      ),
      NextTomaScreen(medicamentos: _medicamentos), 
      const PerfilScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('RecuerdaMed'),
        centerTitle: true,
        backgroundColor: colors.primary,
        foregroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              if (currentPageIndex == 0) {
                final medicamentoMap = await obtenerDatosMedicamento(context);
                if (medicamentoMap != null) {
                  final newNombre = medicamentoMap["nombre"] as String;
                  final newCantidad = medicamentoMap["cantidad"] as int;
                  final newCadaCuantoHoras = medicamentoMap["cada_cuanto_horas"] as int;
                  final newHoraInicio = medicamentoMap["hora_inicio"] as TimeOfDay;
                  final newFechaInicio = DateTime.parse(medicamentoMap["fecha_inicio"] as String);

                  final nuevoMedicamento = Medicamento(
                    nombre: newNombre,
                    cantidad: newCantidad,
                    cadaCuantoHoras: newCadaCuantoHoras,
                    horaInicio: newHoraInicio,
                    fechaInicio: newFechaInicio,
                  );
                  _addMedicamento(nuevoMedicamento);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Medicamento "${nuevoMedicamento.nombre}" añadido correctamente.'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registro de medicamento cancelado o incompleto.'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, ve a la pantalla de Inicio para añadir medicamentos.'),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
          ),
        ],
      ),
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

  final List<NavigationDestination> _destinations =
      const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home, color: Colors.white),
          icon: Icon(Icons.home_outlined),
          label: 'Inicio',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.access_alarm, color: Colors.white),
          icon: Icon(Icons.access_alarm_outlined),
          label: 'Próxima Toma',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.person, color: Colors.white),
          icon: Icon(Icons.person_outline),
          label: 'Perfil',
        ),
      ];
}