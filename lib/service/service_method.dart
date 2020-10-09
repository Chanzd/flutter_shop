import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

Future request(url,{formData}) async {
  try{
    print('开始获取数据.........');
    Response response;
    Dio dio = new Dio();
    dio.options.contentType = 'appLication/x-www-form-urlencoded';
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port){
        return true;
      };
    };
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url],data: formData);
    }
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检查代码和服务器情况。。。。。。');
    }
  }catch (e){
    return print('ERROR:======> ${e}');
  }
}

Future getHomePageContent() async {
  try {
    print('开始获取首页数据.........');
    Response response;
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port){
            return true;
        };
    };
    var formData = {'lon':115.02932,'lat':35.76189};
    response = await dio.post(servicePath['homePageContext'],data:formData);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检查代码和服务器情况。。。。。。');
    }
  } catch(e) {
    return print('ERROR:======> ${e}');
  }
}

Future getHomePageBelowConten() async {
  try{
    print('开始获取下拉列表数据。。。。。。');
    Response response;
    Dio dio = new Dio();
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate  = (client) {
        client.badCertificateCallback = (X509Certificate cert, String host, int port){
            return true;
        };
    };
    int page = 1;
    response = await dio.post(servicePath['homePageBelowConten'],data:page);
    if(response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检查代码和服务器情况。。。。。。');
    }
  }catch(e){
    return print('ERROR:======>${e}');
  }
}