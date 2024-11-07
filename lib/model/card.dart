class PaymentCard {
  final int? id;
  final double numCard;
  final double cvv;
  final String date;
  final String holder;

  PaymentCard(
      { this.id,
        required this.numCard,
        required this.cvv,
        required this.date,
        required this.holder
      });

  factory PaymentCard.fromJson(Map<String, dynamic> json) {
    return PaymentCard(
      id: json['id'],
      numCard: json['numCard'],
      cvv: json['cvv'],
      date: json['date'],
      holder: json['holder']
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'numCard': numCard,
      'cvv': cvv,
      'date': date,
      'holder': holder,
    };
  }
}