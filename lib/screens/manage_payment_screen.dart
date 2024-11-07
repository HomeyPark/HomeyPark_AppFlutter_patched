import 'package:flutter/material.dart';
import 'package:homey_park/model/card.dart';
import 'package:homey_park/services/user_service.dart';
import 'package:homey_park/widgets/payment_card_widget.dart';
import 'package:homey_park/services/payment_service.dart';

class ManagePaymentScreen extends StatefulWidget {
  const ManagePaymentScreen({super.key});

  @override

  State<ManagePaymentScreen> createState() => _ManagePaymentScreenState();
}

class _ManagePaymentScreenState extends State<ManagePaymentScreen> {
  late List<PaymentCard> cards;

  final TextEditingController numCardController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController holderController = TextEditingController();

  void handleDeleteVehicle(int id) async {
    final response = await PaymentService.deletePaymentCard(id);

    if (response) {
      setState(() {
        cards.removeWhere((element) => element.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Metodo de pago",
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return NewPaymentCard(
                    numCard: numCardController,
                    cvv: cvvController,
                    date: dateController,
                    holder: holderController,
                    onSave: () async {
                      final numCard = double.tryParse(numCardController.text);
                      final cvv = double.tryParse(cvvController.text);

                      if (numCard == null || cvv == null) {
                        return;
                      }

                      final newCard = PaymentCard(
                        numCard: numCard,
                        cvv: cvv,
                        date: dateController.text,
                        holder: holderController.text,
                      );

                      final addedCard = await PaymentService.postPaymentCard(newCard);

                      if (addedCard != null) {
                        setState(() {
                          cards.add(addedCard);
                        });
                      }
                    },
                  );
                },
              );
            },
            child: const Text("Agregar"),
          )
        ],
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Gestiona tus metodos de pago.",
              style: theme.textTheme.bodyMedium
                  ?.apply(color: theme.colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 16),
            FutureBuilder(
                future: UserService.getUserById(1),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    cards = snapshot.data!.cards;

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              clipBehavior: Clip.antiAlias,
                              shadowColor:
                              theme.colorScheme.primary.withOpacity(0.4),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.credit_card),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text("${cards[index].numCard}",
                                              style: theme.textTheme.labelMedium
                                                  ?.apply(
                                                  color: theme.colorScheme
                                                      .onSurface)),
                                          Text(cards[index].holder,
                                              style: theme.textTheme.bodySmall
                                                  ?.apply(
                                                  color: theme.colorScheme
                                                      .onSurfaceVariant)),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {},
                                        icon:
                                        const Icon(Icons.edit_outlined)),
                                    IconButton(
                                        onPressed: () {
                                          handleDeleteVehicle(cards[index].id!);
                                        },
                                        icon:
                                        const Icon(Icons.delete_outlined))
                                  ],
                                ),
                              ),
                            ),
                            index == cards.length - 1
                                ? Container()
                                : const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                })
          ],
        ),
      ),
    );
  }
}

