import 'package:dictionary/models/definitions.dart';
import 'package:dictionary/models/english_words_dictionary.dart';
import 'package:dictionary/models/examples.dart';
import 'package:dictionary/models/words.dart';
import 'package:sqflite/sqflite.dart';

class DictionaryDataBaseHelper {
  Database _db;

  /// initialize the database in readonly mode
  /// this function should be called after the object created.
  Future<void> init(String dbPath) async {
    this._db = await openReadOnlyDatabase(dbPath);
  }

  /// get all the list of words  from database;
  Future<List<Word>> getAllTheWords() async {
    if (_db == null) {
      throw "bd is not initiated initiate using [init(db)] function";
    }
    List<Map> words;
    await _db.transaction((txn) async {
      words = await txn.query(
        "word",
      );
    });

    return words.map((e) => Word.fromJson(e)).toList();
  }

  /// get all the words from english dictionary
  Future<List<EnglishWord>> getAllTheWordsEnglish() async {
    print("get all the english words");
    if (_db == null) {
      throw "bd is not initiated initiate using [init(db)] function";
    }
    List<Map> words;
    await _db.transaction((txn) async {
      words = await txn.query(
          "words",
          columns: [
            "rowid",
            "en_word",
            "en_definition",
            "example",
            "synonyms",
            "antonyms",
          ]
      );
    });


    return words.map((e) =>
        EnglishWord.fromJson(e)).toList();
  }

  /// get the definition of the word
  Future<List<Definition>> getTheDefinitionOfTheWord(int wordId) async {
    List<Map> def;
    await _db.transaction((txn) async {
      def = await txn.query("definition", where: "word_id==$wordId");
    });

    return def.map((e) => Definition.fromJson(e)).toList();
  }

  /// get the examples for a respective definition
  Future<List<Example>> getTheExampleOfTheDefinition(int definitionId) async {
    List<Map> def;
    await _db.transaction((txn) async {
      def = await txn.query("example", where: "definition_id==$definitionId");
    });
    return def.map((e) => Example.fromJson(e)).toList();
  }

  /// search the List of [word]s with the String containing
  Future<List<Word>> searchTheDataBase(String searchTerm) async {
    List<Map> result;
    await _db.transaction((txn) async {
      result = await txn.query("word", where: "value LIKE '$searchTerm%'");
    });
    return result.map((e) => Word.fromJson(e)).toList();
  }


  /// search english words, returns [EnglishWord]s with the string containing
  Future<List<EnglishWord>> searchTheDatabaseEnglish(String searchTerm) async {
    List<Map> result;
    await _db.transaction((txn) async {
      result = await txn.query("words",      columns: [
        "rowid",
        "en_word",
        "en_definition",
        "example",
        "synonyms",
        "antonyms",
      ]  , where: "en_word LIKE '$searchTerm%'");
    });
    return result.map((e) => EnglishWord.fromJson(e)).toList();
  }
}
