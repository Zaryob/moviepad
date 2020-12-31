import 'package:flutter/material.dart';
import 'imdb.dart';

class CategoryPage extends StatelessWidget {
  CategoryPage(this.title, this.list);
  List<IMBDListItem> list;
  String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: CategoryBody(list: list),
    );
  }
}

class CategoryBody extends StatelessWidget {
  CategoryBody({this.list});
  List<IMBDListItem> list;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      itemExtent: 106.0,
      children: list,
    );
  }
}