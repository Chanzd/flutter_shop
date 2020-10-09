import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0;
  String categoryId = '4';
  String subId = '';
  int page = 1;
  String noMoreText = '';

  getChildCategory(List<BxMallSubDto> list,String id) {

    categoryId = id;
    subId = '';


    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  changeChildIndex(int index, String id) {
    childIndex = index;
    subId = id;

    page = 1;
    noMoreText = '';

    notifyListeners();
  }

  addPage(){
    page++;
    notifyListeners();
  }

  changeNoMore(String text) {
    noMoreText = text;
    notifyListeners();
  }
}