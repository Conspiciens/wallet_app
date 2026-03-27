# wallet_app

<table align="center" border="0">
  <tr>
    <td align="center" width="33%">
      <a href="https://hardhat.org/">
        <img src="https://hardhat.org/images/hardhat-logo-dark.svg" height="80" alt="Hardhat">
      </a>
    </td>
    <td align="center" width="33%">
      <a href="https://flutter.dev">
        <img src="https://flutter.dev/assets/lockup_flutter_horizontal.549a1b7dd82615e8e9c95c1ade8cee42.svg" height="80" alt="Flutter">
      </a>
    </td>
    <td align="center" width="33%">
      <a href="https://supabase.com">
        <img src="https://raw.githubusercontent.com/supabase/supabase/master/packages/common/assets/images/supabase-logo-wordmark--dark.svg" height="80" alt="Supabase">
      </a>
    </td>
  </tr>
</table>

A Simple Wallet App that manages your crypto on your phone. Should be a simple app and I'll attempt to minimize attack vectors as much as possible. 

<p align="center"> 
    <img src="https://img.shields.io/badge/Hardhat-3.0.0-yellow?style=for-the-badge&logo=Hardhat3" alt="Hardhat 3">
    <img src="https://img.shields.io/badge/flutter-blue?style=for-the-badge&logo=Flutter" alt="Flutter">
    <img src="https://img.shields.io/badge/supabase-darkgreen?style=for-the-badge&logo=Supabase" alt="Supabase">
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

    
