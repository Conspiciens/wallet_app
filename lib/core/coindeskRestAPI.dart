import 'dart:convert';
import 'package:wallet_app/classes/trades.dart'; 
import 'package:http/http.dart' as http; 

class HistoricalTrades {
    static const API = String.fromEnvironment("HISTORICALTRADES_URL");
    static const API_KEY = String.fromEnvironment("COINDESK_KEY");

    final String market; 
    final String instrument; 
    final List<String> groups; 
    final int limit; 
    final int aggregate; 
    final bool fill; 
    final bool applyMapping; 

    late Uri completeUri; 

    HistoricalTrades({
      required this.market, 
      required this.instrument,
      required this.groups,
      required this.limit,
      required this.aggregate, 
      required this.fill, 
      required this.applyMapping }) {
        completeUri = Uri.https(API, "/spot/v1/historical/days",
          {
            "market": market, 
            "instrument": instrument, 
            "groups": [], 
            "limit": limit.toString(), 
            "aggregate": '1', 
            "fill": fill.toString(), 
            "apply_mapping": true.toString(), 
            "api_key": API_KEY
          }
        );
      }
    
    Future<List<Trade>> fetchTrades() async {
      List<Trade> allTrades = []; 

      final response = await http.get(
        completeUri, 
      ); 

      if (response.statusCode == 200) {
        final jsonTrades = jsonDecode(response.body); 
        for (var prevTrade in jsonTrades["Data"]) {
          Trade trade = Trade(
            timestamp: double.parse(prevTrade["TIMESTAMP"].toString()),
            lastTradePrice: double.parse(prevTrade["LAST_TRADE_PRICE"].toString()) 
          ); 
          allTrades.add(trade); 
        }

        return allTrades; 
      } else {
        throw Exception("Failed to get response: Error code: ${response.statusCode}"); 
      }
    } 
}