import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/crearMedicamento/medicamento_screen.dart';
import 'package:recuerdamed/presentation/Screens/inicio/inicio_screen.dart';
import 'package:recuerdamed/presentation/Screens/perfil/perfil_screen.dart';
import 'package:recuerdamed/presentation/Screens/proximatoma/proxima_toma_screen.dart';
import 'package:recuerdamed/data/database/database_helper.dart';
import 'package:recuerdamed/utils/user_session.dart';

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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicamentos();
  }

  // Load medications from the database
  Future<void> _loadMedicamentos() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userId = await UserSession().userId;
      if (userId == null) {
        // User not logged in, show empty list
        setState(() {
          _medicamentos = [];
          _isLoading = false;
        });
        return;
      }

      final dbHelper = DatabaseHelper();
      final result = await dbHelper.query(
        'medicines',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      setState(() {
        _medicamentos = result
            .map(
              (medicineData) => Medicamento.fromMap({
                'nombre': medicineData['name'] as String,
                'cantidad': medicineData['quantity'] as int,
                'cada_cuanto_horas': medicineData['every_hours'] as int,
                'hora_inicio': medicineData['start_time'] as String,
                'fecha_inicio': medicineData['start_date'] as String,
              }),
            )
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading medications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Refresh medications list - now we just reload from database instead of adding manually
  void _refreshMedicamentos() {
    _loadMedicamentos();
  }

  void _onSearchQueryChanged(String query) {
    // Implement search functionality here
  }

  // Adapter function to match the expected signature
  void _handleMedicamentoAdded(Medicamento medicamento) {
    _refreshMedicamentos();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final List<Widget> _pages = <Widget>[
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : InicioScreen(
              medicamentos: _medicamentos,
              onMedicamentoAdded: _handleMedicamentoAdded,
              onSearchChanged: _onSearchQueryChanged,
            ),
      _isLoading
          ? const Center(child: CircularProgressIndicator())
          : NextTomaScreen(medicamentos: _medicamentos),
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
                final success = await obtenerDatosMedicamento(context);

                if (success) {
                  _refreshMedicamentos();
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Por favor, ve a la pantalla de Inicio para añadir medicamentos.',
                    ),
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
