# wallet_app

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

    
