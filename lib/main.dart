import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  SmsQuery query = SmsQuery();

  List<SmsMessage> _messages = [];

  void _incrementCounter() async {
    var permission = await Permission.sms.status;
    if (permission.isGranted) {
      final messages = await query.querySms(
        kinds: [
          SmsQueryKind.inbox,
          SmsQueryKind.sent,
        ],
        // address: 'CANBNK',
        sort: true,
        // count: 20,
      );

      for (var i = 0; i < messages.length; i++) {
        if (messages[i].address!.contains('CANBNK')) {
          // print(messages[i].body!.split(' '));
          RegExp exp = RegExp(r'(\b\d+\.\d+\b)');
          dynamic msg = exp.stringMatch(messages[i].body!);
          print(messages[i].body);
          print(msg);
          // for (final Match m in msg) {
          //   print(messages[i].body);
          //   String match = m[0]!;
          //   print(m[0]);
          // }
        }
      }

      // messages.where((element) {
      //   print('111111');
      //   if (element.body!.startsWith('Dear')) {
      //     print(element);
      //   }

      //   return false;
      // });

      // print('the message is this  ${messages[4]}');
      setState(() => _messages = messages);
      print('2222222');

      // debugPrint('sms inbox messages: ${_messages}');
    } else {
      await Permission.sms.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: _messages.length,
          itemBuilder: (BuildContext context, int i) {
            var message = _messages[i];

            return ListTile(
              title: Text('${message.sender} [${message.date}]'),
              subtitle: Text('${message.body}'),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
