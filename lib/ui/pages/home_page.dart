import 'package:blocapp/bloc/article/article_bloc.dart';
import 'package:blocapp/bloc/article/article_event.dart';
import 'package:blocapp/bloc/article/article_state.dart';
import 'package:blocapp/data/models/api_result_model.dart';
import 'package:blocapp/ui/pages/about_page.dart';
import 'package:blocapp/ui/pages/article_detail_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  ArticleBloc articleBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    articleBloc = BlocProvider.of<ArticleBloc>(context);
    articleBloc.add(FetchArticlesEvent());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Cricket"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              navigateToAoutPage(context);
            },
          )
        ],
      ),
      body: Container(
        child: BlocListener<ArticleBloc, ArticleState>(
          listener: (context, state) {
            if (state is ArticleErrorState) {
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text(state.message),
                  )
              );
            }
          },
          child: BlocBuilder<ArticleBloc, ArticleState>(
            // ignore: missing_return
            builder: (context, state) {
              if (state is ArticleInitialState) {
                return buildLoading();
              } else if (state is ArticleLoadingState) {
                return buildLoading();
              } else if (state is ArticleLoadedState) {
                return buildArticleList(state.articles);
              } else if (state is ArticleErrorState) {
                return buildErrorUi(state.message);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  Widget buildArticleList(List<Articles> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (ctx, pos) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            child: ListTile(
              leading: ClipOval(
                child: Hero(
                  tag: articles[pos].urlToImage,
                  child: Image.network(
                    articles[pos].urlToImage,
                    fit: BoxFit.cover,
                    height: 70.0,
                    width: 70.0,
                  ),
                ),
              ),
              title: Text(articles[pos].title),
              subtitle: Text(articles[pos].publishedAt),
            ),
            onTap: () {
              navigateToArticleDetailPage(context, articles[pos]);
            },
          ),
        );
      },
    );
  }
}

void navigateToArticleDetailPage(BuildContext context, Articles article) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return ArticleDetailPage(
      article: article,
    );
  }));
}

void navigateToAoutPage(BuildContext context) {
  Navigator.push(context, MaterialPageRoute(builder: (context) {
    return AboutPage();
  }));
}
