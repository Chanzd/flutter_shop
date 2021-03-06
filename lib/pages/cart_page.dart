

import 'package:flutter/material.dart';
import '../provide/counter.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Column(
         children: <Widget>[
           Number(),
           MyButton()
         ],
        ),
      )
    );
  }
}

class Number extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Text('${context.watch<Counter>().value}',style: 
    Theme.of(context).textTheme.headline4,);
  }
}

class MyButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child:RaisedButton(
        onPressed: (){
          context.read<Counter>().increment();
        },
        child: Text('递增'),
      )
    );
  }
}