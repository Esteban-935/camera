import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Camera Streaming',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Control de estado de conexión y URL de streaming
  final TextEditingController _ipController = TextEditingController();
  String? streamUrl;
  bool isConnected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conectar a la Cámara ESP32'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Campo de texto para ingresar la dirección IP
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _ipController,
                decoration: InputDecoration(
                  labelText: 'Ingrese la IP de la ESP32',
                  border: OutlineInputBorder(),
                  errorText: _ipController.text.isEmpty ? 'La IP es requerida' : null,
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: false),
              ),
            ),
            SizedBox(height: 20),
            // Botón para conectar o desconectar
            ElevatedButton(
              onPressed: () {
                if (_ipController.text.isNotEmpty) {
                  setState(() {
                    streamUrl = 'http://${_ipController.text}/stream'; // Construir la URL
                    isConnected = !isConnected; // Cambiar el estado de conexión
                  });
                } else {
                  // Mostrar mensaje si la IP no está ingresada
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor ingrese una IP válida.')),
                  );
                }
              },
              child: Text(isConnected ? 'Desconectar' : 'Conectar'),
            ),
            SizedBox(height: 20),
            // Mostrar el stream solo si está conectado
            isConnected && streamUrl != null
                ? Container(
                    height: 300,
                    width: 400,
                    child: Mjpeg(
                      isLive: true,
                      stream: streamUrl!, // Usar la URL de streaming ingresada
                    ),
                  )
                : Text('Esperando conexión...'),
          ],
        ),
      ),
    );
  }
}