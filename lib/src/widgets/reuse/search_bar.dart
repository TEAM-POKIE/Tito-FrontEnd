// search_widgets.dart

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
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

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: searchResults.isEmpty
          ? Center(child: Text("검색 결과가 없습니다."))
          : SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: Padding(
                padding: EdgeInsets.only(right: 0.0.w),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 8.0,
                  radius: Radius.circular(20.r),
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      final result = searchResults[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 5.w),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x669795A3),
                                spreadRadius: 0,
                                blurRadius: 4,
                              )
                            ],
                            color: ColorSystem.white,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: ListTile(
                            onTap: () {
                              // _enterChat(result.id, result.debateStatus);
                              // Implement onTap logic here
                            },
                            title: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0.h, vertical: 2.h),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 8.h),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 6.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: result.searchedDebateStatus ==
                                                  '실시간'
                                              ? ColorSystem.lightPurple
                                              : ColorSystem.lightPurple,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Text(
                                            result.searchedDebateStatus ??
                                                '상태 없음',
                                            style: FontSystem.KR14SB.copyWith(
                                              color:
                                                  result.searchedDebateStatus ==
                                                          '실시간'
                                                      ? ColorSystem.purple
                                                      : ColorSystem.purple,
                                            )),
                                      ),
                                      SizedBox(height: 10.h),
                                      Text(
                                        result.searchedDebateTitle ??
                                            'No title',
                                        style: FontSystem.KR18M
                                            .copyWith(height: 1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        '승률 ${result.searchedDebateOwnerWinningRate}% 토론러 대기중',
                                        style: FontSystem.KR16M.copyWith(
                                            color: ColorSystem.purple),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                            trailing: Padding(
                              padding: EdgeInsets.only(bottom: 20.w),
                              child: result.searchedDebateImageUrl == ''
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
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }
}
