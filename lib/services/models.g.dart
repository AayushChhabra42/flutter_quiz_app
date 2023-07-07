// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Topic _$TopicFromJson(Map<String, dynamic> json) => Topic(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      quizzes: (json['quizzes'] as List<dynamic>?)
              ?.map((e) => quiz.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TopicToJson(Topic instance) => <String, dynamic>{
      'quizzes': instance.quizzes,
      'id': instance.id,
      'title': instance.title,
    };

quiz _$quizFromJson(Map<String, dynamic> json) => quiz(
      description: json['description'] as String? ?? '',
      id: json['id'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((e) => question.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$quizToJson(quiz instance) => <String, dynamic>{
      'description': instance.description,
      'id': instance.id,
      'topic': instance.topic,
      'questions': instance.questions,
    };

report _$reportFromJson(Map<String, dynamic> json) => report(
      uid: json['uid'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      topics: json['topics'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$reportToJson(report instance) => <String, dynamic>{
      'uid': instance.uid,
      'total': instance.total,
      'topics': instance.topics,
    };

question _$questionFromJson(Map<String, dynamic> json) => question(
      questiontext: json['questiontext'] as String? ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => option.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$questionToJson(question instance) => <String, dynamic>{
      'questiontext': instance.questiontext,
      'options': instance.options,
    };

option _$optionFromJson(Map<String, dynamic> json) => option(
      value: json['value'] as String? ?? '',
      correct: json['correct'] as bool? ?? false,
    );

Map<String, dynamic> _$optionToJson(option instance) => <String, dynamic>{
      'value': instance.value,
      'correct': instance.correct,
    };
