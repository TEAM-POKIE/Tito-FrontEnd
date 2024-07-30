import 'dart:convert';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/core/api/multpart_file_with_to_json.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/data/models/auth_response.dart';

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
  Future<AuthResponse> signIn(@Body() Map<String, dynamic> loginData);

  @GET("users")
  Future<LoginInfo> getUserInfo();

  @PATCH("users/{id}")
  Future<void> updateUserProfile(
      @Path("id") int id, @Body() Map<String, dynamic> data);

  @GET("debates")
  Future<List<Debate>> getDebateList();
}
