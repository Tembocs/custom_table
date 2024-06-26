import 'package:flutter/material.dart';
import 'table_row_data.dart';

class CustomTable extends StatefulWidget {
  final EdgeInsetsGeometry tablePadding;
  final EdgeInsetsGeometry cellPadding;
  final List<String> columns;
  final List<List<TableRowData>> data;
  final double rowHeight;
  final List<double> columnWidths;
  final bool showVerticalDivider;
  final bool boldHeaderLabels;

  const CustomTable({
    super.key,
    required this.columns,
    required this.data,
    this.tablePadding = EdgeInsets.zero,
    this.cellPadding = const EdgeInsets.only(left: 10.0),
    this.rowHeight = 40.0,
    this.columnWidths = const [],
    this.showVerticalDivider = false,
    this.boldHeaderLabels = true,
  });

  CustomTable.fromMapList({
    super.key,
    required List<String> columns,
    required List<Map<String, String>> mapList,
    EdgeInsetsGeometry tablePadding = EdgeInsets.zero,
    EdgeInsetsGeometry cellPadding = const EdgeInsets.only(left: 10.0),
    double rowHeight = 40.0,
    List<double> columnWidths = const [],
    this.showVerticalDivider = false,
    this.boldHeaderLabels = true,
  })  : this.tablePadding = tablePadding,
        this.cellPadding = cellPadding,
        this.rowHeight = rowHeight,
        this.columnWidths = columnWidths,
        this.columns = columns,
        this.data = mapList.map((aMap) {
          return aMap.entries.map((entry) {
            return TableRowData(entry.key, Text(entry.value));
          }).toList();
        }).toList();

  @override
  State createState() => _CustomTableState();
}

class _CustomTableState extends State<CustomTable> {
  Widget _buildTableHeader() {
    List<Widget> headerChildren = [];

    for (int i = 0; i < widget.columns.length; i++) {
      if (widget.showVerticalDivider && i > 0) {
        // Add a vertical divider before each header cell except the first
        headerChildren.add(
          const VerticalDivider(
            color: Colors.grey,
            width: 0.5,
            thickness: 0.5,
          ),
        );
      }
      // Add the header cell
      headerChildren.add(Expanded(
        flex: _getColumnFlex(i),
        child: Padding(
          padding: widget.cellPadding,
          child: Text(widget.columns[i],
              style: TextStyle(
                fontWeight: widget.boldHeaderLabels
                    ? FontWeight.bold
                    : FontWeight.normal,
              )),
        ),
      ));
    }

    return SizedBox(
      height: widget.rowHeight,
      child: Row(children: headerChildren),
    );
  }

  Widget _buildTableRow(List<TableRowData> rowData, int index) {
    List<Widget> rowChildren = [];

    for (int i = 0; i < rowData.length; i++) {
      if (widget.showVerticalDivider && i > 0) {
        // Add a vertical divider before each cell except the first
        rowChildren.add(
          const VerticalDivider(
            color: Colors.grey,
            width: 0.5,
            thickness: 0.5,
          ),
        );
      }
      // Add the cell
      rowChildren.add(Expanded(
        flex: _getColumnFlex(i),
        child: Padding(
          padding: widget.cellPadding,
          child: rowData[i].value,
        ),
      ));
    }

    return Container(
      height: widget.rowHeight,
      color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
      child: Row(children: rowChildren),
    );
  }

  int _getColumnFlex(int index) {
    if (index < widget.columnWidths.length) {
      return (widget.columnWidths[index] * 100).floor();
    }

    // Default flex value
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.tablePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 0.5,
          ),
          _buildTableHeader(),
          const Divider(
            color: Colors.grey,
            thickness: 0.5,
            height: 0.5,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                return _buildTableRow(widget.data[index], index);
              },
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey,
                thickness: 0.5,
                height: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


/*
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

  // New constructor for handling List<Map<String, String>> data.
  CustomTable.fromMapList({
    super.key,
    required List<String> columns,
    required List<Map<String, String>> mapList,
    EdgeInsetsGeometry? padding,
    double rowHeight = 40.0,
    List<double>? columnWidths,
  })  : this.padding = padding,
        this.rowHeight = rowHeight,
        this.columnWidths = columnWidths,
        this.columns = columns,
        this.data = mapList.map((aMap) {
          return aMap.entries.map((entry) {
            // Creating a TableRowData for each entry
            return TableRowData(entry.key, Text(entry.value));
          }).toList();
        }).toList();

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
*/
