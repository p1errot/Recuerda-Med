import 'package:flutter/material.dart';

class Medicamento {
  final String nombre;
  final int cantidad;
  final int cadaCuantoHoras;
  final TimeOfDay horaInicio;
  final DateTime fechaInicio;

  Medicamento({
    required this.nombre,
    required this.cantidad,
    required this.cadaCuantoHoras,
    required this.horaInicio,
    required this.fechaInicio,
  });

  factory Medicamento.fromMap(Map<String, dynamic> map) {
    final List<String> horaParts = (map['hora_inicio'] as String).split(':');
    final TimeOfDay hora = TimeOfDay(
      hour: int.parse(horaParts[0]),
      minute: int.parse(horaParts[1]),
    );

    return Medicamento(
      nombre: map['nombre'] as String,
      cantidad: map['cantidad'] as int,
      cadaCuantoHoras: map['cada_cuanto_horas'] as int,
      horaInicio: hora,
      fechaInicio: DateTime.parse(map['fecha_inicio'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'cantidad': cantidad,
      'cada_cuanto_horas': cadaCuantoHoras,
      'hora_inicio':
          '${horaInicio.hour.toString().padLeft(2, '0')}:${horaInicio.minute.toString().padLeft(2, '0')}',
      'fecha_inicio': fechaInicio.toIso8601String().split('T')[0],
    };
  }

  List<DateTime> getTomaTimesForDay(DateTime day) {
    List<DateTime> tomaTimes = [];
    DateTime startOfDay = DateTime(day.year, day.month, day.day);
    DateTime medicationStartDate = DateTime(
      fechaInicio.year,
      fechaInicio.month,
      fechaInicio.day,
    );

    if (startOfDay.isBefore(medicationStartDate)) {
      return tomaTimes;
    }

    DateTime currentToma = DateTime(
      day.year,
      day.month,
      day.day,
      horaInicio.hour,
      horaInicio.minute,
    );

    if (day.isAtSameMomentAs(medicationStartDate)) {
      while (currentToma.isBefore(fechaInicio)) {
        currentToma = currentToma.add(Duration(hours: cadaCuantoHoras));
      }
    }

    while (currentToma.day == day.day &&
        currentToma.month == day.month &&
        currentToma.year == day.year) {
      tomaTimes.add(currentToma);
      currentToma = currentToma.add(Duration(hours: cadaCuantoHoras));
    }
    return tomaTimes;
  }

  DateTime? getNextTomaTime() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);

    if (today.isBefore(
      DateTime(fechaInicio.year, fechaInicio.month, fechaInicio.day),
    )) {
      return null;
    }

    DateTime firstTomaToday = DateTime(
      now.year,
      now.month,
      now.day,
      horaInicio.hour,
      horaInicio.minute,
    );

    if (firstTomaToday.isBefore(fechaInicio)) {
      firstTomaToday = fechaInicio;
      while (firstTomaToday.isBefore(now)) {
        firstTomaToday = firstTomaToday.add(Duration(hours: cadaCuantoHoras));
      }
      if (firstTomaToday.isBefore(now)) {
        firstTomaToday = firstTomaToday.add(Duration(hours: cadaCuantoHoras));
      }
    }

    DateTime? nextToma;
    DateTime currentToma = firstTomaToday;

    while (currentToma.day == now.day &&
        currentToma.month == now.month &&
        currentToma.year == now.year) {
      if (currentToma.isAfter(now)) {
        nextToma = currentToma;
        break;
      }
      currentToma = currentToma.add(Duration(hours: cadaCuantoHoras));
    }

    if (nextToma == null) {
      DateTime nextDay = today.add(const Duration(days: 1));
      currentToma = DateTime(
        nextDay.year,
        nextDay.month,
        nextDay.day,
        horaInicio.hour,
        horaInicio.minute,
      );
      if (nextDay.isBefore(
        DateTime(fechaInicio.year, fechaInicio.month, fechaInicio.day),
      )) {
        return null;
      }
      nextToma = currentToma;
    }

    return nextToma;
  }
}

Future<Map<String, dynamic>?> obtenerDatosMedicamento(
  BuildContext context, {
  Medicamento? medicamentoExistente,
}) async {
  final TextEditingController nombreCtrl = TextEditingController(
    text: medicamentoExistente?.nombre,
  );
  final TextEditingController cantidadCtrl = TextEditingController(
    text: medicamentoExistente?.cantidad.toString(),
  );
  final TextEditingController cadaCuantoCtrl = TextEditingController(
    text: medicamentoExistente?.cadaCuantoHoras.toString(),
  );

  TimeOfDay? horaInicioPicked =
      medicamentoExistente?.horaInicio;
  String currentHoraSeleccionada = medicamentoExistente != null
      ? '${medicamentoExistente.horaInicio.hour.toString().padLeft(2, '0')}:${medicamentoExistente.horaInicio.minute.toString().padLeft(2, '0')}'
      : '00:00';

  DateTime? fechaInicioPicked = medicamentoExistente?.fechaInicio;

  final Map<String, dynamic>? result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Text(
              medicamentoExistente == null
                  ? 'Nuevo medicamento'
                  : 'Editar medicamento',
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    controller: cantidadCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                  ),
                  TextField(
                    controller: cadaCuantoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cada cuántas horas',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: const Text('Hora de inicio'),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: horaInicioPicked ?? TimeOfDay.now(),
                            );
                            if (picked != null) {
                              horaInicioPicked = picked;
                              setStateDialog(() {
                                currentHoraSeleccionada =
                                    '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        currentHoraSeleccionada,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.calendar_today),
                          label: const Text('Fecha de inicio'),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fechaInicioPicked ?? DateTime.now(),
                              firstDate: DateTime.now().subtract(
                                const Duration(days: 365),
                              ),
                              lastDate: DateTime.now().add(
                                const Duration(days: 365 * 5),
                              ),
                            );
                            if (picked != null) {
                              setStateDialog(() {
                                fechaInicioPicked = picked;
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        fechaInicioPicked != null
                            ? '${fechaInicioPicked!.day}/${fechaInicioPicked!.month}/${fechaInicioPicked!.year}'
                            : 'Seleccionar fecha',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final nombre = nombreCtrl.text.trim();
                  final cantidad = int.tryParse(cantidadCtrl.text);
                  final cada = int.tryParse(cadaCuantoCtrl.text);

                  if (nombre.isNotEmpty &&
                      cantidad != null &&
                      cada != null &&
                      horaInicioPicked != null &&
                      fechaInicioPicked != null) {
                    final medicamentoData = {
                      "nombre": nombre,
                      "cantidad": cantidad,
                      "cada_cuanto_horas": cada,
                      "hora_inicio": horaInicioPicked,
                      "fecha_inicio": fechaInicioPicked!
                          .toIso8601String()
                          .split('T')[0],
                    };
                    Navigator.pop(dialogContext, medicamentoData);
                  } else {
                    Navigator.pop(dialogContext);
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    },
  );

  return result;
}
