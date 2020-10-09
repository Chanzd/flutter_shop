import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provide/counter.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: Text('${context.watch<Counter>().value}',style: Theme.of(context).textTheme.headline4,)
      )
    );
  }
}