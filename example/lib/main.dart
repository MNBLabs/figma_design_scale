import 'package:flutter/material.dart';
import 'package:figma_design_scale/figma_design_scale.dart';

void main() => runApp(const Demo());

class Demo extends StatelessWidget {
  const Demo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (ctx) {
          final ds = DesignScale.of(ctx); // defaults 440x956
          return Scaffold(
            appBar: AppBar(
              title: Text('DesignScale Demo',
                  style: TextStyle(fontSize: ds.sp(18))),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(ds.sx(16)),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(ds.sx(16)),
                ),
                child: Text('Hello scaled world!',
                    style: TextStyle(fontSize: ds.sp(20))),
              ),
            ),
          );
        },
      ),
    );
  }
}
