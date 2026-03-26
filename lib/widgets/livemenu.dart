import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:wallet_app/core/coindeskRestAPI.dart';
import 'package:wallet_app/core/coindeskTrading.dart';
import 'package:wallet_app/classes/coin.dart';
import 'package:wallet_app/classes/trades.dart';
import 'dart:convert'; 

class liveChart extends StatefulWidget {
    const liveChart({super.key}); 

    @override
    _liveChartWidget createState() => _liveChartWidget();     
}

class _liveChartWidget extends State<liveChart> {
    HistoricalTrades history = HistoricalTrades(
      market: "Kraken", 
      instrument: "ETH-USD", 
      groups: [], 
      limit: 30, 
      aggregate: 1, 
      fill: true, 
      applyMapping: true);
    List<Trade> tradingHistory = []; 


    @override
    void initState() {
      super.initState();
      _initTrading(); 
    }

    void _initTrading() async {
      setState(() async {
        tradingHistory = await history.fetchTrades(); 
      });
    }

    @override
    Widget build(BuildContext context) {
      return Column(children: [
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: "ETH-USD Trading"),
          legend: Legend(isVisible: false),
          series: <CartesianSeries<Trade, double>>[
            LineSeries(
              dataSource: tradingHistory,
              xValueMapper: (Trade trade, _) => trade.timestamp, 
              yValueMapper: (Trade trade, _) => trade.lastTradePrice,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        )
      ]);
    }
}