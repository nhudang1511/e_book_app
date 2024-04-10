import 'custom_model.dart';

class Coins extends CustomModel{

  final int? quantity;
  final String? uId;
  final String? coinsId;

  Coins({this.quantity, this.uId, this.coinsId});

  @override
  Coins fromJson(Map<String, dynamic> json) {
    Coins coins = Coins(
      quantity: json['quantity'],
      uId: json['uId'],
      coinsId: json['id'],
    );
    return coins;
  }

  @override
  Map<String, dynamic> toJson() {
   return {
     'quantity': quantity,
     'uId': uId,
   };
  }
}