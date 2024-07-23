import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/src/data/models/login_info.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://dev-tito.owsla.duckdns.org/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("{endpoint}.json")
  Future<Map<String, dynamic>> getData(@Path("endpoint") String endpoint);

  @PATCH("{endpoint}.json")
  Future<bool> patchData(
      @Path("endpoint") String endpoint, @Body() Map<String, dynamic> data);

  @POST("{endpoint}.json")
  Future<bool> postData(
      @Path("endpoint") String endpoint, @Body() Map<String, dynamic> data);

  @POST("auth/sign-up")
  Future<void> signUp(@Body() Map<String, dynamic> signUpData);

  @POST("auth/sign-in")
  Future<Map<String, dynamic>> signIn(@Body() Map<String, dynamic> loginData);

  @GET("users")
  Future<Map<String, dynamic>> getUserInfo();
}
