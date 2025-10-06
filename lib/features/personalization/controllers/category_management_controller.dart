import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../shop/controllers/category_controller.dart';
import '../../shop/models/category_model.dart';

enum CategoryFilter { all, featured }

class CategoryManagementController extends GetxController
    with GetTickerProviderStateMixin {
  final CategoryController categoryController = Get.find<CategoryController>();

  late TabController tabController;
  final RxBool isLoading = false.obs;

  // New reactive fields
  final RxString searchQuery = ''.obs;
  final Rx<CategoryFilter> selectedFilter = CategoryFilter.all.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    await categoryController.fetchCategories();
    isLoading.value = false;
  }

  Future<void> refreshCategories() async => fetchCategories();

  // Computed lists
  List<CategoryModel> get mainCategories =>
      categoryController.allCategories.where((c) => c.parentId == null).toList();

  List<CategoryModel> get subCategories =>
      categoryController.allCategories.where((c) => c.parentId != null).toList();

  // Filtered + searched categories
  List<CategoryModel> getFilteredCategories(bool isSubcategory) {
    final all = isSubcategory ? subCategories : mainCategories;

    final filtered = selectedFilter.value == CategoryFilter.featured
        ? all.where((c) => c.isFeatured).toList()
        : all;

    if (searchQuery.value.isEmpty) return filtered;

    return filtered
        .where((c) =>
            c.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  void updateSearch(String value) => searchQuery.value = value;
  void updateFilter(CategoryFilter filter) => selectedFilter.value = filter;

  String getParentName(String parentId) =>
      categoryController.getParentName(parentId);

  void deleteCategory(CategoryModel category) {
    categoryController.removeCategory(category.id);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
