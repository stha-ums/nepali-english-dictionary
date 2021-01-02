import 'package:dictionary/models/words.dart';
import 'package:dictionary/provider/dictionaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'models/definitions.dart';
import 'models/examples.dart';

class WorldDetails extends StatefulWidget {
  final Word wordModel;
  final List<Definition> wordDefinition;
  final List<Example> example;

  const WorldDetails(
      {Key key,
      @required this.wordModel,
      @required this.wordDefinition,
      @required this.example})
      : super(key: key);

  @override
  _DictionaryAppState createState() => _DictionaryAppState();
}

class _DictionaryAppState extends State<WorldDetails> {
  _DictionaryAppState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new DictionaryProvider(selectLanguage: Dictionary.Nepali),
      builder: (context, child) {
        return Scaffold(
            appBar: AppBar(
              title:
                  Consumer<DictionaryProvider>(builder: (context, data, child) {
                return Text(data.selectedDictionary == Dictionary.Nepali
                    ? "नेपाली शब्दकोष"
                    : "English Dictionary");
              }),
              bottom: PreferredSize(
                preferredSize: Size(double.infinity, 40),
                child: Container(
                  height: 40,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Consumer<DictionaryProvider>(
                      builder: (context, data, child) {
                    return GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: TextField(
                          enabled: false,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            hintText:
                                data.selectedDictionary == Dictionary.Nepali
                                    ? "शब्द खोज्नुहोस"
                                    : "Search words",
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            disabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(style: BorderStyle.none)),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).brightness ==
                                      Brightness.light
                                  ? Colors.black54
                                  : Colors.white70,
                              size: 20,
                            ),
                            suffixIcon: InkWell(
                              child: Icon(
                                Icons.clear,
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? Colors.black54
                                    : Colors.white70,
                                size: 20,
                              ),
                            ),
                          ),
                        ));
                  }),
                ),
              ),
            ),
            body: DetailWordCard(
              wordModel: widget.wordModel,
              wordDefinition: widget.wordDefinition,
              example: widget.example,
            ));
      },
    );
  }
}

class DetailWordCard extends StatelessWidget {
  final Word wordModel;
  final List<Definition> wordDefinition;
  final List<Example> example;
  final FlutterTts flutterTts = FlutterTts();

  DetailWordCard(
      {Key key,
      @required this.wordModel,
      @required this.wordDefinition,
      @required this.example})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Row(
          children: [
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wordModel.value,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).accentColor),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,

                                child: InkWell(
                                    onTap: () async {
                                      await flutterTts.setLanguage("en");
                                      await flutterTts.speak(wordModel.value);
                                    },
                                    child: Icon(Icons.volume_up)),
                                radius: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                backgroundColor: Theme.of(context).accentColor,

                                child: InkWell(
                                    onTap: () {
                                      String definition = '';
                                      wordDefinition.forEach((element) {
                                        definition =
                                            definition + element.value + '\n';
                                      });

                                      Share.share(
                                          "${wordModel.value}:  \n$definition ",
                                          subject: "Check Meaning");
                                    },
                                    child: Icon(Icons.share)),
                                radius: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        "/" + wordModel.partOfSpeech + "/",
                        style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).accentColor),
                      ),
                      Text(""),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: wordDefinition != null
                            ? wordDefinition
                                .asMap()
                                .entries
                                .map(
                                  (def) => Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (def.key + 1).toString() +
                                            '. ' +
                                            def.value.value,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: example != null
                                              ? example
                                                  .asMap()
                                                  .entries
                                                  .map(
                                                    (exmp) => Column(
                                                      children: [
                                                        Text(
                                                          '· ' +
                                                              exmp.value.value,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                  .toList()
                                              : [Container()],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList()
                            : [Container()],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
