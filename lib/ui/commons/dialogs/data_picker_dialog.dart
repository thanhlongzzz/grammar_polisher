import 'package:flutter/material.dart';

class DataPickerDialog<T> extends StatelessWidget {
  final Function(T) onChanged;
  final Widget Function(T) itemBuilder;
  final Function(String) onChangedSearch;
  final List<T> data;

  const DataPickerDialog({
    super.key,
    required this.onChanged,
    required this.data,
    required this.itemBuilder,
    required this.onChangedSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.all(16),
                ),
                onChanged: onChangedSearch,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: itemBuilder(data[index]),
                      onTap: () {
                        onChanged(data[index]);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
