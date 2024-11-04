import 'package:flutter/material.dart';
import 'package:homey_park/widgets/widgets.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout",
          style: theme.textTheme.titleMedium,
        ),
        backgroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            CardWithHeader(
              headerTextStr: "Horario",
              body: Text("Hello world"),
            ),
          ],
        ),
      ),
    );
  }
}
