import 'dart:io' as io;

import 'package:dictionary/database_helper/database_helper.dart';
import 'package:dictionary/models/definitions.dart';
import 'package:dictionary/models/english_words_dictionary.dart';
import 'package:dictionary/models/examples.dart';
import 'package:dictionary/models/words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../download_utils.dart';

enum Dictionary { Nepali, English }

class DictionaryProvider extends ChangeNotifier {
  List<Word> allDictionaryWordsNepali;
  List<EnglishWord> allDictionaryWordsEnglish;

  List<List<Definition>> definitions;

  Dictionary selectedDictionary = Dictionary.Nepali;

  DictionaryDataBaseHelper _englishDataBaseHelper = DictionaryDataBaseHelper();
  DictionaryDataBaseHelper _nepaliDataBaseHelper = DictionaryDataBaseHelper();

  DictionaryProvider({Dictionary selectLanguage}) {
    selectedDictionary = selectLanguage ?? Dictionary.Nepali;
    getDataBaseAndInitiate();
  }

  toggleDictionaryLanguage() {
    selectedDictionary == Dictionary.Nepali
        ? selectedDictionary = Dictionary.English
        : selectedDictionary = Dictionary.Nepali;
    notifyListeners();
  }

  Future<void> getDataBaseAndInitiate() async {
    io.Directory applicationDirectory =
        await getApplicationDocumentsDirectory();
    _initiateNepali(applicationDirectory);
    _initiateEnglish(applicationDirectory);
  }

  Future<List<Definition>> getDefinitions(int wordId) async {
    return await _nepaliDataBaseHelper.getTheDefinitionOfTheWord(wordId);
  }

  Future<List<Example>> getExamples(int definitionId) async {
    return await _nepaliDataBaseHelper
        .getTheExampleOfTheDefinition(definitionId);
  }

  Future<Word> searchTheDictionaryNepali(String searchTerm) async {
    List<Word> searchedList =
        await _nepaliDataBaseHelper.searchTheDataBase(searchTerm);
    return searchedList.isNotEmpty ? searchedList.first : null;
  }

  Future<EnglishWord> searchTheDictionaryEnglish(String searchTerm) async {
    List<EnglishWord> searchedList =
        await _englishDataBaseHelper.searchTheDatabaseEnglish(searchTerm);
    return searchedList.isNotEmpty ? searchedList.first : null;
  }

  _initiateNepali(io.Directory applicationDirectory) async {
    
    String dbPathNepali =
        path.join(applicationDirectory.path, "nepaliDictionary.db");
    bool dbExistsNepali = await io.File(dbPathNepali).exists();
    print("__ nepali file $dbExistsNepali");
    if (!dbExistsNepali) {
      //todo add dataBase url here
      String url = "https://rdcdn.ams3.cdn.digitaloceanspaces.com/joynepal/uploads/dict-data-db/nep_dict.sqlite3";
      await downloadFile(url, dbPathNepali);
    }
    //nepali database
    try {
      await _nepaliDataBaseHelper.init(dbPathNepali);
      allDictionaryWordsNepali = await _nepaliDataBaseHelper.getAllTheWords();
      notifyListeners();
    } catch (e) {
      await io.File(dbPathNepali).delete(recursive: true);
      await _initiateNepali(applicationDirectory);
      Future.delayed(Duration(microseconds: 10));
    }
  }

  _initiateEnglish(io.Directory applicationDirectory) async {
    String dbPathEnglish =
        path.join(applicationDirectory.path, "englishDictionary.db");

    bool dbExistsEnglish = await io.File(dbPathEnglish).exists();
    print("___ english file $dbExistsEnglish");

    if (!dbExistsEnglish) {
      // add english database
      String url = "https://rdcdn.ams3.cdn.digitaloceanspaces.com/joynepal/uploads/dict-data-db/eng_dictionary.db";
      await downloadFile(url, dbPathEnglish);
    }

    // english database
    try {
      await _englishDataBaseHelper.init(dbPathEnglish);
      allDictionaryWordsEnglish =
          await _englishDataBaseHelper.getAllTheWordsEnglish();
      notifyListeners();
    } catch (e) {
      await io.File(dbPathEnglish).delete(recursive: true);
      await _initiateEnglish(applicationDirectory);
      Future.delayed(Duration(microseconds: 10));
    }
  }
}
