import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Topic{
  final List<quiz>quizzes;
  final String id;
  final String title;
  final String img;

  Topic({
    this.id='',
    this.title='',
    this.img='',
    this.quizzes=const [],
  });
  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable()
class quiz{
  final String description;
  final String id;
  final String topic;
  final List<question> questions;

  quiz({
    this.description='',
    this.id='',
    this.topic='',
    this.questions=const [],
  });
  factory quiz.fromJson(Map<String, dynamic> json) => _$quizFromJson(json);
  Map<String, dynamic> toJson() => _$quizToJson(this);
}

@JsonSerializable()
class report{
    String uid;
    int total;
    Map topics;

    report({this.uid='',this.total=0,this.topics=const {},});
    factory report.fromJson(Map<String, dynamic> json) => _$reportFromJson(json);
    Map<String, dynamic> toJson() => _$reportToJson(this);
}

@JsonSerializable()
class question{
  String questiontext;
  List<option> options;

  question({
    this.questiontext='',
    this.options = const [],
  });
  factory question.fromJson(Map<String, dynamic> json) => _$questionFromJson(json);
  Map<String, dynamic> toJson() => _$questionToJson(this);
}

@JsonSerializable()
class option{
  String value;
  bool correct;
  option({
    this.value='',
    this.correct=false,
  });
  factory option.fromJson(Map<String, dynamic> json) => _$optionFromJson(json);
  Map<String, dynamic> toJson() => _$optionToJson(this);
}