import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'book.dart';

class BookService extends ChangeNotifier {
  // 책 목록
  List<Book> bookList = [];

  /// 검색어로 책 정보 불러오기
  void getBookList(String q) async {
    bookList.clear();

    Response res = await Dio().get(
        "https://www.googleapis.com/books/v1/volumes?q=cat&startIndex=0&maxResults=40");
    List items = res.data["items"];
    for (Map<String, dynamic> item in items) {
      Map<String, dynamic> volumeInfo = item["volumeInfo"];
      Book book = Book.fromJson(volumeInfo);
      bookList.add(book);
    }

    notifyListeners();
  }
}
