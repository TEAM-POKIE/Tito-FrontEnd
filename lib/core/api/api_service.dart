import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:tito_app/src/data/models/ai_word.dart';
import 'package:tito_app/src/data/models/debate_crate.dart';
import 'package:tito_app/src/data/models/debate_info.dart';
import 'package:tito_app/src/data/models/ended_chat.dart';
import 'package:tito_app/src/data/models/login_info.dart';
import 'package:tito_app/src/data/models/auth_response.dart';
import 'package:tito_app/src/data/models/debate_usermade.dart';
import 'package:tito_app/src/data/models/search_data.dart';
import 'package:tito_app/src/data/models/user_profile.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://dev.tito.lat/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("auth/sign-up")
  Future<void> signUp(@Body() Map<String, String> signUpData);
  @POST("auth/logout")
  Future<void> postLogOut();

  @POST("auth/sign-in")
  Future<AuthResponse> signIn(@Body() Map<String, String> loginData);

  @GET("users")
  Future<LoginInfo> getUserInfo();

  @PUT("users/nickname")
  Future<void> putNickName(@Body() Map<String, String> nickNameData);

  @PUT("auth/quit")
  Future<void> putQuit();
  @PUT("users/password")
  Future<void> putPassword(@Body() Map<String, String> passwordData);
  @PUT("users/tutorial-completed")
  Future<void> putTutorialCompleted();

  @GET("users/debates")
  Future<DebateUsermade> getUserMade();

  @PUT("users/profile-picture")
  @MultiPart()
  Future<void> putUpdatePicture(@Body() FormData profileFile);

  @GET("users/{id}")
  Future<UserProfile> getUserProfile(@Path("id") int debateId);
  @GET('users/debates')
  Future<String> getUserDebate();
  @GET('word-candidate')
  Future<String> getRandomWord();

  @GET("debates/debate-list")
  Future<String> getDebateList({
    @Query('page') int? page,
    @Query('sortBy') String? sortBy,
    @Query('status') String? status,
    @Query('category') String? category,
  });
  @GET("debates/on-fire-debate")
  Future<String> getDebateBenner();

  @GET("debates/hot-debate")
  Future<String> getDebateHotdebate();

  @GET("debates/hot-debate-participants")
  Future<String> getDebateHotfighter();
  @GET("user-block-list/blocked-users")
  Future<String> getBlockedUser();

  @GET('users/{id}/debates')
  Future<Map<String, String>> getOtherDebate(@Path("id") int debateId);
  @POST('debates/generate-topic')
  Future<String> postGenerateTopic(@Body() Map<String, Object> requestBody);

  @POST('debates/refine-argument')
  Future<String> postRefineArgument(@Body() Map<String, Object> requestBody);

  @GET("debates/{debate_id}/chat")
  Future<List<EndedChatInfo>> getDebateChat(@Path("debate_id") int debateId);

  @POST('search')
  Future<List<SearchData>> postSearchData(
      @Body() Map<String, Object> requestBody);

  @GET("debates/{id}")
  Future<DebateInfo> getDebateInfo(@Path("id") int debateId);

  @POST("oauth2/google")
  Future<AuthResponse> oAuthGoogle(@Body() Map<String, String> loginData);

  @POST("oauth2/kakao")
  Future<AuthResponse> oAuthKakao(@Body() Map<String, String> loginData);

  @POST("oauth2/apple")
  Future<AuthResponse> oAuthApple(@Body() Map<String, String> loginData);

  @DELETE("debates/{id}")
  Future deleteDebate(@Path("id") int debateId);

  @DELETE("user-block-list/unblock")
  Future<void> deleteUnblock(@Body() Map<String, Object> unblockUserId);

  @POST("debates")
  @MultiPart()
  Future<DebateCreateInfo> postDebate(@Body() FormData formData);
  @POST("user-block-list/block")
  Future<void> postUserBlock(@Body() Map<String, String> userId);
}
