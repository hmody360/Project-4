import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/utils/colors.dart';
import 'package:news_app/utils/setup.dart';
import 'package:news_app/widgets/article_card.dart';

part 'article_event.dart';
part 'article_state.dart';

// This is the bloc that is used for article functionalties
class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  ArticleBloc() : super(ArticleInitial()) {
    on<ArticleEvent>((event, emit) {});

    on<ChangeFieldEvent>(changeField);
    on<SaveArticleEvent>(saveArticle);
    on<EditArticleEvent>(editArticle);
    on<SearchEvent>(searchArticles);
  }

  // This method changes the field within the FeedPage, enabling the user to see articles based on a chosen category
  FutureOr<void> changeField(
      ChangeFieldEvent event, Emitter<ArticleState> emit) {
    getIt.currentFieldIndex = event.fieldIndex;
    List<ArticleCard> generatedList = getIt.getFieldArticleList();
    if (generatedList.isNotEmpty) {
      emit(ChangedFieldState(generatedList: generatedList));
    } else {
      emit(ChangedFieldEmptyState());
    }
  }

  // This method saves and unsaves an article based on its current status
  FutureOr<void> saveArticle(
      SaveArticleEvent event, Emitter<ArticleState> emit) {
    getIt.saveArticle(event.article);
    emit(SaveArticleState(
        (event.article.isSaved)
            ? "This article has been saved."
            : "This article has been removed from saved list.",
        (event.article.isSaved) ? limeGreenColor : selectedTabColor));
  }

  // This method edits an article and it also checks if the fields are empty before actually saving the changs.
  FutureOr<void> editArticle(
      EditArticleEvent event, Emitter<ArticleState> emit) {
    bool isEdited = getIt.editArticle(
        event.article, event.title, event.summary, event.content);
    (isEdited)
        ? emit(EditedArticleState("Article has been successfuly edited."))
        : emit(EditedArticleErrorState("You can't leave empty fields!"));
  }

  // This method enables the search functionalties based on a search criteria.
  FutureOr<void> searchArticles(SearchEvent event, Emitter<ArticleState> emit) {
    List<ArticleCard> generatedList =
        getIt.getSearchArticleList(event.searchCriteria);
    if (generatedList.isNotEmpty) {
      emit(SearchState(generatedList: generatedList));
    } else {
      emit(SearchEmptyState(
          message: "No Search Results Found for ${event.searchCriteria}"));
    }
  }
}
