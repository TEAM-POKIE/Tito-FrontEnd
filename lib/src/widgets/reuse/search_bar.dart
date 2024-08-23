// search_widgets.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
            height: 50.h,
            child: TextField(
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
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

  const SearchResultList({
    Key? key,
    required this.searchResults,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: searchResults.isEmpty
          ? Center(child: Text("검색 결과가 없습니다."))
          : ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final result = searchResults[index];
                return Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: Image.network(
                            result.searchedDebateImageUrl,
                            width: 80.w,
                            height: 80.h,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                result.searchedDebateTitle,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '상태: ${result.searchedDebateStatus ?? 'N/A'}',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                '참여자 수: ${result.searchedDebateRealtimeParticipants}명',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '승률: ${result.searchedDebateOwnerWinningRate}%',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
