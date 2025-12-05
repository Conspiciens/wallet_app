import 'dart:io';
import 'dart:math';
import 'package:web3dart/web3dart.dart'; 


/* void privateKeyCertification(String privateKey) {
  Credentials cred = EthPrivateKey.fromHex(privateKey); 
} */



Wallet signInFromFile(File walletJson, String password) {
  Wallet wallet; 
  try {
    String content = walletJson.readAsStringSync(); 
    wallet = Wallet.fromJson(content, password); 
  } catch (err) {
    print("Error Occurred: $err");
    throw Exception("Failed to sing in from File"); 
  }

  return wallet; 
}


Wallet createWallet(String password) {
  Wallet wallet; 
  var rng = Random.secure(); 

  try {
    EthPrivateKey newCred = EthPrivateKey.createRandom(rng); 
    wallet = Wallet.createNew(newCred, password, rng);
  } catch (err) {
    print("Error Occured: $err"); 
    throw Exception("Failed to create Wallet");
  }
  
  return wallet; 
}