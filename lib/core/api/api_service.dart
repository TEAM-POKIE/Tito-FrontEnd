import 'dart:convert';
import 'dart:io';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/core/api/multpart_file_with_to_json.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/data/models/debate_list.dart';
import 'package:tito_app/src/data/models/debate_participants.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/data/models/auth_response.dart';
import 'package:tito_app/src/data/models/debate_usermade.dart';
import 'package:tito_app/src/data/models/user_profile.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://dev-tito.owsla.duckdns.org/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("auth/sign-up")
  Future<void> signUp(@Body() Map<String, dynamic> signUpData);

  @POST("auth/sign-in")
  Future<AuthResponse> signIn(@Body() Map<String, dynamic> loginData);

  @GET("users")
  Future<LoginInfo> getUserInfo();

  @PUT("users/nickname")
  Future<void> putNickName(@Body() Map<String, dynamic> nickNameData);

  @PUT("users/password")
  Future<void> putPassword(@Body() Map<String, dynamic> passwordData);

  @GET("users/debates")
  Future<DebateUsermade> getUserMade();

  @PATCH("users/{id}")
  Future<void> updateUserProfile(
      @Path("id") int id, @Body() Map<String, dynamic> data);

  @GET("users/{id}")
  Future<UserProfile> getUserProfile(@Path("id") int debateId);

  @GET("debates")
  Future<List<Debate>> getDebateList(@Query('state') String state);
  @GET("debates/{id}/participants")
  Future<List<DebateParticipants>> getParicipants(@Path("id") int debateId);
  @GET("debates/{id}")
  Future<DebateInfo> getDebateInfo(@Path("id") int debateId);

  @DELETE("debates/{id}")
  Future deleteDebate(@Path("id") int debateId);
  @DELETE("user-block-list/unblock")
  Future<void> deleteUnblock(@Body() Map<String, dynamic> requestBody);

  @POST("debates")
  @MultiPart()
  Future<DebateCreateInfo> postDebate(@Body() FormData formData);
  @POST("user-block-list/block")
  Future<void> postUserBlock(@Body() Map<String, dynamic> userId);
}
