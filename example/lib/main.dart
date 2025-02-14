import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_spinner_item_selector/flutter_spinner_item_selector.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlipCard',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF006666),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FlipCardController _controller;

  bool skewed = false;

  @override
  void initState() {
    super.initState();
    _controller = FlipCardController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FlipCard'),
      ),
      body: SizedBox(
        height: 600,
        width: double.infinity,
        child: SpinnerItemSelector<Widget>(
          items: [_buildCard(context), _buildCard(context)],
          height: 600,
          width: double.infinity,
          itemHeight: 500,
          itemWidth: 600,
          selectedItemToWidget: (item) {
            return item;
          },
          nonSelectedItemToWidget: (item) {
            return item;
          },
          onSelectedItemChanged: (item) {
            //return item;
          },
          spinnerBgColor: Colors.greenAccent,
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 3.0,
        surfaceTintColor: theme.colorScheme.surfaceTint,
        child: SafeArea(
          child: SizedBox(
            height: 90.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () => _controller.flip(),
                    child: const Text('Toggle'),
                  ),
                  FilledButton.icon(
                    onPressed: () async {
                      await _controller.skew(skewed ? 0.0 : 0.2);
                      setState(() => skewed = !skewed);
                    },
                    icon: skewed
                        ? const Icon(Icons.circle)
                        : const Icon(Icons.circle_outlined),
                    label: const Text('Skew'),
                  ),
                  FilledButton(
                    onPressed: () async => await _controller.hint(),
                    child: const Text('Hint'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);

    final titleStyle = theme.textTheme.displayLarge
        ?.copyWith(color: theme.colorScheme.onPrimary);
    final paragraphStyle =
        theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onPrimary);

    return FlipCard(
      direction: Axis.horizontal,
      initialSide: CardSide.front,
      duration: const Duration(milliseconds: 1000),
      controller: _controller,
      onFlipDone: (status) {
        debugPrint(status.toString());
      },
      front: Card(
        color: theme.colorScheme.primary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Front', style: titleStyle),
            Text('Click here to flip back', style: paragraphStyle),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () => _showMessage(context, 'Clicked button on front'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Click me!'),
            ),
          ],
        ),
      ),
      back: Card(
        color: theme.colorScheme.secondary,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Back',
              style: theme.textTheme.displayLarge
                  ?.copyWith(color: theme.colorScheme.onSecondary),
            ),
            Text(
              'Click here to flip front',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(color: theme.colorScheme.onSecondary),
            ),
            const SizedBox(height: 16.0),
            OutlinedButton(
              onPressed: () => _showMessage(context, 'Clicked button on back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              child: const Text('Click me!'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
