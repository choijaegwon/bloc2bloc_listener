import 'package:bloc2bloc_listener/blocs/color/color_bloc.dart';
import 'package:bloc2bloc_listener/blocs/counter/counter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ColorBloc>(
          create: (context) => ColorBloc(),
        ),
        BlocProvider<CounterBloc>(
          create: (context) => CounterBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'bloc2bloc listener',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int incrementSize = 1;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ColorBloc, ColorState>(
      listener: (context, colorState) {
        if (colorState.color == Colors.red) {
          incrementSize = 1;
        } else if (colorState.color == Colors.green) {
          incrementSize = 10;
        } else if (colorState.color == Colors.blue) {
          incrementSize = 100;
        } else if (colorState.color == Colors.black) {
          incrementSize = -100;
          context
              .read<CounterBloc>()
              .add(ChangeCounterEvent(incrementSize: incrementSize));
        }
      },
      child: Scaffold(
        backgroundColor: context.watch<ColorBloc>().state.color,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text(
                  'Change Color',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  context.read<ColorBloc>().add(ChangeColorEvent());
                },
              ),
              SizedBox(height: 20),
              Text(
                '${context.watch<CounterBloc>().state.counter}',
                style: TextStyle(
                    fontSize: 52,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(
                  'Increment Color',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  context
                      .read<CounterBloc>()
                      .add(ChangeCounterEvent(incrementSize: incrementSize));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
