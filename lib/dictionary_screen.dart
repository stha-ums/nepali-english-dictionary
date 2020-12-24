
import 'package:dictionary/models/english_words_dictionary.dart';
import 'package:dictionary/provider/dictionaryProvider.dart';
import 'package:dictionary/wordDetail.dart';
import 'package:dictionary/wordDetailsEnglish.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'models/definitions.dart';
import 'models/examples.dart';
import 'models/words.dart';

class DictionaryApp extends StatefulWidget {
  @override
  _DictionaryAppState createState() => _DictionaryAppState();
}

class _DictionaryAppState extends State<DictionaryApp> {
  ItemScrollController itemScrollController;
  ItemPositionsListener itemPositionsListener;
  TextEditingController searchController;
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    itemScrollController = ItemScrollController();
    itemPositionsListener = ItemPositionsListener.create();
    searchController = TextEditingController();
  }

  _searchAndJump(String searchedString, BuildContext context) async {
    if (Provider.of<DictionaryProvider>(context, listen: false)
        .selectedDictionary ==
        Dictionary.Nepali) {
      Word searchedFirst =
      await Provider.of<DictionaryProvider>(context, listen: false)
          .searchTheDictionaryNepali(NepaliUnicode.convert(searchedString));

      if (searchedFirst != null) {
        itemScrollController.jumpTo(index: searchedFirst.id - 1);
      }
    } else {
      EnglishWord searchedFirstEnglish =
      await Provider.of<DictionaryProvider>(context, listen: false)
          .searchTheDictionaryEnglish(searchedString);
      if (searchedFirstEnglish != null) {
        itemScrollController.jumpTo(index: searchedFirstEnglish.rowid - 1);
      }
    }
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
            actions: [
              Center(child: Text("EN")),
              Consumer<DictionaryProvider>(builder: (context, data, child) {
                return Switch.adaptive(
                    value: data.selectedDictionary == Dictionary.Nepali,
                    onChanged: (value) {
                      data.toggleDictionaryLanguage();
                      print(data.selectedDictionary);
                      itemScrollController.jumpTo(index: 0);
                    });
              }),
              Center(child: Text("NP")),
              SizedBox(
                width: 8,
              ),
            ],
            bottom: PreferredSize(
              preferredSize: Size(double.infinity, 40),
              child: Container(
                height: 40,
                margin:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: Consumer<DictionaryProvider>(
                    builder: (context, data, child) {
                      return TextField(
                          focusNode: focusNode,
                          controller: searchController,
                          decoration: InputDecoration(
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            hintText: data.selectedDictionary == Dictionary.Nepali
                                ? "शब्द खोज्नुहोस"
                                : "Search words",
                            border: OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.none)),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.none)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(style: BorderStyle.none)),
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.black54,
                              size: 20,
                            ),
                            suffixIcon: InkWell(
                              child: Icon(
                                Icons.clear,
                                color: Colors.black54,
                                size: 20,
                              ),
                              onTap: () {
                                searchController.clear();
                                itemScrollController.jumpTo(index: 0);
                              },
                            ),
                          ),
                          onChanged: (value) {
                            if (value.trim().length > 0)
                              _searchAndJump(value, context);
                            else {
                              itemScrollController.jumpTo(index: 0);
                            }
                          });
                    }),
              ),
            ),
          ),
          body: Consumer<DictionaryProvider>(
            builder: (context, dictionaryData, child) {
              if (dictionaryData.selectedDictionary == Dictionary.Nepali)
                return dictionaryData.allDictionaryWordsNepali == null
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : ListOfWords(
                  itemPositionsListener: itemPositionsListener,
                  itemScrollController: itemScrollController,
                  requestFocus: () {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                );
              else
                return dictionaryData.allDictionaryWordsEnglish == null
                    ? Center(
                  child: CircularProgressIndicator(),
                )
                    : ListOfWords(
                  itemPositionsListener: itemPositionsListener,
                  itemScrollController: itemScrollController,
                  requestFocus: () {
                    FocusScope.of(context).requestFocus(focusNode);
                  },
                );
            },
          ),
        );
      },
    );
  }
}

class ListOfWords extends StatelessWidget {
  final ItemScrollController itemScrollController;
  final ItemPositionsListener itemPositionsListener;
  final Function requestFocus;

