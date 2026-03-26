import 'package:wallet_app/classes/trades.dart'; 
import 'package:http/http.dart' as http; 

class HistoricalTrades {
    static const API = String.fromEnvironment("HISTORICAL_TRADES");
    static const API_KEY = String.fromEnvironment("COINDESK_KEY");

    final String market; 
    final String instrument; 
    final List<String> groups; 
    final int limit; 
    final int aggregate; 
    final bool fill; 
    final bool applyMapping; 

    HistoricalTrades({
      required this.market, 
      required this.instrument,
      required this.groups,
      required this.limit,
      required this.aggregate, 
      required this.fill, 
      required this.applyMapping }); 
    
    Future<List<Trade>> fetchTrades() async {
      final completeUri = Uri.https(API, "",
      {
        "market": market, 
        "instrumenet": instrument, 
        "groups": [], 
        "limit": limit, 
        "aggregate": 1, 
        "fill": fill, 
        "apply_mapping": applyMapping, 
        "api_key": API_KEY
      });

      final response = await http.get(
        completeUri, 
      ); 

      if (response.statusCode == 200) {
      } else {
        throw Exception("Failed to get response: Error code: ${response.statusCode}"); 
      }
    } 
}

class Coindeskrestapi {
    static const API = String.fromEnvironment("HISTORICAL_TRADES");

    String request = '''
      {
        "market": "kraken", 
        "instrument": "ETH-USD", 
        "groups": [], 
        "limit": 10, 
        "to_ts": ${DateTime.now()}, 
        "aggregrate": 1, 
        "fill": true, 
        "apply_mapping": true, 
        "response_format": "JSON" 
      }
    '''; 
    List<Trade> market = []; 
    Coindeskrestapi(); 
}