import 'package:flutter/material.dart';

class NewVehicle extends StatelessWidget {
  final TextEditingController licenseplate;
  final TextEditingController brand;
  final TextEditingController model;
  final VoidCallback onSave;

  NewVehicle({
    required this.licenseplate,
    required this.brand,
    required this.model,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Vehiculo'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: licenseplate,
            decoration: InputDecoration(
              labelText: 'Número de placa',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: brand,
            decoration: InputDecoration(
              labelText: 'Nombre de la marca',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: model,
            decoration: InputDecoration(
              labelText: 'Nombre del modelo',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancelar', style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: onSave,  // Llamar al onSave que fue pasado
          child: Text('Agregar'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }
}