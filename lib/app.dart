import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/bloc/task_bloc.dart';

import 'presentation/screens/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => TaskBloc(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TODO лист',
          theme: ThemeData(
            colorScheme: ColorScheme.light(
                primary: Colors.grey.shade100,
                background: const Color(0xFFF7F6F2)),
            useMaterial3: true,
          ),
          home: const HomePage(),
        ),
      );
}
