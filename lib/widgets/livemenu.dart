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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initTrading(); 
      }); 
    }

    void _initTrading() async {
      final response = await history.fetchTrades(); 
      if (!mounted) return; 
      setState(() {
        tradingHistory = response; 
      }); 
    }

    @override
    Widget build(BuildContext context) {
      return Column(children: [
        SfCartesianChart(
          margin: EdgeInsets.zero,
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            axisLine: AxisLine(width: 0),
          ),
          primaryYAxis: CategoryAxis(
            axisLine: AxisLine(width: 0),
          ),
          title: ChartTitle(text: "ETH-USD Trading"),
          tooltipBehavior: TooltipBehavior(enable: true),
          legend: Legend(isVisible: false),
          trackballBehavior: TrackballBehavior(
            activationMode: ActivationMode.longPress,
            enable: true, 
          ),
          series: <CartesianSeries<Trade, double>>[
            AreaSeries(
              dataSource: tradingHistory,
              xValueMapper: (Trade trade, _) => trade.timestamp, 
              yValueMapper: (Trade trade, _) => trade.lastTradePrice,
              color: Colors.purple.shade100,
              dataLabelSettings: DataLabelSettings(isVisible: true),
            )
          ],
        )
      ]);
    }
}