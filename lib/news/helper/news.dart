import 'package:flutter_covid_dashboard_ui/news/models/article.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_covid_dashboard_ui/news/secret.dart';

class News {

  // https://newsapi.org/v2/everything?q=coronavirus&apiKey=80d4bccb24c145318b686598a8540dac // Corona general
  // https://newsapi.org/v2/top-headlines?q=coronavirus&country=us&category=business&apiKey=80d4bccb24c145318b686598a8540dac // corona about business
  // https://newsapi.org/v2/top-headlines?q=coronavirus&country=us&category=sports&apiKey=80d4bccb24c145318b686598a8540dac // corona about sports
  // 

  List<Article> news  = [];

  Future<void> getNews() async{

    String url = "https://newsapi.org/v2/everything?q=coronavirus&apiKey=${apiKey}";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){

        if(element['urlToImage'] != null && element['description'] != null){
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }

      });
    }


  }


}


class NewsForCategorie {

  List<Article> news  = [];

  Future<void> getNewsForCategory(String category) async{

    String url = "http://newsapi.org/v2/top-headlines?q=coronavirus&country=in&category=$category&apiKey=${apiKey}";

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == "ok"){
      jsonData["articles"].forEach((element){

        if(element['urlToImage'] != null && element['description'] != null){
          Article article = Article(
            title: element['title'],
            author: element['author'],
            description: element['description'],
            urlToImage: element['urlToImage'],
            publshedAt: DateTime.parse(element['publishedAt']),
            content: element["content"],
            articleUrl: element["url"],
          );
          news.add(article);
        }

      });
    }


  }


}
