import 'package:fitelo_assignment/constants/app_constants.dart';
import 'package:fitelo_assignment/features/weight_picker/widgets/circular_scale_picker/circular_scale_picker.dart';
import 'package:flutter/material.dart';

class WeightPickerScreen extends StatelessWidget {
  const WeightPickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              weightPickerAppBarrTitle,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: CircularScalePicker(
                min: 0,
                initialValue: 70,
                radius: (constraints.maxWidth / 2.4).clamp(
                  0,
                  constraints.maxHeight - 80,
                ),
                itemExtent: 24,
                visibleItemCount: 41,
                onChanged: (val) {},
              ),
            );
          },
        ),
      ),
    );
  }
}
