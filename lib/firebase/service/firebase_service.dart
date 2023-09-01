import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getById(
      {required String path, String? id}) async {
    final snapshot = await _firestore.collection(path).doc(id).get();
    print('FirebaseHelper.getById: ${snapshot.data()}');
    return snapshot;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getData(
      {required String path}) async {
    try {
      final snapshot = await _firestore.collection(path).get();
      return snapshot;
    } catch (e) {
      throw ('Error: $e');
    }
  }

  Future postDocument(
      {required String path,
      String? id,
      required Map<String, dynamic> data,
      required bool isID}) {
    try {
      if (isID == true) {
        final collectionRef = _firestore.collection(path).doc(id).set(data);
        return collectionRef;
      } else {
        final CollectionReference collectionRef = _firestore.collection(path);
        return collectionRef.add(data);
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseHelper.postDocument Error: =$e');
      throw ("Error $e");
    } catch (e) {
      print("Error: $e");
      throw ("Error $e");
    }
  }

  Future<void> deleteDocument(String collectionName, String documentId) async {
    try {
      await _firestore.collection(collectionName).doc(documentId).delete();
      print('Document deleted successfully');
/*      Utils.showSnackBar(
          title: "Success", message: 'deleted successfully', error: false);*/
    } on FirebaseAuthException catch (e) {
/*      Utils.showSnackBar(
          title: "Fail", message: 'Deletion Error: ${e.message}.', error: true);*/
    } catch (e) {
      print('FirebaseHelper.register: $e');
    }
  }

  // Generic upload method for Firebase Storage
  Future<String> uploadFile(String storagePath, String filePath) async {
    final Reference ref = _storage.ref().child(storagePath);
    final UploadTask uploadTask = ref.putFile(File(filePath));
    final TaskSnapshot taskSnapshot = await uploadTask;
    final String downloadURL = await taskSnapshot.ref.getDownloadURL();
    print('FirebaseHelper.uploadFile URL: $downloadURL');
    return downloadURL;
  }

  Future<String> downloadFile(String storagePath) async {
    print('FirebaseHelper.downloadFile:-');
    final Reference ref = _storage.ref().child(storagePath);
    final String downloadURL = await ref.getDownloadURL();
    print('FirebaseHelper.downloadFile: ${downloadURL}');
    return downloadURL;
  }
}
