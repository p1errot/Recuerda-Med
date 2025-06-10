import 'package:flutter/material.dart';
import 'package:recuerdamed/presentation/Screens/crearMedicamento/medicamento_screen.dart';

class NextTomaScreen extends StatefulWidget {
  final List<Medicamento> medicamentos;

  const NextTomaScreen({super.key, required this.medicamentos});

  @override
  State<NextTomaScreen> createState() => _NextTomaScreenState();
}

class _NextTomaScreenState extends State<NextTomaScreen> {
  List<Map<String, dynamic>> _allNextTomaData = [];

  @override
  void initState() {
    super.initState();
    _calculateAllNextTomaData();
  }

  @override
  void didUpdateWidget(covariant NextTomaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.medicamentos != oldWidget.medicamentos ||
        widget.medicamentos.length != oldWidget.medicamentos.length) {
      _calculateAllNextTomaData();
    }
  }

  void _calculateAllNextTomaData() {
    List<Map<String, dynamic>> tempTomaData = [];
    DateTime now = DateTime.now();
    DateTime endOfSearch = now.add(
      const Duration(days: 2),
    );

    for (var med in widget.medicamentos) {
      for (int i = 0; i < 2; i++) {
        DateTime dayToSearch = now.add(Duration(days: i));
        List<DateTime> tomaTimesForDay = med.getTomaTimesForDay(dayToSearch);

        for (var tomaTime in tomaTimesForDay) {
          if (tomaTime.isAfter(now) && tomaTime.isBefore(endOfSearch)) {
            tempTomaData.add({'time': tomaTime, 'medicamento': med});
          }
        }
      }
    }

    tempTomaData.sort(
      (a, b) => (a['time'] as DateTime).compareTo(b['time'] as DateTime),
    );

    setState(() {
      _allNextTomaData = tempTomaData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Próximas Tomas'),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _allNextTomaData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 80,
                    color: Colors.green.shade300,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '¡No hay tomas programadas para el futuro cercano!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Parece que todas las dosis de hoy ya han sido tomadas o no hay medicamentos activos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver a inicio'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _allNextTomaData.length,
              itemBuilder: (context, index) {
                final toma = _allNextTomaData[index];
                final DateTime tomaTime = toma['time'] as DateTime;
                final Medicamento medicamento =
                    toma['medicamento'] as Medicamento;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.lightBlue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Theme.of(context).primaryColor,
                              size: 30,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${tomaTime.hour.toString().padLeft(2, '0')}:${tomaTime.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${tomaTime.day}/${tomaTime.month}/${tomaTime.year}',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                        const Divider(height: 20, thickness: 1),
                        Text(
                          medicamento.nombre,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Cantidad: ${medicamento.cantidad}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
