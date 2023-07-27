import 'package:bitcoin_ticker_flutter/services/networking.dart';

const apiKey = 'C2EBEA0A-1ED6-4F08-9BB6-503D00E51168';
const coinApiUrl = 'https://rest.coinapi.io/v1';

class ExchangeModel {
  String cryptoName = '';
  ExchangeModel({required cryptoName});
  Future<dynamic> getRateData(String? currency) async {
    final uri = Uri.parse(
        '$coinApiUrl/exchangerate/$cryptoName/$currency?apikey=$apiKey');
    NetworkHelper networkHelper = NetworkHelper(url: uri);
    return networkHelper.getData();
  }
}