# wallet_app

<p align="center">
  <a href="https://hardhat.org/" target="_blank">
    <img src="https://hardhat.org/assets/img/hardhat-logo.84805e7a.svg" width="400" alt="Hardhat Logo">
  </a>
  <a href="https://flutter.dev" target="_blank">
    <img src="https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59fef0e7245c.png" width="150" alt="Flutter Logo">
  </a>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <a href="https://supabase.com" target="_blank">
    <img src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--light.svg#gh-light-mode-only" width="250" alt="Supabase Logo">
    <img src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--dark.svg#gh-dark-mode-only" width="250" alt="Supabase Logo">
  </a>
</p>

A Simple Wallet App that manages your crypto on your phone. Should be a simple app and I'll attempt to minimize attack vectors as much as possible. 

<p algin="center"> 
    <img src="https://img.shields.io/badge/Hardhat-3.0.0-yellow?style=for-the-badge&logo=hardhat" alt="Hardhat 3">
</p> 


## Getting Started
    ''' 
        Create a config.dev.json and follow the .config.dev.json.example
    ''' 

    Command: flutter run --dart-define=config.dev.json  --dart-define=DEBUG_MODE=true


# Architecture
    ''' 
        Keychain (Use FaceID or passcode required before authenicating) 
            - Store Key: Email, Value: Unique UID (Pass to access wallet)
            -> SQlite 
                - Store individual wallets (ID, Wallet Name, Wallet Json)
                - KeyChain stores the password for each individual wallet
                -> Wallet
        CoinDesk for ETH-USD market
    ''' 
# Installation
    '''
        npx install supabase
        npx supabase init 

        pip install requirements
        python3 collect_ex_data_coindesk.py
        pip install requirements
        python3 local_server.py

        mkdir hardhat-test
        cd hardhat-test
    
        npx hardhat init
    ''' 

## TODO 
    - Add Peppering to password 
    - Add Logging Framework
    ✓ Added ability to remove wallet
    ✓ Supabase local Auth

    
