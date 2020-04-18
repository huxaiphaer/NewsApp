import 'package:bloc/bloc.dart';
import 'package:blocapp/bloc/article/article_event.dart';
import 'package:blocapp/bloc/article/article_state.dart';
import 'package:blocapp/data/models/api_result_model.dart';
import 'package:blocapp/data/repository/article_repository.dart';
import 'package:flutter/cupertino.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleRepository repository;

  ArticleBloc({@required this.repository});

  @override
  // TODO: implement initialState
  ArticleState get initialState => null;

  @override
  Stream<ArticleState> mapEventToState(ArticleEvent event) async* {
    // TODO: implement mapEventToState

    if (event is FetchArticlesEvent) {
      yield ArticleLoadingState();
      try {
        List<Articles> articles = await repository.getArticles();
        yield ArticleLoadedState(articles: articles);
      } catch (e) {
        yield ArticleErrorState(message: e.toString());
      }
    }
  }
}
