import 'package:axpert_space/common/common.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/core.dart';

class PrimaryDropdownField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final TextEditingController? searchController;

  const PrimaryDropdownField({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final borderStyle = OutlineInputBorder(
      borderRadius: BorderRadius.circular(5.r),
      borderSide: const BorderSide(
        color: Colors.blueAccent,
        width: 1,
      ),
    );

    final sController = searchController ?? TextEditingController(); // fallback

    return DropdownButtonFormField2<String>(
      isExpanded: true,
      // ✅ Avoid crash: only assign value if it's inside items
      value: items.contains(value) ? value : null,
      style: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        constraints: BoxConstraints(maxHeight: 40.h),
        filled: true,
        fillColor: Colors.white,
        border: borderStyle,
        enabledBorder: borderStyle,
        focusedBorder: borderStyle.copyWith(
          borderSide: const BorderSide(color: Colors.deepPurple, width: 1),
        ),
        contentPadding: EdgeInsets.only(right: 12.w),
      ),
      dropdownStyleData: DropdownStyleData(
        scrollbarTheme: ScrollbarThemeData(
          radius: Radius.circular(50.r),
          crossAxisMargin: 5,
          mainAxisMargin: 5,
          thumbColor: WidgetStatePropertyAll(Colors.deepPurple),
        ),
        offset: const Offset(0, -10),
        maxHeight: 300.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.chipCardWidgetColorViolet,
            width: 1,
          ),
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
        ),
      ),

// Add Search inside the dropdown
      dropdownSearchData: DropdownSearchData(
        searchController: sController,
        searchInnerWidgetHeight: 35,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: sController,
            builder: (context, valueText, child) {
              return TextFormField(
                controller: sController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey, // border color
                      width: 1, // smaller border width
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: AppColors.chipCardWidgetColorViolet, // border color when focused
                      width: 0.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  filled: true,
                  fillColor: AppColors.primarySearchFieldBGColorGrey,
                  suffixIcon: valueText.text.isEmpty
                      ? const Icon(Icons.search,color: AppColors.snackBarInfoColorGrey,)
                      : GestureDetector(
                          onTap: () {
                            sController.clear();
                          },
                          child: const Icon(CupertinoIcons.clear_circled,color: AppColors.chipCardWidgetColorViolet,),
                        ),
                ),
              );
            },
          ),
        ),
        searchMatchFn: (item, searchValue) {
          return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
        },
      ),

      // Clear search field when dropdown closes
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          sController.clear();
        }
      },

      items: items
          .map((p) => DropdownMenuItem(
                value: p,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: Text(p),
                ),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }
}
