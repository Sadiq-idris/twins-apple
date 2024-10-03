import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietitian_cons/backend/auth_services.dart';
import 'package:dietitian_cons/models/order_model.dart';
import 'package:dietitian_cons/models/product_model.dart';
import 'package:flutter/material.dart';

class DbCloud {
  final _article = FirebaseFirestore.instance.collection("articles");
  final _recipe = FirebaseFirestore.instance.collection("recipes");
  final _chat = FirebaseFirestore.instance.collection("chats");
  final _user = FirebaseFirestore.instance.collection("users");
  final _product = FirebaseFirestore.instance.collection("products");
  final _order = FirebaseFirestore.instance.collection("orders");
  final _report = FirebaseFirestore.instance.collection("reports");
  final _admin = FirebaseFirestore.instance.collection("admins");

  // Adding aritcle to database
  Future<void> add(String title, String thumnailUrl, String content) async {
    try {
      await _article.add({
        "title": title,
        "thumbnailUrl": thumnailUrl,
        "content": content,
        "createAt": Timestamp.now(),
      });
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // get the data from article database
  Stream<QuerySnapshot<Map<String, dynamic>>> read() {
    try {
      final response =
          _article.orderBy('createAt', descending: true).snapshots();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Detail article
  Future<DocumentSnapshot<Map<String, dynamic>>> detail(String docId) async {
    try {
      final response = await _article.doc(docId).get();

      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Updating article
  Future<void> update(String docId, Map<String, dynamic> data) async {
    try {
      await _article.doc(docId).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Delete arictle
  Future<void> delete(String docId) async {
    try {
      await _article.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // search article
  Stream<List<List<Object>>> searchArticle(String title) {
    try {
      final response = _article
          .where("title", isGreaterThan: title)
          .where("title", isLessThan: "$title\uf7ff")
          .snapshots();
      return response.map((doc) {
        return doc.docs.map((data) {
          return [data.data(), data.id];
        }).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  // add recipe
  Future<void> addRecipe(String name, List<String> images,
      List<Map<String, String>> ingredients, String description) async {
    try {
      await _recipe.add({
        "name": name,
        "images": images,
        "ingredients": jsonEncode(ingredients),
        "description": description,
      });
    } catch (e) {
      rethrow;
    }
  }

  // get all recipes
  Stream<QuerySnapshot<Map<String, dynamic>>> getRecipes() {
    try {
      return _recipe.snapshots();
    } catch (e) {
      rethrow;
    }
  }

  // detail recipe
  Future<DocumentSnapshot<Map<String, dynamic>>> detailRecipe(
      String docId) async {
    try {
      return await _recipe.doc(docId).get();
    } catch (e) {
      rethrow;
    }
  }

  // update recipe
  Future<void> updateRecipe(String docId, Map<String, dynamic> newData) async {
    try {
      await _recipe.doc(docId).update(newData);
    } catch (e) {
      rethrow;
    }
  }

  // delete recipe
  Future<void> deleteRecipe(String docId) async {
    try {
      await _recipe.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // search recipe
  Stream<List<List<Object>>> searchRecipe(String name) {
    try {
      final response = _recipe
          .where("name", isGreaterThan: name)
          .where("name", isLessThan: "$name\uf7ff")
          .snapshots();
      return response.map((doc) {
        return doc.docs.map((data) {
          return [data.data(), data.id];
        }).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  // save users infomation
  Future<void> saveUser(String email, String id, int? phoneNumber) async {
    try {
      await _user.doc(id).set({
        "email": email,
        "phoneNumber": phoneNumber,
        "uid": id,
      });
    } catch (e) {
      rethrow;
    }
  }

  // getting users infos
  Stream<List<Map<String, dynamic>>> getUsers() {
    try {
      final response = _user.snapshots();
      return response.map((data) {
        return data.docs.map((doc) => doc.data()).toList();
      });
    } catch (e) {
      rethrow;
    }
  }

  Future getSingleUser(String email)async{
    try{
      return _user.where("email", isEqualTo: email).get();
    } catch(error) {
      rethrow;
    }
  }

  // adding message to chat
  void sendMessage(String message, String uid, String email) {
    final auth = AuthServices();
    final currentUser = auth.getCurrentuser();
    try {
      _chat.doc(email).collection("messages").add(
        {
          "sender": currentUser!.uid == uid,
          "message": message,
          "timeStamp": Timestamp.now(),
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  // getting message from chat
  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String email) {
    try {
      return _chat
          .doc(email)
          .collection("messages")
          .orderBy("timeStamp", descending: false)
          .snapshots();
    } catch (e) {
      debugPrint(e.toString());
      rethrow;
    }
  }

  Future addNotification(String email, bool send, bool recieve) async {
    await FirebaseFirestore.instance
        .collection("notification")
        .doc(email)
        .set({"send": send, "receive": recieve});
  }

  Future updateNotification(String email, bool send, bool recieve) async {
    try {
      await FirebaseFirestore.instance
          .collection("notification")
          .doc(email)
          .update({
        "send": send,
        "recieve": recieve,
      });
    } catch (error) {
      rethrow;
    }
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getNotification(
      String email) async {
    try {
      return await FirebaseFirestore.instance
          .collection("notification")
          .doc(email)
          .get();
    } catch (error) {
      rethrow;
    }
  }

  // adding new product to database
  Future<void> newProduct(ProductModel product) async {
    try {
      await _product.add(product.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // getting products from database
  Stream<List> getProducts() {
    try {
      final response = _product
          .orderBy("createAt", descending: true)
          .snapshots()
          .map((docs) {
        return docs.docs;
      });
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // detail product
  Stream<Map<String, dynamic>> detailProducts(String docId) {
    try {
      return _product.doc(docId).snapshots().map((data) {
        return data.data()!;
      });
    } catch (e) {
      rethrow;
    }
  }

  // deleting product
  Future deleteProduct(String docId) async {
    try {
      await _product.doc(docId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future updateProduct(String docId, ProductModel update) async {
    try {
      await _product.doc(docId).update(update.toJson());
    } catch (error) {
      rethrow;
    }
  }

  // Ordered products
  Future<void> newOrder(OrderModel order) async {
    try {
      await _order.add(order.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUserOrder(
      String userEmail) {
    try {
      final response =
          _order.where('userEmail', isEqualTo: userEmail).snapshots();
      return response.map((data) {
        return data.docs;
      });
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllOrder() {
    try {
      final response = _order.snapshots().map((data) => data.docs);

      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateOrder(String docId, OrderModel newOrder) async {
    try {
      _order.doc(docId).update(newOrder.toJson());
    } catch (error) {
      rethrow;
    }
  }

  Future<void> deleteOrder(String docId) async {
    try {
      await _order.doc(docId).delete();
    } catch (error) {
      rethrow;
    }
  }

  // Adding reports
  Future<void> addReport(String aboutReport, String report, String email) async {
    try {
      await _report.add({
        "aboutReport": aboutReport,
        "report": report,
        "reporter": email,
      });
    } catch (error) {
      rethrow;
    }
  }

  Stream getReports(){
    try{
      return  _report.snapshots().map((data)=>data.docs);
    } catch(error){
      rethrow;
    }
  }

  Future deleteReport(String docId)async{
    try{
      await _report.doc(docId).delete();
    } catch(error){
      rethrow;
    }
  }

  // consultation payment
  Future consultationPaid(String email, bool? paid)async{
    try{
      await FirebaseFirestore.instance.collection("consultation").doc(email).set({
        "paid":paid,
      });
    } catch(error){
      rethrow;
    }
  }

  Future getConsultationPaid(String email)async{
    try{
      return await FirebaseFirestore.instance.collection("consultation").doc(email).get();
    } catch(error){
      rethrow;
    }
  }

  Future addAdmin(String email, String uid)async{
    try{
      _admin.doc(uid).set({
        "email":email,
      });
    } catch (error){
      rethrow;
    }
  }

  Stream getAdmins(){
    try{
      return _admin.snapshots();
    } catch(error){
      rethrow;
    }
  }

  Future deleteAdmin(String docId)async{
    try{
      await _admin.doc(docId).delete();
    } catch(error){
      rethrow;
    }
  }
}
