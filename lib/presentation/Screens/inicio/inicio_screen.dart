import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/crearMedicamento/medicamento_screen.dart';

class InicioScreen extends StatefulWidget {
  final List<Medicamento> medicamentos;
  final Function(Medicamento) onMedicamentoAdded;
  final Function(String) onSearchChanged;

  const InicioScreen({
    super.key,
    required this.medicamentos,
    required this.onMedicamentoAdded,
    required this.onSearchChanged,
  });

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  List<Medicamento> _medicamentosFiltro = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filterMedicamentos();
    _searchController.addListener(() {
      _filterMedicamentos();
      widget.onSearchChanged(_searchController.text);
    });
  }

  @override
  void didUpdateWidget(covariant InicioScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.medicamentos != oldWidget.medicamentos ||
        widget.medicamentos.length != oldWidget.medicamentos.length) {
      _filterMedicamentos();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _addMedicamento() async {
    final success = await obtenerDatosMedicamento(context);

    if (success) {
      final dummyMedicamento = Medicamento(
        nombre: '',
        cantidad: 0,
        cadaCuantoHoras: 0,
        horaInicio: const TimeOfDay(hour: 0, minute: 0),
        fechaInicio: DateTime.now(),
      );
      widget.onMedicamentoAdded(dummyMedicamento);
    }
  }

  void _filterMedicamentos() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _medicamentosFiltro = List.from(widget.medicamentos);
      } else {
        _medicamentosFiltro = widget.medicamentos
            .where(
              (medicamento) => medicamento.nombre.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.medicamentos.isNotEmpty ||
            _searchController.text.isNotEmpty) ...[
          _buildSearchBar(),
          const Divider(thickness: 1),
        ],
        Expanded(child: _buildListView()),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar medicamentos...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0)),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          widget.onSearchChanged(value);
        },
      ),
    );
  }

  Widget _buildListView() {
    if (widget.medicamentos.isEmpty && _searchController.text.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'No hay medicamentos registrados actualmente.',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addMedicamento,
              child: const Text('Agregar Medicamento'),
            ),
          ],
        ),
      );
    } else if (_medicamentosFiltro.isEmpty &&
        _searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'No se encontraron medicamentos para tu búsqueda.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: _medicamentosFiltro.length,
      itemBuilder: (BuildContext context, int index) {
        final medicamento = _medicamentosFiltro[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: const Icon(Icons.medication, color: Colors.blueAccent),
            title: Text(
              medicamento.nombre,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              'Cantidad: ${medicamento.cantidad} | Cada ${medicamento.cadaCuantoHoras}h | Inicio: ${medicamento.horaInicio.format(context)} | Fecha: ${medicamento.fechaInicio.day}/${medicamento.fechaInicio.month}/${medicamento.fechaInicio.year}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
            onTap: () {
              print('Tap en ${medicamento.nombre}');
            },
          ),
        );
      },
    );
  }
}
