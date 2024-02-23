
import 'package:flutter/material.dart';
import 'package:news_app/data/article_data.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/screens/explore_page.dart';
import 'package:news_app/screens/feed_page.dart';
import 'package:news_app/screens/profile_page.dart';
import 'package:news_app/screens/saved_page.dart';
import 'package:news_app/widgets/article_card.dart';

class HomeData{

  HomeData(){
    loadOriginalArticleList();
  }

  int currentPageIndex = 1;
  int currentFieldIndex = 0;

  List<Widget> pageList = [
    const FeedPage(),
    const ExplorePage(),
    const SavedPage(),
    const ProfilePage()
  ];
  List<String> fieldList = [
    "technology",
    "ai",
    "cloud",
    "cybersecurity",
    "iot",
  ];

  List<Article> articleList = [];

  void loadOriginalArticleList(){
    articleList = List.generate(blogDataset.length, (index) {
      return Article.fromJson(blogDataset[index]);
    });
  }

  List<ArticleCard> getFieldArticleList(){
    String field = fieldList[currentFieldIndex];
    List<ArticleCard> generatedList = [];

    for (var element in articleList) {
      if (element.field.toLowerCase() == field){
        generatedList.add(ArticleCard(article: element));
      }
    }
    return generatedList;
  }

  void saveArticle(Article article){
    articleList.firstWhere((element) => element.userID == article.userID).isSaved = !article.isSaved;
  }
}