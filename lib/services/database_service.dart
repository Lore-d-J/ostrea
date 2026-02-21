/// This file is deprecated and no longer used.
/// 
/// The application has been migrated to use LocalDataService instead,
/// which stores all data locally using SharedPreferences.
/// 
/// See: lib/services/local_data_service.dart

@Deprecated('Use LocalDataService instead')
class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();

  factory DatabaseService() => _instance;

  DatabaseService._internal();
}