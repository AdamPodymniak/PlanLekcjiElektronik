import 'dart:convert';
import 'package:html/dom.dart' as dom;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LessonData {
  String name;
  String classroom;
  String teacher;

  LessonData({required this.name, required this.classroom, required this.teacher});
}

class AllLessons {
  String? title;
  String? type;
  List<LessonData> lessonData;

  AllLessons({required this.title, required this.lessonData, this.type});

  Map<String, dynamic> toJson() => {
  'title': title,
  'type': type,
  'lessonData': List<dynamic>.from(lessonData.map((e) => {
    'name': e.name,
    'classroom': e.classroom,
    'teacher': e.teacher,
  })),
  };
}

Future<AllLessons?> extractSinglePageData(urlParam) async {

  try {
    final url = Uri.parse("http://www.plan.elektronik.edu.pl/plany/$urlParam.html");
    final response = await http.Client().get(url);

    if(response.statusCode != 404){
      dom.Document html = dom.Document.html(response.body);

      final lessons = html
            .querySelectorAll(".tabela > tbody > tr > td > span > a, .tabela > tbody > tr > td > span > span")
            .map((e)=>e.innerHtml.trim())
            .toList();
      final title = html.querySelector(".tytulnapis")?.innerHtml.trim();

      List<LessonData> lessonData = [];

      for(int i = 0; i<lessons.length; i+=3){
        lessonData.add(LessonData(name: lessons[i], classroom: lessons[i+2], teacher: lessons[i+1]));
      }

      return AllLessons(title: title, lessonData: lessonData);
    }
    return null;
    
  } catch (e) {
    return null;
  }
}

Future<List<AllLessons>> extractAllData() async {

  print("Start fetching...");
  List<AllLessons> allLessons = [];

  //extract classes
  for(int i=1; i<35; i++){
    var lessonData = await extractSinglePageData("o$i");
    lessonData?.type = "class";
    if(lessonData != null) allLessons.add(lessonData as AllLessons);
  }

  //extract teachers
  for(int i=1; i<102; i++){
    var lessonData = await extractSinglePageData("n$i");
    lessonData?.type = "teacher";
    if(lessonData != null) allLessons.add(lessonData as AllLessons);
  }

  //extract classrooms
  for(int i=1; i<65; i++){
    var lessonData = await extractSinglePageData("s$i");
    lessonData?.type = "classroom";
    if(lessonData != null) allLessons.add(lessonData as AllLessons);
  }
  saveData("lessons", allLessons);
  print("Done");
  return allLessons;
}

Future saveData(String key, List<AllLessons> lessons) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString(key, json.encode(lessons));

  return null;
}

Future<List<AllLessons>> retrieveDataFromJSON() async{
  List<AllLessons> retrievedLessons = [];
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final lessons = json.decode(prefs.getString("lessons")!);

  for(var lesson in lessons){
    List<LessonData> lessonData = [];
    for(var ld in lesson['lessonData']){
      lessonData.add(LessonData(name: ld['name'], classroom: ld['classroom'], teacher: ld['teacher']));
    }
    retrievedLessons.add(AllLessons(
      title: lesson['title'],
      type: lesson['type'],
      lessonData: lessonData
    ));
  }
  
  return retrievedLessons;
}