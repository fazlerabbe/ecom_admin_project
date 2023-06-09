import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../db/db_helper.dart';
import '../models/category_model.dart';
import '../models/product_model.dart';
import '../models/purchase_model.dart';

class ProductProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];
  List<PurchaseModel> _purchaseList = [];

  Future<void> addNewCategory(String category) {
    final categoryModel = CategoryModel(categoryName: category);
    return DbHelper.addCategory(categoryModel);
  }

  Future<void> addNewProduct(
      ProductModel productModel, PurchaseModel purchaseModel) {
    return DbHelper.addNewProduct(productModel, purchaseModel);
  }

  getAllCategories() {
    DbHelper.getAllCategories().listen((snapshot) {
      categoryList = List.generate(snapshot.docs.length,
          (index) => CategoryModel.fromMap(snapshot.docs[index].data()));
      categoryList
          .sort((cat1, cat2) => cat1.categoryName.compareTo(cat2.categoryName));
      notifyListeners();
    });
  }

  getAllProducts() {
    DbHelper.getAllProducts().listen((snapshot) {
      productList = List.generate(snapshot.docs.length,
          (index) => ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  getAllPurchase() {
    DbHelper.getAllPurchases().listen((snapshot) {
      _purchaseList = List.generate(snapshot.docs.length, (index) =>
          PurchaseModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  List<PurchaseModel> getPurchaseByProductId(String productId) {
    List<PurchaseModel> list = [];
    list = _purchaseList.where((model) => model.productId == productId).toList();
    return list;
  }

  Future<void> repurchase(PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  ProductModel getProductById(String productId) {
    return productList.firstWhere((element) => element.productId == productId);
  }

  Future<void> updateProductField(String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field : value});
  }

  /*
  List<CategoryModel> getCategoryListForFiltering() {
    return [CategoryModel(categoryName: 'All'), ... categoryList];
  }

  getAllProductsByCategory(CategoryModel categoryModel) {
    DbHelper.getAllProductsByCategory(categoryModel).listen((snapshot) {
      productList = List.generate(snapshot.docs.length, (index) =>
          ProductModel.fromMap(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<String> uploadImage(String thumbnailImageLocalPath) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putFile(File(thumbnailImageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }

  Future<String> uploadImageForWeb(PickedFile pickedFile) async {
    final photoRef = FirebaseStorage.instance
        .ref()
        .child('ProductImages/${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = photoRef.putData(await pickedFile.readAsBytes());
    final snapshot = await uploadTask.whenComplete(() => null);
    return snapshot.ref.getDownloadURL();
  }



  Future<void> deleteImage(String downloadUrl) {
    return FirebaseStorage.instance.refFromURL(downloadUrl).delete();
  }

  Future<void> repurchase(PurchaseModel purchaseModel, ProductModel productModel) {
    return DbHelper.repurchase(purchaseModel, productModel);
  }

  Future<void> updateProductField(String productId, String field, dynamic value) {
    return DbHelper.updateProductField(productId, {field : value});
  }

  */
}
