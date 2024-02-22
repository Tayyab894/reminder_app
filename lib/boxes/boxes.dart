import 'package:hive/hive.dart';
import 'package:learn_hive/models/notes_model.dart';

class Boxes {
  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}
