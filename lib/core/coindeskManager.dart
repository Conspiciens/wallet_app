import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wallet_app/classes/coin.dart';

class CoindeskManager {
  List<Coin> _currentPrice = []; 
  static const String link = String.fromEnvironment("LIVETRADES_URL");
  late WebSocketChannel channel; 

  CoindeskManager() {
    print("WSS: $link"); 
    channel = WebSocketChannel.connect(Uri.parse(link)); 
    channel.sink.add(
      '''{
        "action": "SUBSCRIBE",
        "type": "spot_v1_latest_tick",
        "groups": [
          "VALUE",
          "CURRENT_HOUR"
        ],
        "market": "coinbase",
        "instruments": [
          "ETH-USD"
        ]
      }'''
    );
  }

  Stream<dynamic> getChannel() { 
    return channel.stream; 
  }

  
}