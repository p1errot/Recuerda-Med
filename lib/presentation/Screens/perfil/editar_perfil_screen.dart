import 'package:flutter/material.dart';
import 'dart:convert';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final TextEditingController nombreController = TextEditingController(
    text: "nombre x",
  );
  final TextEditingController edadController = TextEditingController(
    text: "x años",
  );
  final TextEditingController fechaNacimientoController = TextEditingController(
    text: "00/00/0000",
  );
  final TextEditingController tipoSangreController = TextEditingController(
    text: "O+",
  );
  final TextEditingController direccionController = TextEditingController(
    text: "Calle falsa 123",
  );
  final TextEditingController correoController = TextEditingController(
    text: "correo@ejemplo.com",
  );
  final TextEditingController telefonoController = TextEditingController(
    text: "3001234567",
  );

  @override
  void dispose() {
    nombreController.dispose();
    edadController.dispose();
    fechaNacimientoController.dispose();
    tipoSangreController.dispose();
    direccionController.dispose();
    correoController.dispose();
    telefonoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCampo("Nombre", nombreController),
            _buildCampo("Edad", edadController),
            _buildCampo("Fecha de nacimiento", fechaNacimientoController),
            _buildCampo("Tipo de sangre", tipoSangreController),
            _buildCampo("Dirección", direccionController),
            _buildCampo("Correo", correoController),
            _buildCampo("Teléfono", telefonoController),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Map<String, dynamic> datosPerfil = {
                  "nombre": nombreController.text,
                  "edad": edadController.text,
                  "fechaNacimiento": fechaNacimientoController.text,
                  "tipoSangre": tipoSangreController.text,
                  "direccion": direccionController.text,
                  "correo": correoController.text,
                  "telefono": telefonoController.text,
                };

                String jsonDatosPerfil = jsonEncode(datosPerfil);
                print("Datos del perfil en JSON:");
                print(jsonDatosPerfil);
                print("Perfil actualizado");
              },
              child: const Text("Guardar cambios"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampo(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
