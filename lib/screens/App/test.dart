import 'package:flutter/material.dart';

class ExView extends StatefulWidget {
  const ExView({Key? key}) : super(key: key);

  @override
  State<ExView> createState() => _ExViewState();
}

class _ExViewState extends State<ExView> {
  @override
  Widget build(BuildContext context) {
    int _index = 0;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stepper(
            currentStep: _index,
            onStepCancel: () {
              if (_index > 0) {
                setState(() {
                  _index -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_index <= 0) {
                setState(() {
                  _index += 1;
                });
              }
            },
            onStepTapped: (int index) {
              setState(() {
                _index = index;
              });
            },
            steps: <Step>[
              Step(
                title: const Text('Order Placed'),
                content: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text('Content for Step 1')),
              ),
              const Step(
                title: Text('Step 2 title'),
                content: Text('Content for Step 2'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
