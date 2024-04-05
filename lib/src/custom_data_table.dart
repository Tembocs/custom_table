import 'package:flutter/material.dart';
import 'table_row_data.dart';

class CustomTable extends StatefulWidget {
  final EdgeInsetsGeometry? padding;
  final List<String> columns;
  final List<List<TableRowData>> data;
  final double rowHeight;
  final List<double>? columnWidths;

  const CustomTable({
    super.key,
    required this.columns,
    required this.data,
    this.padding,
    this.rowHeight = 40.0,
    this.columnWidths,
  });

  @override
  State createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  Widget _buildTableHeader() {
    return SizedBox(
      height: widget.rowHeight,
      child: Row(
        children: widget.columns
            .asMap()
            .map((index, columnName) => MapEntry(
                  index,
                  Expanded(
                    flex: _getColumnFlex(index),
                    child: Text(columnName),
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }

  Widget _buildTableRow(List<TableRowData> rowData, int index) {
    return Container(
      height: widget.rowHeight,
      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
      child: Row(
        children: rowData
            .asMap()
            .map((colIndex, cellData) => MapEntry(
                  colIndex,
                  Expanded(
                    flex: _getColumnFlex(colIndex),
                    child: cellData.value,
                  ),
                ))
            .values
            .toList(),
      ),
    );
  }

  // calculate the flex value based on the column width.
  int _getColumnFlex(int index) {
    if (widget.columnWidths == null ||
        widget.columnWidths!.length <= index ||
        widget.columnWidths?[index] == null) {
      return 1;
    }

    return (widget.columnWidths![index] * 100).floor();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 1.0,
          ),
          _buildTableHeader(),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return _buildTableRow(widget.data[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
