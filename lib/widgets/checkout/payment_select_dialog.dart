import 'package:flutter/material.dart';
import 'package:homey_park/config/pref/preferences.dart';
import 'package:homey_park/model/card.dart';
import 'package:homey_park/services/user_service.dart';

class PaymentSelectDialog extends StatefulWidget {
  const PaymentSelectDialog({super.key});

  @override
  State<PaymentSelectDialog> createState() => _PaymentSelectDialogState();
}

class _PaymentSelectDialogState extends State<PaymentSelectDialog> {
  Future? _cardsFuture;
  int? _currentCardId;
  PaymentCard? _card;

  Future _fetchCards() async {
    final userId = await preferences.getUserId();
    return UserService.getUserById(userId);
  }

  @override
  void initState() {
    super.initState();
    _cardsFuture = _fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text("Seleccione un medio de pago",
          style: theme.textTheme.titleMedium),
      content: SizedBox(
        width: double.maxFinite,
        child: FutureBuilder(
          future: _cardsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("Ocurrió un error al cargar los datos."),
              );
            }

            if (!snapshot.hasData || snapshot.data?.cards == null) {
              return const Center(
                child: Text("No se encontraron métodos de pago."),
              );
            }

            final cards = snapshot.data!.cards;

            if (cards.isEmpty) {
              return const Center(
                child: Text("No tienes tarjetas guardadas."),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return ListTile(
                  trailing: Icon(
                      _currentCardId == card.id
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: theme.primaryColor),
                  leading: const Icon(Icons.credit_card),
                  title: Text(card.holder, style: theme.textTheme.labelLarge),
                  subtitle: Text(
                    "**** **** **** ${card.numCard.toInt().toString().substring(12)}",
                    style: theme.textTheme.labelMedium,
                  ),
                  onTap: () {
                    setState(() {
                      _currentCardId = card.id;
                      _card = card;
                    });
                  },
                );
              },
            );
          },
        ),
      ),
      actions: [
        OutlinedButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: theme.colorScheme.error)),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancelar",
              style: TextStyle(color: theme.colorScheme.error)),
        ),
        FilledButton(
          style: ButtonStyle(
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          onPressed: () {
            if (_currentCardId != null) {
              Navigator.of(context).pop(_card);
            }
          },
          child: const Text("Aceptar"),
        ),
      ],
    );
  }
}
