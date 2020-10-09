import 'package:flutter/material.dart';
import './pages/index_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import './provide/counter.dart';
import 'package:provider/provider.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';

void main() {  
  //引入屏幕适配
  WidgetsFlutterBinding.ensureInitialized();
  ScreenUtil.init(designSize: Size(750, 1334), allowFontScaling: true);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Counter()),
        ChangeNotifierProvider(create: (_) => ChildCategory()),
        ChangeNotifierProvider(create: (_) => CategoryGoodsListProvide()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Container(
      child: MaterialApp(
        title:"百姓生活+",
        debugShowCheckedModeBanner: false,
        theme:ThemeData(
          primaryColor:Colors.pink
        ),
        home: IndexPage(),

      )
    );
  }
}
