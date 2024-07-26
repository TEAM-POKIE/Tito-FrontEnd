import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';

class ApiPath {
  static final ApiService apiService = ApiService(DioClient.dio);
}
