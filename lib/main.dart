import 'package:book_store/book.dart';
import 'package:book_store/book_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BookService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  /// 검색어를 가져올 수 있도록 TextField와 연결해 줍니다.
  final TextEditingController searchController = TextEditingController();

  /// 검색 함수
  /// 엔터를 누르거나 돋보기 아리콘을 누를때 호출
  void search(BookService bookService) {
    String keyword = searchController.text;
    if (keyword.isNotEmpty) {
      bookService.getBookList(keyword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookService>(
      builder: (context, bookService, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            centerTitle: false,
            title: Text(
              "Book Store",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            actions: [
              Container(
                alignment: Alignment.bottomCenter,
                padding: const EdgeInsets.only(right: 12),
                child: Text(
                  "total ${bookService.bookList.length}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              )
            ],

            /// AppBar의 Bottom은 항상 PreferredSize 위젯으로 시작해야합니다.
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 72),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "원하는 책을 검색해주세요.",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        search(bookService);
                      },
                      icon: Icon(Icons.search),
                    ),
                  ),
                  onSubmitted: (v) {
                    search(bookService);
                  },
                ),
              ),
            ),
          ),
          body: bookService.bookList.isEmpty
              ? Center(
                  child: Text(
                    "검색어를 입력해 주세요",
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.grey,
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: bookService.bookList.length,
                  itemBuilder: (context, index) {
                    Book book = bookService.bookList[index];
                    return ListTile(
                      leading: Image.network(
                        book.thumbnail,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(book.title),
                      subtitle: Text(book.subtitle),
                      onTap: () {
                        // 클릭시 previewLink 띄우기
                        Uri uri = Uri.parse(book.previewLink);
                        launchUrl(uri);
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
