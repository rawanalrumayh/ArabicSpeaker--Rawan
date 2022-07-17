import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController Input = TextEditingController();
  bool autoComp = false;
  String text = '';
  int _counter = 0;
  List<String> priWord = [];
  String path = "";
  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    path = await rootBundle.loadString("assets/gramData.txt");
    List<String> result = path.split('\n');
    for (int i = 0; i < result.length; i++) {
      result[i] = result[i].replaceAll("\"", "");
    }

    for (String r in result) {
      if (_counter < 9 && !priWord.contains(r)) {
        priWord.add(r);
        _counter++;
        setState(() {});
      }
    }
  }

  auto_complete(String text) async {
    int counter = 0;
    print("auto complete");
    path = await rootBundle.loadString("assets/gramData.txt");
    List<String> result = path.split('\n');
    for (int i = 0; i < result.length; i++) {
      result[i] = result[i].replaceAll("\"", "");
    }

    for (String r in result) {
      if (text.isNotEmpty && r.length >= text.length && counter < 9) {
        if ((r.substring(0, text.length)).compareTo(text) == 0) {
          priWord.add(r);
          counter++;
          print('found');
          setState(() {});
        }
      }
    }
  }

  one_word(int counter) async {
    path = await rootBundle.loadString("assets/gramData.txt");
    List<String> result = path.split('\n');
    for (int i = 0; i < result.length; i++) {
      result[i] = result[i].replaceAll("\"", "");
    }
    for (String r in result) {
      if (counter < 9 && !priWord.contains(r)) {
        priWord.add(r);
        counter++;
        setState(() {});
      }
    }
  }

  second_word(String text, int counter, bool back) async {
    path = await rootBundle.loadString("assets/bigramData.txt");
    List<String> result = path.split('\n');

    for (int i = 0; i < result.length; i++) {
      result[i] = result[i].replaceAll("\"", "");
    }

    for (String r in result) {
      if (counter < 9) {
        List<String> s = r.split(" ");

        if (s[0].compareTo(text) == 0 && !priWord.contains(s[1])) {
          print(s[1]);
          counter++;
          priWord.add(s[1]);
          setState(() {});
        }
      }
    }
    if (counter < 9) {
      if (back) {
        return counter;
      } else {
        one_word(counter);
      }
    }
  }

  third_word(List text, int counter, bool back) async {
    path = await rootBundle.loadString("assets/trigramData.txt");
    List<String> result = path.split('\n');

    for (int i = 0; i < result.length; i++) {
      result[i] = result[i].replaceAll("\"", "");
    }

    for (String r in result) {
      if (counter < 9) {
        List s = r.split(" ");
        if (s[0].compareTo(text[0]) == 0 &&
            s[1].compareTo(text[1]) == 0 &&
            !priWord.contains(s[2])) {
          priWord.add(s[2]);
          print(s[2]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      if (counter < 9) {
        List s = r.split(" ");
        if (s[1].compareTo(text[1]) == 0 && !priWord.contains(s[2])) {
          priWord.add(s[2]);
          print(s[2]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      if (counter < 9) {
        List s = r.split(" ");
        if (s[0].compareTo(text[0]) == 0 && !priWord.contains(s[2])) {
          //print("3");
          priWord.add(s[2]);
          print(s[2]);
          counter++;
          setState(() {});
        }
      }
    }
    if (counter < 9) {
      print("from second word");

      if (back) {
        return counter;
      } else {
        counter = await second_word(text[1], counter, true);
        print('we are back');
        if (counter < 9) {
          second_word(text[0], counter, false);
        }
      }
    }
    return counter;
  }

  fourth_word(List text, int counter, bool back) async {
    path = await rootBundle.loadString("assets/4gram.txt");
    List<String> result = path.split('\n');

    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[0].compareTo(text[0]) == 0 &&
            s[1].compareTo(text[1]) == 0 &&
            s[2].compareTo(text[2]) == 0 &&
            !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[1].compareTo(text[1]) == 0 &&
            s[2].compareTo(text[2]) == 0 &&
            !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[0].compareTo(text[0]) == 0 &&
            s[1].compareTo(text[1]) == 0 &&
            !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[0].compareTo(text[0]) == 0 &&
            s[2].compareTo(text[2]) == 0 &&
            !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[2].compareTo(text[2]) == 0 && !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[1].compareTo(text[1]) == 0 && !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    for (String r in result) {
      List s = r.split(" ");
      if (counter < 9) {
        if (s[0].compareTo(text[0]) == 0 && !priWord.contains(s[3])) {
          priWord.add(s[3]);
          print(s[3]);
          counter++;
          setState(() {});
        }
      }
    }
    if (counter < 9) {
      if (back) {
        return counter;
      }
      print("from third word");
      List<String> remaining = [text[1], text[2]];
      counter = await third_word(remaining, counter, true);

      if (counter < 9) {
        remaining = [text[0], text[1]];
        counter = await third_word(remaining, counter, true);
      }
      if (counter < 9) {
        counter = await second_word(text[2], counter, true);
      }
      if (counter < 9) {
        counter = await second_word(text[1], counter, true);
      }
      if (counter < 9) {
        second_word(text[0], counter, false);
      }
    }
    return counter;
  }

  fifth_word(List text, int counter, bool back) async {
    List<String> list = [text[1], text[2], text[3]];
    if (counter < 9) {
      counter = await fourth_word(list, counter, true);
    }
    if (counter < 9) {
      list = [text[0], text[1], text[2]];
      counter = await fourth_word(list, counter, true);
    }

    if (counter < 9) {
      if (back) {
        return counter;
      } else {
        list = [text[2], text[3]];
        counter = await third_word(list, counter, true);
        if (counter < 9) {
          list = [text[1], text[2]];
          counter = await third_word(list, counter, true);
        }
        if (counter < 9) {
          list = [text[0], text[1]];
          counter = await third_word(list, counter, true);
        }
        if (counter < 9) {
          counter = await second_word(text[3], counter, true);
        }
        if (counter < 9) {
          counter = await second_word(text[2], counter, true);
        }
        if (counter < 9) {
          counter = await second_word(text[1], counter, true);
        }
        if (counter < 9) {
          second_word(text[0], counter, false);
        }
      }
    }
    return counter;
  }

  more_words(List text, int counter) async {
    List<String> list = [];
    for (int i = text.length - 1; i > 2; i--) {
      list = [text[i - 3], text[i - 2], text[i - 1], text[i]];
      print('${text[i - 3]}, ${text[i - 2]}, ${text[i - 1]}, ${text[i]}');
      counter = await fifth_word(list, counter, true);
    }
    if (counter < 9) {
      for (int i = text.length - 1; i > 1; i--) {
        list = [text[i - 2], text[i - 1], text[i]];
        print('${text[i - 2]}, ${text[i - 1]}, ${text[i]} ');
        counter = await fourth_word(list, counter, true);
      }
    }

    if (counter < 9) {
      for (int i = text.length - 1; i > 0; i--) {
        list = [text[i - 1], text[i]];
        print('${text[i - 1]}, ${text[i]} ');
        counter = await third_word(list, counter, true);
      }
    }

    if (counter < 9) {
      for (int i = text.length - 1; i > -1; i--) {
        print('${text[i]} ');
        counter = await second_word(text[i], counter, true);
      }
    }
    if (counter < 9) {
      one_word(counter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                textDirection: TextDirection.rtl,
                decoration: InputDecoration(hintText: 'Enter text'),
                controller: Input,
                onChanged: (text) {
                  List<String> word = text.trim().split(" ");
                  if (!text.endsWith(" ")) {
                    priWord.clear();
                    if (text.contains(" ")) {
                      auto_complete(word[word.length - 1]);
                      autoComp = true;
                    } else {
                      auto_complete(text);
                      autoComp = true;
                    }
                  } else {
                    if (word.length == 1) {
                      print('one word');
                      priWord = [];
                      second_word(word[0], 0, false);
                    } else if (word.length == 2) {
                      print('two words');
                      priWord = [];
                      third_word(word, 0, false);
                    } else if (word.length == 3) {
                      print('three words');
                      priWord = [];
                      fourth_word(word, 0, false);
                    } else if (word.length == 4) {
                      print('four words');
                      priWord = [];
                      fifth_word(word, 0, false);
                    } else if (word.length > 4) {
                      print('more words');
                      priWord = [];
                      more_words(word, 0);
                    }
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.builder(
                    itemCount: priWord.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 30,
                            mainAxisSpacing: 20,
                            childAspectRatio: 2 / 1),
                    itemBuilder: ((context, index) {
                      return InkWell(
                        onTap: () {
                          if (autoComp) {
                            Input.text = "$text ${priWord[index]}";
                            text = Input.text;
                            autoComp = false;
                          } else {
                            Input.text += "${priWord[index]}";
                            text = Input.text;
                          }
                          Input.selection = TextSelection.fromPosition(
                              TextPosition(offset: Input.text.length));
                        },
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Color(20))),
                            child: Center(child: Text(priWord[index]))),
                      );
                    })),
              )
            ],
          ),
        ),
      ),
    );
  }
}
