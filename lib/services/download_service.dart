import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DownloadService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _ensureUserDocument() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userDoc = _firestore.collection('users').doc(uid);
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      await userDoc.set({'createdAt': FieldValue.serverTimestamp()});
    }
  }

  Future<void> addDownload(String fileName) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _ensureUserDocument();

    final downloadsRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('downloads');

    await downloadsRef.add({
      'fileName': fileName,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<List<String>> getDownloads() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];

    await _ensureUserDocument();

    final downloadsRef = _firestore
        .collection('users')
        .doc(uid)
        .collection('downloads');

    final querySnapshot = await downloadsRef.get();

    if (querySnapshot.docs.isEmpty) return [];

    return querySnapshot.docs
        .map((doc) => (doc.data()['fileName'] ?? 'Desconocido').toString())
        .toList();
  }
}
