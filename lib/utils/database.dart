import 'package:cloud_firestore/cloud_firestore.dart';
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  static String? userUid;

  static Future<void> addItem({
    required String title,
    required String description,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "description": description,
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
    _mainCollection.doc(userUid).collection('userSubdivisionData').doc();

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
    required String dateOfBirth,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('userDateOfBirthData').doc();

    Map<String, dynamic> data = <String, dynamic>{
      "dateOfBirth": dateOfBirth,
    };

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
    _mainCollection.doc(userUid).collection('userSubdivisionData').doc(docId);

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
    _mainCollection.doc(userUid).collection('items').doc(docId);

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
    _mainCollection.doc(userUid).collection('items').doc(docId);

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
    CollectionReference notesItemCollection =
    _mainCollection.doc(userUid).collection('items');

    print('11111111111111111111111111111111111111' + notesItemCollection.snapshots.toString());
    return notesItemCollection.snapshots();
  }

  static Future<void> deleteItem({
    required String docId,
  }) async {
    DocumentReference documentReferencer =
    _mainCollection.doc(userUid).collection('items').doc(docId);

    await documentReferencer
        .delete()
        .whenComplete(() => print('Note item deleted from the database'))
        .catchError((e) => print(e));
  }
}