import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shoes_store/core/constants/resources.dart';

void main() {
  test('product_path assets test', () {
    expect(File(ProductPath.adidasUltraboost22).existsSync(), isTrue);
    expect(File(ProductPath.converseChuckTaylorAllStar).existsSync(), isTrue);
    expect(File(ProductPath.pumaRsX3).existsSync(), isTrue);
    expect(File(ProductPath.vansOldSkool).existsSync(), isTrue);
    expect(File(ProductPath.background).existsSync(), isTrue);
    expect(File(ProductPath.defaulUser).existsSync(), isTrue);
    expect(File(ProductPath.nikeairmax270).existsSync(), isTrue);
  });
}
