import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter_news/model/fetch_exception.dart';
import 'package:flutter_news/model/hn_stories.dart';

const JsonCodec jsonCodec = const JsonCodec();

class LiveHnStoryRepository extends HnStoriesRepository {
  static const _baseUrl = 'https://hacker-news.firebaseio.com/v0';
  static const _topStoriesUrl = '$_baseUrl/topstories.json';
  static const _newStoriesUrl = '$_baseUrl/newstories.json';
  static const _bestStoriesUrl = '$_baseUrl/beststories.json';
  static const _showStoriesUrl = '$_baseUrl/showstories.json';
  static const _jobStoriesUrl = '$_baseUrl/jobstories.json';
  static const _askStoriesUrl = '$_baseUrl/askstories.json';

  @override
  Future<HnStories> fetch(StoryType storyType) async {
    String _fetchUrl;

    switch (storyType) {
      case (StoryType.newest):
        _fetchUrl = _newStoriesUrl;
        break;
      case (StoryType.best):
        _fetchUrl = _bestStoriesUrl;
        break;
      case (StoryType.show):
        _fetchUrl = _showStoriesUrl;
        break;
      case (StoryType.job):
        _fetchUrl = _jobStoriesUrl;
        break;
      case (StoryType.ask):
        _fetchUrl = _askStoriesUrl;
        break;
      case (StoryType.top):
      default:
        _fetchUrl = _topStoriesUrl;
        break;
    }

    final response = await http.get(_fetchUrl);
    final statusCode = response.statusCode;

    if (statusCode < 200 || statusCode >= 300 || response.body == null) {
      throw new FetchDataException(
          "Error while getting stories [StatusCode:$statusCode]");
    }

    final storiesList = List<int>.from(json.decode(response.body));
    return new HnStories.fromList(storyType, storiesList);
  }
}
