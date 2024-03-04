import 'dart:convert';

import 'package:coinance/pages/details_page.dart';
import 'package:coinance/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? deviceHeight, deviceWidth;
  String? selectedCoin = "bitcoin";
  HTTPService? http;

  @override
  void initState() {
    super.initState();
    http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              selectedCoinDropdown(),
              _dataWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget selectedCoinDropdown() {
    List<String> coins = [
      "bitcoin",
      "ethereum",
      "cardano",
      "tether",
      "ripple",
      ];
    List<DropdownMenuItem<String>> items = coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w600, 
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      value: selectedCoin,
      items: items,
      onChanged: (dynamic value) {
        setState(() {
          selectedCoin = value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 50,
      icon: const Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidget() {
    return FutureBuilder(
      future: http!.get("/coins/$selectedCoin"),
      builder: (BuildContext content, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          Map data = jsonDecode(
            snapshot.data.toString(),
          );
          num usdPrice = data["market_data"]["current_price"]["usd"];
          num change24h = data["market_data"]["price_change_percentage_24h"];
          Map exchangeRate = data["market_data"]["current_price"];
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (BuildContext context) {
                      return DetailsPage(rates: exchangeRate);
                     },
                    ),
                  );
                },
                child: coinImageWidget(
                  data["image"]["small"],
                ),
              ),
              currentPriceWidget(usdPrice),
              percentageChangeWidget(change24h),
              descriptionCardWidget(
                data["description"]["en"],
              ),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget currentPriceWidget(num rate) {
    return Text(
      "${rate.toStringAsFixed(2)} USD",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 30,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget percentageChangeWidget(num change) {
    return Text(
      "${change.toString()} %",
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget coinImageWidget(String imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: deviceHeight! * 0.02),
      height: deviceHeight! * 0.15,
      width: deviceHeight! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imgURL),
        ),
      ),
    );
  }

  Widget descriptionCardWidget(String description) {
    return Container(
      height: deviceHeight! * 0.45,
      width: deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(
        vertical: deviceHeight! * 0.05,
      ),
      padding: EdgeInsets.symmetric(
        vertical: deviceHeight! * 0.01,
        horizontal: deviceHeight! * 0.01,
      ),
      color: const Color.fromRGBO(83, 88, 206, 0.5),
      child: Text(
        description,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
