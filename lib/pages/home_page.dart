import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shop/service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';



class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int page = 1;
  List<Map> hotGoodsList = [];



  @override
  Widget build(BuildContext context) {
   
    return Container(
       child: Scaffold(
        appBar: AppBar(title: Text('百姓生活+'),),
        body:FutureBuilder(
          future: getHomePageContent(),
          builder: (context,snapshot){
            if(snapshot.hasData) {
                var data = json.decode(snapshot.data.toString());
                List<Map> swiperDataList = (data['data']['slides'] as List).cast();
                List<Map>navigatorList = (data['data']['category'] as List).cast();
                if (navigatorList.length > 10) {
                  navigatorList.removeRange(10, navigatorList.length);
                }
                String advertesPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
                String leaderImage = data['data']['shopInfo']['leaderImage'];
                String leaderPhone = data['data']['shopInfo']['leaderPhone'];
                List<Map> recommendList = (data['data']['recommend'] as List).cast();
                String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
                String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
                String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
                List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片 
                List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片 
                List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片 
  
                return EasyRefresh(
                  child: ListView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      SwiperDiy(swiperDataList:swiperDataList),
                      TopNavigator(navigatorList:navigatorList),
                      AdBanner(advertesPicture:advertesPicture),
                      LeaderPhone(leaderImage:leaderImage,leaderPhone:leaderPhone),
                      Recommend(recommendList:recommendList),
                      FloorTitle(picture_address:floor1Title),
                      FloorContent(floorGoodsList:floor1),
                      FloorTitle(picture_address:floor2Title),
                      FloorContent(floorGoodsList:floor2),
                      FloorTitle(picture_address:floor3Title),
                      FloorContent(floorGoodsList:floor3),
                      _hotGoods(),
                    ],
                  ),
                  onLoad:() async {
                    var formPage = {'page':page};
                    await request('homePageBelowConten',formData:formPage).then((value) {
                      var data = json.decode(value.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                      });
                    });
                  },
                );
            } else {
                return Center(
                  child: Text('加载中'),
                );
            }
          },
        )
      ),
    );
  }
  //热卖商品
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color:Colors.white,
      border:Border(
        bottom:BorderSide(width: 0.5,color:Colors.black12),
      )
    ),
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if(hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((e){
        return InkWell(
          onTap: (){print('点击了火爆商品');},
          child: Container(
            width: 372.w,
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom:3.0),
            child: Column(
              children: <Widget>[
                Image.network(e['image'],width:375.w),
                Text(e['name'],maxLines:1,overflow: TextOverflow.ellipsis,style: TextStyle(color: Colors.black26,decoration: TextDecoration.lineThrough),)
              ],
            ),
          ),
        );
      }).toList();
      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList(),
        ],
      ),
    );
  }
}

//首页轮播图
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  const SwiperDiy({Key key,this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 333.h,
      width: 750.w,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//首页上部分导航按钮
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  const TopNavigator({Key key,this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context,item) {
    return InkWell(
      onTap: (){
        print('点击了屏幕');
      },
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:95.w),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320.h,
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((e){
          return _gridViewItemUI(context, e);
        }).toList(),
        ),
    );
  }
}
//首页广告栏
class AdBanner extends StatelessWidget {
  final String advertesPicture;
  const AdBanner({Key key,this.advertesPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(advertesPicture),
    );
  }
}

//首页拨打电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone({Key key,this.leaderImage,this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child:Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)){
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

//推荐商品

class Recommend extends StatelessWidget {
  final List recommendList;
  const Recommend({Key key,this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380.h,
      margin: EdgeInsets.only(top:10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }

  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color:Colors.white,
        border:Border(
          bottom:BorderSide(width: 0.5,color:Colors.black12)
        )
      ),
      child: Text('商品推荐',style: TextStyle(color:Colors.pink),),
    );
  }

  Widget _item(index) {
    return InkWell(
      onTap: (){},
      child: Container(
        height: 330.h,
        width: 250.w,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration( 
          color:Colors.white,
          border:Border(
            left:BorderSide(width: 0.5,color:Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('¥${recommendList[index]['mallPrice']}'),
            Text('¥${recommendList[index]['price']}'
            ,style: TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey
            ),),
          ],
        ),
      ),
    );
  }

  Widget _recommendList() {
    return Container( 
      height: 330.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index) {
          return _item(index);
        },
      ),
    );
  }
}

//首页楼层

class FloorTitle extends StatelessWidget {
  final String picture_address;
  const FloorTitle({Key key,this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

//楼层组件商品

class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key,this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(),
          _otherGoods()
        ],
      ),
    );
  }

  Widget _goodItem(Map goods) {
    return Container(
      width: 375.w,
      child: InkWell(
        onTap:(){print('点击了楼层商品');},
        child:Image.network(goods['image']),
      ),
    );
  }

  Widget _firstRow() {
    return Row (
      children: <Widget>[
        _goodItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodItem(floorGoodsList[1]),
            _goodItem(floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods() {
    return Row(
      children: <Widget>[
         _goodItem(floorGoodsList[3]),
         _goodItem(floorGoodsList[4]),
      ],
    );
  }
}



