import 'package:blocapp/data/models/api_result_model.dart';
import 'package:blocapp/res/strings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ArticleRepository{

  Future<List<Articles>> getArticles();
}

class ArticleRepositoryImpl implements ArticleRepository{
  @override
  Future<List<Articles>> getArticles() async {
    // TODO: implement getArticles
    var response = await  http.get(AppStrings.cricArticleURL);

    if (response.statusCode == 200){
      
      var data = json.decode(response.body);

      List<Articles> articles = ApiResultModel.fromJson(data).articles;

      return articles;
    } else{

      throw Exception();
    }
  }

}