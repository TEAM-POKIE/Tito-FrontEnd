import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tito_app/core/api/api_service.dart';
import 'package:tito_app/core/api/dio_client.dart';
import 'package:tito_app/core/constants/style.dart';
import 'package:tito_app/src/data/models/search_data.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(List<SearchData>) onSearchResults;

  const CustomSearchBar({super.key, required this.onSearchResults});

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  List<SearchData> searchResults = [];

  Future<void> searchList(String query) async {
    try {
      final response = await ApiService(DioClient.dio).postSearchData({
        "query": query,
        "page": 0,
      });

      setState(() {
        searchResults = response;
        widget.onSearchResults(searchResults); // 검색 결과를 전달
      });
    } catch (e) {
      print("Error fetching search results: $e");
      setState(() {
        searchResults = [];
        widget.onSearchResults(searchResults); // 빈 결과 전달
      });
    }
  }

  String _getStatusText(String debateStatus) {
    switch (debateStatus) {
      case 'CREATED':
        return '상대 찾는 중';
      case 'IN_PROGRESS':
        return '토론 진행중';
      case 'VOTING':
        return '투표 중';
      case 'ENDED':
        return '투표 종료';
      default:
        return '상태 없음';
    }
  }

  String _getSubText(SearchData debate) {
    switch (debate.searchedDebateStatus) {
      case 'CREATED':
        return '\'종만\'님이 대기 중';
      case 'IN_PROGRESS':
        return '\'조조\'님과 \'뚜미둡\'님이 토론 중';
      case 'VOTING':
        return '나도 투표 참여하러 가기';
      case 'ENDED':
        return '토론 결과 확인하러가기';
      default:
        return '';
    }
  }

  Color _getSubTextColor(SearchData debate) {
    switch (debate.searchedDebateStatus) {
      case 'CREATED':
        return ColorSystem.white;
      case 'IN_PROGRESS':
        return ColorSystem.purple;
      case 'VOTING':
        return ColorSystem.grey1;
      case 'ENDED':
        return ColorSystem.grey1;
      default:
        return ColorSystem.purple;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'CREATED':
        return ColorSystem.lightPurple2; // CREATED 상태의 배경색
      case 'IN_PROGRESS':
        return ColorSystem.lightPurple; // IN_PROGRESS 상태의 배경색
      case 'VOTING':
        return ColorSystem.lightYellow; // VOTING 상태의 배경색
      case 'ENDED':
        return ColorSystem.turquoise; // ENDED 상태의 배경색
      default:
        return ColorSystem.lightPurple; // 기본 배경색
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 310.w,
              child: TextField(
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.search,
                autocorrect: false,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: SvgPicture.asset(
                      'assets/icons/search_size_four.svg',
                    ),
                  ),
                  filled: true,
                  fillColor: ColorSystem.ligthGrey,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.r),
                    borderSide: BorderSide.none,
                  ),
                  hintText: '카테고리, 제목, 내용',
                  hintStyle: FontSystem.KR16M.copyWith(color: ColorSystem.grey),
                ),
                style: const TextStyle(
                  color: ColorSystem.black,
                ),
                onSubmitted: (value) {
                  searchList(value);
                },
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}

class SearchResultList extends StatelessWidget {
  final List<SearchData> searchResults;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  SearchResultList({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

  void _onRefresh() {
    // Implement refresh logic here
    _refreshController.refreshCompleted();
  }

  void _onLoading() {
    // Implement load more logic here
    _refreshController.loadComplete();
  }

  Color _getSubTextColor(SearchData debate) {
    switch (debate.searchedDebateStatus) {
      case 'CREATED':
        return ColorSystem.white;
      case 'IN_PROGRESS':
        return ColorSystem.purple;
      case 'VOTING':
        return ColorSystem.grey1;
      case 'ENDED':
        return ColorSystem.grey1;
      default:
        return ColorSystem.purple;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'CREATED':
        return ColorSystem.lightPurple2; // CREATED 상태의 배경색
      case 'IN_PROGRESS':
        return ColorSystem.lightPurple; // IN_PROGRESS 상태의 배경색
      case 'VOTING':
        return ColorSystem.lightYellow; // VOTING 상태의 배경색
      case 'ENDED':
        return ColorSystem.turquoise; // ENDED 상태의 배경색
      default:
        return ColorSystem.lightPurple; // 기본 배경색
    }
  }

  String _getStatusText(String debateStatus) {
    switch (debateStatus) {
      case 'CREATED':
        return '상대 찾는 중';
      case 'IN_PROGRESS':
        return '토론 진행중';
      case 'VOTING':
        return '투표 중';
      case 'ENDED':
        return '투표 종료';
      default:
        return '상태 없음';
    }
  }

  String _getSubText(SearchData debate) {
    switch (debate.searchedDebateStatus) {
      case 'CREATED':
        return '${debate.searchedDebateOwnerNickname}님이 대기 중';
      case 'IN_PROGRESS':
        return '${debate.searchedDebateOwnerNickname}님과 ${debate.searchedDebateJoinerNickname}님이 토론 중';
      case 'VOTING':
        return '나도 투표 참여하러 가기';
      case 'ENDED':
        return '토론 결과 확인하러가기';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: Padding(
        padding: EdgeInsets.only(right: 0.0.w),
        child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final result = searchResults[index];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 5.w),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorSystem.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: GestureDetector(
                  onTap: () {
                    // Implement onTap logic here
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x669795A3),
                          spreadRadius: 0,
                          blurRadius: 4,
                        )
                      ],
                      color: ColorSystem.white,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(
                                      result.searchedDebateStatus),
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  _getStatusText(
                                      result.searchedDebateStatus ?? 'UNKNOWN'),
                                  style: FontSystem.KR14SB.copyWith(
                                    color: _getSubTextColor(result),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Text(
                                result.searchedDebateTitle ?? 'No title',
                                style: FontSystem.KR18M.copyWith(height: 1),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _getSubText(result),
                                style: FontSystem.KR16M
                                    .copyWith(color: ColorSystem.purple),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.w),
                        result.searchedDebateImageUrl == ''
                            ? SvgPicture.asset(
                                'assets/icons/list_real_null.svg',
                                width: 70.w,
                                fit: BoxFit.contain,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.network(
                                  result.searchedDebateImageUrl ?? '',
                                  width: 70.w,
                                  height: 70.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
