import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shoes_store/core/constants/resources.dart';

void main() {
  test('icon_path assets test', () {
    expect(File(IconPath.accountIcon).existsSync(), isTrue);
    expect(File(IconPath.arrowLeft).existsSync(), isTrue);
    expect(File(IconPath.calendar).existsSync(), isTrue);
    expect(File(IconPath.camera).existsSync(), isTrue);
    expect(File(IconPath.chevronDown).existsSync(), isTrue);
    expect(File(IconPath.chevronLeft).existsSync(), isTrue);
    expect(File(IconPath.doublePersenal).existsSync(), isTrue);
    expect(File(IconPath.edit2).existsSync(), isTrue);
    expect(File(IconPath.edit).existsSync(), isTrue);
    expect(File(IconPath.form).existsSync(), isTrue);
    expect(File(IconPath.homeOutline).existsSync(), isTrue);
    expect(File(IconPath.iconApp).existsSync(), isTrue);
    expect(File(IconPath.mapPin).existsSync(), isTrue);
    expect(File(IconPath.money).existsSync(), isTrue);
    expect(File(IconPath.moreVertical).existsSync(), isTrue);
    expect(File(IconPath.nextSvgrepoCom).existsSync(), isTrue);
    expect(File(IconPath.notify).existsSync(), isTrue);
    expect(File(IconPath.personalInfo).existsSync(), isTrue);
    expect(File(IconPath.phone).existsSync(), isTrue);
    expect(File(IconPath.plus).existsSync(), isTrue);
    expect(File(IconPath.projectManagementIcon).existsSync(), isTrue);
    expect(File(IconPath.revenueManagementIcon).existsSync(), isTrue);
    expect(File(IconPath.review).existsSync(), isTrue);
    expect(File(IconPath.salary).existsSync(), isTrue);
    expect(File(IconPath.saleManagementIcon).existsSync(), isTrue);
    expect(File(IconPath.search).existsSync(), isTrue);
    expect(File(IconPath.share2).existsSync(), isTrue);
    expect(File(IconPath.shoes).existsSync(), isTrue);
    expect(File(IconPath.staffManagenment).existsSync(), isTrue);
    expect(File(IconPath.trash2).existsSync(), isTrue);
    expect(File(IconPath.upload).existsSync(), isTrue);
  });
}
