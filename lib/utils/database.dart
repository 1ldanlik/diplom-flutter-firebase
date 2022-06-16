import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_diplom_first/pages/profile_page.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String? commonId;
  static String? userUid;

  static Future<void> addItem({
    required String title,
    required String description,
    required Timestamp date,
    required String type,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
      "date": date,
      "type": type,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note item added to the database"))
        .catchError((e) => print(e));
    // data.clear();
  }


  static Future<void> addUserSubdivision({
    required String subdivision,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('userSubdivisionData').doc(userUid);

    Map<String, dynamic> data = <String, dynamic>{
      "subdivision": subdivision,
    };

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note user subdivision added to the database"))
        .catchError((e) => print(e));
    // data.clear();
  }
  static Future<void> addUserDateOfBirth({
    required Timestamp dateOfBirth,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('userDateOfBirthData').doc(userUid);

    Map<String, Timestamp> data = <String, Timestamp>{
      "dateOfBirth": dateOfBirth,
    };


    print(data.toString() + 'loooooooooooool');

    await documentReferencer
        .set(data)
        .whenComplete(() => print("Note user date of birth added to the database"))
        .catchError((e) => print(e));
    // data.clear();
  }

  static Future<void> updateUserSubdivision({
    required String subdivision,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('userSubdivisionData').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{

      "subdivision": subdivision,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note user subdivision updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> updateUserDateOfBirth({
    required String dateOfBirth,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('userDateOfBirthData').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{

      "dateOfBirth": dateOfBirth,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note user date of birth updated in the database"))
        .catchError((e) => print(e));
  }


  static Future<void> updateItem({
    required String title,
    required String description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('items').doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "description": description,
        "title": title,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Stream<QuerySnapshot> readItems() {
    Query notesItemCollection =
    _mainCollection.doc(commonId).collection('items').orderBy("date");

    print('11111111111111111111111111111111111111' + notesItemCollection.snapshots.toString());
    return notesItemCollection.snapshots();
  }

  static Future<DateTime> readDateOfBirthday(String? userID) async{
    var notesItemCollection =
    _mainCollection.doc(commonId).collection('userDateOfBirthData').doc(userID);
    var lol = await notesItemCollection.get();
    Map<String, dynamic>? data = lol.data();
    Timestamp timestamp = data!['dateOfBirth'];
    print('11111111111111111111111111111111111111' + timestamp.toString());
    return timestamp.toDate();
  }

  static Future<String?> readSubdivision(String? userID) async{
    var notesItemCollection =
    _mainCollection.doc(commonId).collection('userSubdivisionData').doc(userID);
    var lol = await notesItemCollection.get();
    Map<String, dynamic>? data = lol.data();
    String subdivision = data!['subdivision'];
    print('11111111111111111111111111111111111111' + subdivision.toString());
    return subdivision;
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(commonId).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}