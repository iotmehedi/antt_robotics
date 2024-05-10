import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/course_model.dart';


class CourseDetailsServices {
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  Future<List<dynamic>> fetchData({required String mainCollectionName, required String nestedCollectionName}) async {
    var dataList = <dynamic>[];

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await firebaseStore.collection(mainCollectionName).get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> doc in querySnapshot.docs) {
        CourseDetailsModel mainData = CourseDetailsModel.fromJson(doc.data()!);
        dataList.add(mainData);

        QuerySnapshot<Map<String, dynamic>> nestedQuerySnapshot =
        await firebaseStore
            .collection(mainCollectionName)
            .doc(doc.id)
            .collection(nestedCollectionName)
            .get();

        for (QueryDocumentSnapshot<Map<String, dynamic>> nestedDoc
        in nestedQuerySnapshot.docs) {
          LinksModel linksData = LinksModel.fromMap(nestedDoc.data()!);
          dataList.add(linksData);
        }
      }
    } catch (error) {
      print("Error loading data from Firestore: $error");
    }

    return dataList;
  }
}

