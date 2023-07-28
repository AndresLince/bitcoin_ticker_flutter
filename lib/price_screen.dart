import 'package:bitcoin_ticker_flutter/coin_data.dart';
import 'package:bitcoin_ticker_flutter/services/exchange.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  List<ExchangeModel> exchangeModels = [];
  String? selectedCurrency = 'USD';
  String rate = '?';
  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );

      dropDownItems.add(newItem);
    }
    return DropdownButton(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        getExchangeData(exchangeModels);
        setState(() {
          selectedCurrency = value;
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  void getExchangeData(List<ExchangeModel> exchangeModels) async {
    for (ExchangeModel exchange in exchangeModels) {
      dynamic rateData = await exchange.getRateData(selectedCurrency);
      exchange.rate = rateData['rate'].toStringAsFixed(2);
    }
    setState(() {
      exchangeModels = exchangeModels;
    });

  }

  void updateUI(dynamic rateData) {
    setState(() {
      if (rateData == null) {
        rate = '?';
        return;
      }
      rate = rateData['rate'].toStringAsFixed(2);
    });
  }

  List <Widget> createExchangeCards(List<ExchangeModel> exchangeModels) {
    List<Widget> exchangeCards = [];
    for (ExchangeModel exchange in exchangeModels) {
      var newItem = createExchangeCard(exchange.cryptoName, exchange.rate);
      exchangeCards.add(newItem);
    }
    exchangeCards.add( Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS? iosPicker(): androidDropDown(),),);
    return exchangeCards;
  }

  createExchangeCard(String crypto, String rate) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $rate USD',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for (String crypto in cryptoList) {
      ExchangeModel exchangeModel = ExchangeModel(cryptoName: crypto);
      exchangeModels.add(exchangeModel);
    }
    //print(exchangeModels);
    getExchangeData(exchangeModels);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: createExchangeCards(exchangeModels),
      ),
    );
  }
}
