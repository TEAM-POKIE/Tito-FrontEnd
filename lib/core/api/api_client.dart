import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dio_client.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  static ApiClient create() {
    final dio = DioClient.dio;
    return ApiClient(dio);
  }
}
