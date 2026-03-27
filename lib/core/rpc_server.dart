import 'dart:core';
import 'package:http/http.dart'; 
import 'package:wallet/wallet.dart';
import 'package:web3dart/web3dart.dart';

class WalletInfo {
    final Web3Client ethClient; 
    
    WalletInfo({required this.ethClient}); 
    
    Future<EtherAmount> getBalance(EthereumAddress addr) async {
      return await ethClient.getBalance(addr); 
    }

    Future<void> sendTransaction(Credentials creds) async {}
}