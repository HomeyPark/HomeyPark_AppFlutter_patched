import 'package:flutter/material.dart';

class NewPaymentCard extends StatelessWidget {
  final TextEditingController numCard;
  final TextEditingController cvv;
  final TextEditingController date;
  final TextEditingController holder;
  final VoidCallback onSave; // Agregar el callback

  NewPaymentCard({
    required this.numCard,
    required this.cvv,
    required this.date,
    required this.holder,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Agregar Tarjeta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: numCard,
            decoration: InputDecoration(
              labelText: 'Número de Tarjeta',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: cvv,
            decoration: InputDecoration(
              labelText: 'CVV',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: date,
            decoration: InputDecoration(
              labelText: 'Fecha de Expiración (MM/AA)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.datetime,
          ),
          SizedBox(height: 10),
          TextFormField(
            controller: holder,
            decoration: InputDecoration(
              labelText: 'Nombre del Titular',
              border: OutlineInputBorder(),
            ),
          ),
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