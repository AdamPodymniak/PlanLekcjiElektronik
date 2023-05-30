import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './teacher_list.dart';

class LessonData {
  final String name;
  final String? classroom;
  final String? teacher;
  final String? className;
  final String hour;
  final String day;
  final String number;

  LessonData({
    required this.name,
    this.classroom,
    this.teacher,
    this.className,
    required this.hour,
    required this.day,
    required this.number,
  });
}

class AllLessons {
  String? title;
  String? type;
  List<LessonData> lessonData;

  AllLessons({
    required this.title,
    required this.lessonData,
    this.type,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
        'lessonData': List<dynamic>.from(
          lessonData.map(
            (e) => {
              'name': e.name,
              'classroom': e.classroom,
              'teacher': e.teacher,
              'className': e.className,
              'hour': e.hour,
              'day': e.day,
              'number': e.number,
            },
          ),
        ),
      };
}

Future<AllLessons?> extractSinglePageData(dynamic urlParam, String type) async {
  try {
    List<LessonData> output = [];
    final url = Uri.parse("http://www.plan.elektronik.edu.pl/plany/$urlParam.html");
    final response = await http.Client().get(url);

    if (response.statusCode != 404) {
      List<List<dynamic>> lesson2DList = [];
      dom.Document html = dom.Document.html(utf8.decode(response.bodyBytes));

      var title = html.querySelector(".tytulnapis")?.innerHtml.trim();

      final lessons = html
          .querySelectorAll("body > div > table > tbody > tr > td > table > tbody > tr")
          .toList();

      for (int i = 0; i < lessons.length - 1; i++) {
        if (i == 0) {
          lesson2DList
              .add(lessons[i].querySelectorAll('tr > th').map((e) => e.innerHtml.trim()).toList());
        } else {
          lesson2DList.add([
            lessons[i].querySelector('.nr')?.innerHtml.trim(),
            lessons[i].querySelector('.g')?.innerHtml.trim(),
            ...lessons[i].querySelectorAll('.l')
          ]);
        }
      }
      int n = 0;
      for (var i = 2; i < lesson2DList[n].length; i++) {
        for (var j = 1; j < lesson2DList.length; j++) {
          if (n == lesson2DList[j].length) {
            n = 0;
          } else {
            n++;
          }
          final hour = lesson2DList[j][1];
          final nr = lesson2DList[j][0];
          final day = lesson2DList[0][i];
          if (type == "class") {
            final singleLessonList =
                lesson2DList[j][i].querySelectorAll('.p').map((e) => e.innerHtml.trim()).toList();
            final singleTeacherList =
                lesson2DList[j][i].querySelectorAll('.n').map((e) => e.innerHtml.trim()).toList();
            final singleClassroomList =
                lesson2DList[j][i].querySelectorAll('.s').map((e) => e.innerHtml.trim()).toList();
            if (singleLessonList.isNotEmpty) {
              for (var k = 0; k < singleLessonList.length; k++) {
                for (final element in teacherData) {
                  if (element.simple == singleTeacherList[k]) {
                    singleTeacherList[k] = element.full;
                  }
                }
                LessonData data = LessonData(
                  name: singleLessonList[k],
                  classroom: singleClassroomList[k],
                  teacher: singleTeacherList[k],
                  hour: hour,
                  day: day,
                  number: nr,
                );
                output.add(data);
              }
            }
          }
          if (type == "teacher") {
            final singleLessonList =
                lesson2DList[j][i].querySelectorAll('.p').map((e) => e.innerHtml.trim()).toList();
            final singleClassList =
                lesson2DList[j][i].querySelectorAll('.o').map((e) => e.innerHtml.trim()).toList();
            final singleClassroomList =
                lesson2DList[j][i].querySelectorAll('.s').map((e) => e.innerHtml.trim()).toList();
            if (singleLessonList.isNotEmpty) {
              for (var k = 0; k < singleLessonList.length; k++) {
                for (final element in teacherData) {
                  if (element.simple == title) title = element.full;
                }

                LessonData data = LessonData(
                  name: singleLessonList[k],
                  classroom: singleClassroomList[k],
                  className: singleClassList[k],
                  hour: hour,
                  day: day,
                  number: nr,
                );
                output.add(data);
              }
            }
          }
          if (type == "classroom") {
            final singleLessonList =
                lesson2DList[j][i].querySelectorAll('.p').map((e) => e.innerHtml.trim()).toList();
            final singleClassList =
                lesson2DList[j][i].querySelectorAll('.o').map((e) => e.innerHtml.trim()).toList();
            final singleTeacherList =
                lesson2DList[j][i].querySelectorAll('.n').map((e) => e.innerHtml.trim()).toList();
            if (singleLessonList.isNotEmpty) {
              for (var k = 0; k < singleLessonList.length; k++) {
                for (final element in teacherData) {
                  if (element.simple == singleTeacherList[k]) {
                    singleTeacherList[k] = element.full;
                  }
                }
                LessonData data = LessonData(
                  name: singleLessonList[k],
                  teacher: singleTeacherList[k],
                  className: singleClassList[k],
                  hour: hour,
                  day: day,
                  number: nr,
                );
                output.add(data);
              }
            }
          }
        }
      }

      return AllLessons(title: title, lessonData: output);
    }
    return null;
  } catch (e) {
    return null;
  }
}

Future<List<AllLessons>> extractAllData() async {
  debugPrint("Start fetching...");
  List<AllLessons> allLessons = [];

  //extract classes
  for (int i = 1; i < 35; i++) {
    var lessonData = await extractSinglePageData("o$i", "class");
    lessonData?.type = "class";
    if (lessonData != null) allLessons.add(lessonData);
  }

  //extract teachers
  for (int i = 1; i < 102; i++) {
    var lessonData = await extractSinglePageData("n$i", "teacher");
    lessonData?.type = "teacher";
    if (lessonData != null) allLessons.add(lessonData);
  }

  //extract classrooms
  for (int i = 1; i < 65; i++) {
    var lessonData = await extractSinglePageData("s$i", "classroom");
    lessonData?.type = "classroom";
    if (lessonData != null) allLessons.add(lessonData);
  }
  saveData("lessons", allLessons);
  debugPrint("Done");
  return allLessons;
}

Future saveData(String key, List<AllLessons> lessons) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString(key, json.encode(lessons));
}

Future<List<AllLessons>?> retrieveDataFromJSON() async {
  List<AllLessons> retrievedLessons = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final retrievedRawData = prefs.getString("lessons");
  if (retrievedRawData != null) {
    final lessons = json.decode(retrievedRawData);
    for (var lesson in lessons) {
      List<LessonData> lessonData = [];
      for (var ld in lesson['lessonData']) {
        lessonData.add(
          LessonData(
            name: ld['name'],
            classroom: ld['classroom'],
            teacher: ld['teacher'],
            className: ld['className'],
            hour: ld['hour'],
            day: ld['day'],
            number: ld['number'],
          ),
        );
      }
      retrievedLessons.add(
        AllLessons(
          title: lesson['title'],
          type: lesson['type'],
          lessonData: lessonData,
        ),
      );
    }
    return retrievedLessons;
  }
  return null;
}
