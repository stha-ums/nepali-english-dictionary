import 'package:dictionary/provider/dictionaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'models/english_words_dictionary.dart';

class EnglishWordDetails extends StatefulWidget {
  final EnglishWord wordModel;

  const EnglishWordDetails({
    Key key,
    @required this.wordModel,
  }) : super(key: key);

  @override
  _DictionaryAppState createState() => _DictionaryAppState();
}

class _DictionaryAppState extends State<EnglishWordDetails> {
  _DictionaryAppState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => new DictionaryProvider(selectLanguage: Dictionary.English),
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
              englishWord: widget.wordModel,
            ));
      },
    );
  }
}

class DetailWordCard extends StatelessWidget {
  final EnglishWord englishWord;
  final FlutterTts flutterTts = FlutterTts();

  DetailWordCard({
    Key key,
    @required this.englishWord,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
          child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        englishWord.enWord,
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
                                  await flutterTts.speak(englishWord.enWord);
                                },
                                child: Icon(Icons.volume_up)),
                            radius: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () {
                              Share.share(englishWord.enWord +
                                  " : \n" +
                                  englishWord.enDefinition);
                            },
                            child: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              child: Icon(Icons.share),
                              radius: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(englishWord.enDefinition),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "e.g.",
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                      Container(
                        width: 1,
                        color: Colors.black12,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: Text(englishWord.example.trim() == "NA"
                              ? ""
                              : englishWord.example.trim()))
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  (englishWord.antonyms != "NA")
                      ? Text(
                          'Synonyms: ' + englishWord.synonyms,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : Container(),
                  SizedBox(
                    height: 5,
                  ),
                  (englishWord.antonyms != "NA")
                      ? Text(
                          ''
                                  'Antonyms: ' +
                              englishWord.antonyms,
                          style: TextStyle(fontStyle: FontStyle.italic),
                        )
                      : Container(),
                ],
              ),
            ),
            Container(
              color: Colors.black12,
              height: 1,
            )
          ],
        ),
      )),
    );
  }
}
