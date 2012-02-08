
    
    MERGE Common_Cnfg.Currency AS TARGET
    USING
    (
      SELECT 1,'ARS','Argentinean Pesos',1,1,0,1,'es','AR',2,2,'&#x41;&#x52;&#x53;',1 UNION ALL
      SELECT 2,'AUD','Australian dollar',1,1,0,1,'en','AU',2,2,'&#x41;&#x55;&#x44;',1 UNION ALL
      SELECT 3,'BGN','Bulgarian lev',1,1,0,1,'bg','BG',2,2,'&#x42;&#x47;&#x4E;',1 UNION ALL
      SELECT 4,'BRL','Brazilian Real',0,0,0,1,'pt','BR',2,2,'&#x42;&#x52;&#x4C;',0 UNION ALL
      SELECT 5,'CAD','Canadian dollar',1,1,0,1,'en','CA',2,2,'&#x43;&#x41;&#x44;',1 UNION ALL
      SELECT 6,'CHF','Swiss francs',1,1,0,1,'de','CH',2,2,'&#x43;&#x48;&#x46;',1 UNION ALL
      SELECT 7,'CNY','Chinese Renminbi',0,0,0,1,'zh','CN',2,2,'&#x43;&#x4E;&#x59;',1 UNION ALL
      SELECT 8,'CZK','Czech crowns',1,1,0,1,'cs','CZ',2,2,'&#x43;&#x5A;&#x4B;',1 UNION ALL
      SELECT 9,'DKK','Danish crowns',0,0,0,1,'dk','DK',2,2,'&#x44;&#x4B;&#x4B;',0 UNION ALL
      SELECT 10,'EEK','Estonian Kroon',0,0,0,1,'et','EE',2,2,'&#x45;&#x45;&#x4B;',0 UNION ALL
      SELECT 11,'EUR','Euro',1,1,1,1,'de','DE',2,2,'&#x20AC;',1 UNION ALL
      SELECT 12,'GBP','British Pound',1,1,0,1,'en','GB',2,2,'&#x00A3;',1 UNION ALL
      SELECT 13,'HKD','Hong Kong dollar',0,0,0,1,'en','HK',2,2,'&#x48;&#x4B;&#x44;',0 UNION ALL
      SELECT 14,'HRK','Croatian Kuna',0,0,0,1,'hr','HR',2,2,'&#x48;&#x52;&#x4B;',0 UNION ALL
      SELECT 15,'JWL','Jewel Currency',0,0,0,1,'de','DE',2,2,'&#x4A;&#x57;&#x4C;',0 UNION ALL
      SELECT 16,'LTL','Lithuanian Litas',0,0,0,1,'lt','LT',2,2,'&#x4C;&#x54;&#x4C;',0 UNION ALL
      SELECT 17,'LVL','Latvian Lats',0,0,0,1,'lv','LV',2,2,'&#x4C;&#x56;&#x4C;',0 UNION ALL
      SELECT 18,'NOK','Norwegian crowns',0,0,0,1,'no','NO',2,2,'&#x4E;&#x4F;&#x4B;',0 UNION ALL
      SELECT 19,'NZD','New Zeeland dollar',0,0,0,1,'en','NZ',2,2,'&#x4E;&#x5A;&#x44;',0 UNION ALL
      SELECT 20,'PLN','Polish zlotys',0,0,0,1,'pl','PL',2,2,'&#x50;&#x4C;&#x4E;',0 UNION ALL
      SELECT 21,'RON','Romanian leu',0,0,0,1,'ro','RO',2,2,'&#x52;&#x4F;&#x4E;',0 UNION ALL
      SELECT 22,'RUB','Russian rubles',0,0,0,1,'ru','RU',2,2,'&#x52;&#x55;&#x42;',0 UNION ALL
      SELECT 23,'SEK','Swedish crowns',1,1,0,1,'se','SE',2,2,'&#x53;&#x45;&#x4B;',1 UNION ALL
      SELECT 24,'SGD','Singapore dollar',1,1,0,1,'en','SG',2,2,'&#x53;&#x47;&#x44;',1 UNION ALL
      SELECT 25,'TRY','Turkish Lira',0,0,0,1,'tr','TR',2,2,'&#x54;&#x4C;',0 UNION ALL
      SELECT 26,'UAH','Ukraine Hrynja',0,0,0,1,'uk','UA',2,2,'&#x55;&#x41;&#x48;',0 UNION ALL
      SELECT 27,'USD','United States Dollars',1,1,0,1,'en','US',2,2,'&#x0024;',1 UNION ALL
      SELECT 29,'ZAR','South African Rand',0,0,0,1,'en','ZA',2,2,'&#x5A;&#x41;&#x52;',0
    ) 
    AS SOURCE ([CurrencyId], [CurrencyCode], [Name], [IsOperatorEnabled], [IsEnabledAsPlayerCurrency], [IsCasinoCurrency], [Provider], [LanguageCode], [CountryCode], [MaxiMumFractionDigits], [MinimumFractionDigits], [MajorCurrencySymbol], [HasBeenUsed] )

    ON (TARGET.[CurrencyCode] = SOURCE.[CurrencyCode])

    WHEN MATCHED THEN
    UPDATE SET
        [Name] = SOURCE.[Name]
      , [IsOperatorEnabled] = SOURCE.[IsOperatorEnabled]
      , [IsEnabledAsPlayerCurrency] = SOURCE.[IsEnabledAsPlayerCurrency]
      , [IsCasinoCurrency] = SOURCE.[IsCasinoCurrency]
      , [Provider] = SOURCE.[Provider]
      , [LanguageCode] = SOURCE.[LanguageCode]
      , [CountryCode] = SOURCE.[CountryCode]
      , [MaxiMumFractionDigits] = SOURCE.[MaxiMumFractionDigits]
      , [MinimumFractionDigits] = SOURCE.[MinimumFractionDigits]
      , [MajorCurrencySymbol] = SOURCE.[MajorCurrencySymbol]
      , [HasBeenUsed] = SOURCE.[HasBeenUsed]
      

    WHEN NOT MATCHED BY TARGET THEN
      INSERT ([CurrencyCode], [Name], [IsOperatorEnabled], [IsEnabledAsPlayerCurrency], [IsCasinoCurrency], [Provider], [LanguageCode], [CountryCode], [MaxiMumFractionDigits], [MinimumFractionDigits], [MajorCurrencySymbol], [HasBeenUsed])
      VALUES (SOURCE.[CurrencyCode], SOURCE.[Name], SOURCE.[IsOperatorEnabled], SOURCE.[IsEnabledAsPlayerCurrency], SOURCE.[IsCasinoCurrency], SOURCE.[Provider], SOURCE.[LanguageCode], SOURCE.[CountryCode], SOURCE.[MaxiMumFractionDigits], SOURCE.[MinimumFractionDigits], SOURCE.[MajorCurrencySymbol], SOURCE.[HasBeenUsed])
    ;
  