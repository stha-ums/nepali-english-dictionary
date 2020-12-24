import 'package:dictionary/models/words.dart';
import 'package:dictionary/provider/dictionaryProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return Scaffold(
        appBar: AppBar(
          title: Text("नेपाली शब्दकोष"),
          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 40),
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, true);
                },
                child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                      hintText: "शब्द खोज्नुहोस",
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
                        onTap: () {},
                      ),
                    ),
                    onChanged: (value) {}),
              ),
            ),
          ),
        ),
        body: ChangeNotifierProvider(
          create: (_) => DictionaryProvider(),
          child: DetailWordCard(
            wordModel: widget.wordModel,
            wordDefinition: widget.wordDefinition,
            example: widget.example,
          ),
        ));
  }
}

class DetailWordCard extends StatelessWidget {
  final Word wordModel;
  final List<Definition> wordDefinition;
  final List<Example> example;

  const DetailWordCard(
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
                                color: Theme.of(context).primaryColor),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                child: Icon(Icons.volume_up),
                                radius: 18,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              CircleAvatar(
                                child: Icon(Icons.share),
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
                            color: Theme.of(context).primaryColor),
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
