import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil del paciente"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.brush),
            onPressed: () {
              return print("hola");
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const TextoA(text: "Nombre:", width: 0.35),
                const TextoA(
                  text: "Andres camilo Rueda campo",
                  width: 0.5,
                  aling: 1,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Edad:", width: 0.35),
                TextoA(text: "22 años", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Fecha de nacimiento:", width: 0.35),
                TextoA(text: "14/09/2002", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Tipo de sangre:", width: 0.35),
                TextoA(text: "O+", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Dirección:", width: 0.35),
                TextoA(text: "14/09/2002", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Correo:", width: 0.35),
                TextoA(text: "O+", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "teléfono", width: 0.35),
                TextoA(text: "14/09/2002", width: 0.5, aling: 1),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(
                  text: "Medicamentos formulados",
                  width: 0.35,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                TextoA(
                  text: "Tiempo consumo",
                  width: 0.35,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "ibuprofeno:", width: 0.35),
                TextoA(text: "2 Semanas", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Paracetamol:", width: 0.35),
                TextoA(text: "1 mes", width: 0.5, aling: 1),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TextoA extends StatelessWidget {
  final String text;
  final double width;
  final int aling;
  final TextStyle? style;
  const TextoA({
    super.key,
    required this.text,
    required this.width,
    this.aling = 0,
    this.style,
  });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(size.width * 0.02),
      color: Colors.transparent,
      child: SizedBox(
        width: size.width * width,
        // Ancho específico para este Text
        child: Text(
          text,
          style: style,
          textAlign: aling == 0 ? TextAlign.left : TextAlign.right,
        ),
      ),
    );
  }
}