  ListOfWords({
    Key key,
    this.itemScrollController,
    this.itemPositionsListener,
    this.requestFocus,
    // this.dictionaryScrollController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      physics: ClampingScrollPhysics(),
      itemCount: Provider.of<DictionaryProvider>(context, listen: false)
          .selectedDictionary ==
          Dictionary.Nepali
          ? Provider.of<DictionaryProvider>(context, listen: false)
          .allDictionaryWordsNepali
          .length
          : Provider.of<DictionaryProvider>(context, listen: false)
          .allDictionaryWordsEnglish
          .length,
      itemScrollController: itemScrollController,
      itemPositionsListener: itemPositionsListener,
      itemBuilder: (context, index) {
        if (Provider.of<DictionaryProvider>(context, listen: false)
            .selectedDictionary ==
            Dictionary.Nepali) {
          Word wordModel =
          Provider.of<DictionaryProvider>(context, listen: false)
              .allDictionaryWordsNepali[index];

          List<Definition> definitions;
          List<Example> examples;

          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    bool focus = await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => WorldDetails(
                          wordModel: wordModel,
                          wordDefinition: definitions,
                          example: examples,
                        ),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ),
                    );
                    if (focus != null) {
                      requestFocus();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                wordModel.value,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                "/" + wordModel.partOfSpeech + "/",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(""),
                              FutureBuilder<List<Definition>>(
                                  future: Provider.of<DictionaryProvider>(
                                      context,
                                      listen: false)
                                      .getDefinitions(wordModel.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      if (snapshot.data.isEmpty) {
                                        return Text("N/A");
                                      }
                                      definitions = snapshot.data;
                                      return Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: snapshot.data
                                              .asMap()
                                              .entries
                                              .map((def) => Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                (def.key + 1)
                                                    .toString() +
                                                    '. ' +
                                                    def.value.value,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets
                                                    .all(8.0),
                                                child: FutureBuilder<
                                                    List<Example>>(
                                                    future: Provider.of<
                                                        DictionaryProvider>(
                                                        context,
                                                        listen:
                                                        false)
                                                        .getExamples(def
                                                        .value.id),
                                                    builder: (context,
                                                        snapshot) {
                                                      if (snapshot
                                                          .data !=
                                                          null) {
                                                        if (snapshot
                                                            .data
                                                            .isEmpty) {
                                                          return Text(
                                                              "N/A");
                                                        }
                                                        examples =
                                                            snapshot
                                                                .data;
                                                        return Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children:
                                                            snapshot
                                                                .data
                                                                .map((exp) {
                                                              return Column(
                                                                children: [
                                                                  Text(
                                                                    '· ' +
                                                                        exp.value,
                                                                  ),
                                                                ],
                                                              );
                                                            }).toList());
                                                      } else
                                                        return Container();
                                                    }),
                                              ),
                                            ],
                                          ))
                                              .toList());
                                    } else
                                      return Container();
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black12,
                  height: 1,
                )
              ],
            ),
          );
        } else {
          EnglishWord englishWord =
          Provider.of<DictionaryProvider>(context, listen: false)
              .allDictionaryWordsEnglish[index];
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () async {
                    bool focus = await Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (c, a1, a2) => EnglishWordDetails(
                          wordModel: englishWord,
                        ),
                        transitionsBuilder: (c, anim, a2, child) =>
                            FadeTransition(opacity: anim, child: child),
                        transitionDuration: Duration(milliseconds: 100),
                      ),
                    );
                    if (focus != null) {
                      requestFocus();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                englishWord.enWord,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(englishWord.enDefinition),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  englishWord.example.trim() == "NA"
                                      ? Text(
                                    "e.g.",
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic),
                                  )
                                      : Container(
                                    width: 1,
                                    color: Colors.black12,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Text(
                                          englishWord.example.trim() == "NA"
                                              ? ""
                                              : englishWord.example.trim()))
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              (englishWord.synonyms != "NA")
                                  ? Text(
                                'Synonyms: ' + englishWord.synonyms,
                                style: TextStyle(
                                    fontStyle: FontStyle.italic),
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
                                style: TextStyle(
                                    fontStyle: FontStyle.italic),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black12,
                  height: 1,
                )
              ],
            ),
          );
        }
      },
    );
  }
}
