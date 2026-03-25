# wallet_app

A Simple Wallet App that manages your crypto on your phone. Should be a simple app and I'll attempt to minimize attack vectors as much as possible. 

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
    ''' 

## TODO 
    - Add Peppering to password 
    - Add Logging Framework
    ✓ Added ability to remove wallet

    