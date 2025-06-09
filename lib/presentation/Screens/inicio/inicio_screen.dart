import 'package:flutter/material.dart';

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  final List<String> _medicamentos = List.generate(
    20,
    (index) => 'Medicamento ${index + 1}',
  );

  List<String> _medicamentosFiltro = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _medicamentosFiltro = List.from(_medicamentos);

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecuerdaMed'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              return print("Añadir Medicamento");
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_medicamentos.isNotEmpty) ...[
            _buildSearchBar(),
            const Divider(thickness: 1),
          ],
          Expanded(child: _buildListView()),
        ],
      ),
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
                    setState(() {
                      _medicamentosFiltro = List.from(_medicamentos);
                    });
                    FocusScope.of(context).unfocus();
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            if (value.isEmpty) {
              _medicamentosFiltro = List.from(_medicamentos);
            } else {
              _medicamentosFiltro = _medicamentos
                  .where(
                    (item) => item.toLowerCase().contains(value.toLowerCase()),
                  )
                  .toList();
            }
          });
        },
      ),
    );
  }

  Widget _buildListView() {
    if (_medicamentosFiltro.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No hay medicamentos registrados actualmente.'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                return print("Añadir Medicamento");
              },
              child: const Text('Agregar Medicamento'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _medicamentosFiltro.length,
      itemBuilder: (BuildContext context, int index) {
        final medicamento = _medicamentosFiltro[index];
        return ListTile(
          leading: const Icon(Icons.medication),
          title: Text(medicamento),
          subtitle: Text('Próxima dosis en ${index + 1} hora(s)'),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            print('Tap en $medicamento');
            // Navegar hacia la página de detalles
            // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(item: item)));
          },
        );
      },
    );
  }
}
