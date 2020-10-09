
import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../provide/child_category.dart';
import 'package:provider/provider.dart';
import '../model/categoryGoodsList.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';



class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('商品分类'),
      ),
      body: Container(
        child:Row(
          children:<Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodsList(),
              ],
            )
          ]
        )
      ),
    );
  }
}

//左侧一级导航

class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0; //索引
  @override
  void initState() { 
    _getCategory();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.w,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(width: 1,color: Colors.black12))
      ),
      child: ListView.builder(
        itemCount:list.length,
        itemBuilder:(context,index) {
          return _leftInkWel(index);
        }
      ),
    );
  }

  void _getCategory() async {
    print('开始请求分类页面数据。。。。。。');
    await request('getCategory').then((value){
      var data = json.decode(value.toString());
      CategoryBigListModel category = CategoryBigListModel.fromJson(data['data']);
      setState(() {
        list = category.data;
        list.forEach((item) => print(item.mallCategoryName));
      });
      context.read<ChildCategory>().getChildCategory(list[0].bxMallSubDto,list[0].mallCategoryId);

      list[0].bxMallSubDto.forEach((item) => print('---${item.mallSubName}'));
    });
  }

  Widget _leftInkWel(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        context.read<ChildCategory>().getChildCategory(childList,categoryId);
      },
      child: Container(
        height: 100.h,
        padding: EdgeInsets.only(left:10,top:20),
        decoration: BoxDecoration(
          color:isClick ?Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
          border:Border(
            bottom: BorderSide(width: 1,color: Colors.black12)
          ),
        ),
        child: Text(list[index].mallCategoryName,style: TextStyle(
          fontSize: 28.sp
        ),),
      ),
    );
  }
}

//右边二级导航
class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80.h,
      width: 570.w,
      decoration: BoxDecoration(
        color:Colors.white,
        border:Border(
          bottom:BorderSide(width: 1,color:Colors.black12)
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: context.watch<ChildCategory>().childCategoryList.length,
        itemBuilder: (context,index){
          return _rightInkWell(index,context.watch<ChildCategory>().childCategoryList[index]);
        },
      ),
    );
  }

  void _getGoodsList({String categorySubId}) async{
    var data = {
      'categoryId' : context.read<ChildCategory>().categoryId,
      'categorySubId': categorySubId,
      'page':1 
    };
    print('======${data}');
    await request('getMallGoods',formData:data).then((value){
      var data = json.decode(value.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if (goodsList.data == null) {
        context.read<CategoryGoodsListProvide>().getGoodsList([]);
      } else {
        context.read<CategoryGoodsListProvide>().getGoodsList(goodsList.data);
      }

      goodsList.data.forEach((element) {
        print('${element.goodsName}');
      });
    });
  }

  Widget _rightInkWell(int index,BxMallSubDto item) {
    bool isCheck = false;
    isCheck = (index == context.read<ChildCategory>().childIndex)?true:false;
    return InkWell(
      onTap: (){
        context.read<ChildCategory>().changeChildIndex(index,item.mallSubId);
        _getGoodsList(categorySubId: item.mallSubId);
      },
      child: Container(
        padding:EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
        child:Text(
          item.mallSubName,
          style: TextStyle(fontSize:28.sp,color:isCheck?Colors.pink:Colors.black),
        )
      ),
    );
  }
}

//商品列表

class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  @override
  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  var scrollController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    try{
      if(context.watch<ChildCategory>().page == 1) {
        scrollController.jumpTo(0.0);
      }
    }catch(e){
      print('进入页面第一次初始化：${e}');
    }
    if (context.watch<CategoryGoodsListProvide>().goodsList.length > 0) {
       return Expanded(
          child:Container(
          width: 570.w,
          height: 900.h,
          child: EasyRefresh(
            footer: ClassicalFooter(
              bgColor: Colors.white,
              textColor: Colors.pink,
              infoColor:Colors.pink,
              showInfo: true,
              noMoreText: context.watch<ChildCategory>().noMoreText,
              infoText: '加载中',
              loadReadyText: '上拉加载'
            ),
            child: ListView.builder(
              controller: scrollController,
              itemCount:context.watch<CategoryGoodsListProvide>().goodsList.length,
              itemBuilder:(context,index) {
                return _listWidget(context.watch<CategoryGoodsListProvide>().goodsList,index);
              }
            ),
            onLoad: () async {
              print('没有更多了。。。。。。');
            },
          
          )
         )
      );
    } else {
        return Text('暂时没有数据');
    }

   
  }

  void _getMoreList() {
    context.read<ChildCategory>().addPage();

    var data = {
      'categoryId':context.read<ChildCategory>().categoryId,
      'categorySubId':context.read<ChildCategory>().subId,
      'page':context.read<ChildCategory>().page
    };

    request('getMallGoods',formData:data).then((value) {
      var data = json.decode(value.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);

      if(goodsList.data == null) {
        context.read<ChildCategory>().changeNoMore('没有更多了');
      } else {
        context.read<CategoryGoodsListProvide>().getGoodsList(goodsList.data);
      }

    });
  }

  Widget _goodsImage (List newList,index) {
    return Container(
      width: 200.w,
      child: Image.network(newList[index].image),
    );
  }

  Widget _goodName(List newList,index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: 370.w,
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize:28.sp),
      ),
    );
  }

  Widget _goodsPrice(List newList,index) {
    return Container(
      margin: EdgeInsets.only(top:20.0),
      width: 370.w,
      child: Row(
        children: <Widget>[
          Text(
            '价格：¥${newList[index].presentPrice}',
            style: TextStyle(color:Colors.pink,fontSize:30.sp),
          ),
          Text(
            '¥${newList[index].oriPrice}',
            style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),
          )
        ],
      ),
    );
  }

  Widget _listWidget(List newList,int index) {
    return InkWell(
      onTap: (){},
      child: Container(
        padding:EdgeInsets.only(top:5.0,bottom:5.0),
        decoration:BoxDecoration(
          color:Colors.white,
          border: Border(
            bottom:BorderSide(width: 1.0,color:Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList,index),
            Column(
              children: <Widget>[
                _goodName(newList,index),
                _goodsPrice(newList,index)
              ],
            )
          ],
        ),
      ),
    );
  }
}