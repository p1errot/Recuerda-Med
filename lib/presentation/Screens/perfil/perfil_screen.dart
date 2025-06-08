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
                TextoA(text: "edad:", width: 0.35),
                TextoA(text: "22 años", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "fecha de nacimiento:", width: 0.35),
                TextoA(text: "14/09/2002", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "tipo de sangre:", width: 0.35),
                TextoA(text: "O+", width: 0.5, aling: 1),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const <Widget>[
                TextoA(text: "Medicamentos formulados", width: 0.9),
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
  const TextoA({
    super.key,
    required this.text,
    required this.width,
    this.aling = 0,
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
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: aling == 0 ? TextAlign.left : TextAlign.right,
        ),
      ),
    );
  }
}
