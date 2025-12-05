import 'package:http/http.dart'; 
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class Wallet {
    final API_KEY = String.fromEnvironment("API_KEY"); 
    final API_URL = String.fromEnvironment("API_URL"); 

    final Client httpClient; 
    
    Wallet({required this.httpClient}); 
    
    Future<EtherAmount> getBalance(Credentials creds) async {
      if (API_URL == "") throw Exception("No API URL found"); 
      if (API_KEY == "") throw Exception("No API Key found"); 

      final fullApiUrl = API_URL + API_KEY; 
      final ethClient = Web3Client(fullApiUrl, httpClient); 

      final address = creds.address; 
    
      return await ethClient.getBalance(address); 
    }

}