import 'package:flutter/material.dart';
import 'package:gyanbuddy/utils/constants.dart';
import 'package:gyanbuddy/widgets/drawer.dart';

import '../../utils/const_dimensions.dart';

class ShapesPage extends StatelessWidget {
  const ShapesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppConstants.shape,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 0, 187, 238),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/shape.gif',
            ),
            const SizedBox(height: ConstantDimensions.heightMedium),
            const Text(
              AppConstants.underConstruction,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
