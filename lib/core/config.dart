class Config {
    static const String HISTORICAL_TRADE = String.fromEnvironment("HISTORICAL_TRADES"); 
    static const String COINDESK_KEY = String.fromEnvironment("COINDESK_KEY"); 
    static const String DBNAME = String.fromEnvironment("DB_PATH"); 
    static const String LIVETRADES_URL = String.fromEnvironment("LIVETRADES_URL");

    static const String API_URL = String.fromEnvironment("API_URL"); 
    static const String API_KEY = String.fromEnvironment("API_KEY"); 

    static const String TYPE = String.fromEnvironment("TYPE"); 

    static Config? _instance; 

    factory Config() {
      if (TYPE == "dev") {
        /* DEV */
      }
      _instance ??= Config._internal(); 
      return _instance!; 
    }

    Config._internal();
}