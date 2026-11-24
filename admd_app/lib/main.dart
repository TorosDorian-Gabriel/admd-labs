import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:admd_app/screens/todo_screen.dart';
import 'package:admd_app/todos/bloc/todo_bloc.dart';
import 'package:admd_app/todos/bloc/todo_event.dart';
import 'package:admd_app/todos/todo_repository.dart';

void main() {
  final repo = TodoRepository(Dio());
  runApp(
    BlocProvider(
      create: (_) => TodoBloc(repo)..add(LoadTodos()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoScreen(),
    );
  }
}