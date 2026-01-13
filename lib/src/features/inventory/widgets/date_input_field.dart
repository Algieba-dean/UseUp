import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utils/date_formatter.dart'; // Fixed import path
import '../../../config/theme.dart'; // Fixed import path

class DateInputField extends StatefulWidget {
  final String label;
  final Function(DateTime?) onDateChanged;
  final DateTime? initialDate;

  const DateInputField({
    super.key,
    required this.label,
    required this.onDateChanged,
    this.initialDate,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  final _controller = TextEditingController();
  final _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void initState() {
    super.initState();
    if (widget.initialDate != null) {
      _controller.text = _dateFormat.format(widget.initialDate!);
    }
  }

  // 弹出日历
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final firstDate = now.subtract(const Duration(days: 365));
    final lastDate = now.add(const Duration(days: 365 * 10));

    DateTime initial = now;
    try {
      if (_controller.text.isNotEmpty) {
        initial = _dateFormat.parse(_controller.text);
      }
    } catch (_) {}

    // 范围保护
    if (initial.isBefore(firstDate)) initial = firstDate;
    if (initial.isAfter(lastDate)) initial = lastDate;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppTheme.primaryGreen),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final dateStr = _dateFormat.format(picked);
      setState(() {
        _controller.text = dateStr;
      });
      widget.onDateChanged(picked);
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        // 加上轻微阴影，更有质感
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: TextFormField(
        controller: _controller,
        keyboardType: TextInputType.number, // 只要数字键盘
        inputFormatters: [
          DateTextFormatter(), // 自动加杠
        ],
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: 'YYYY-MM-DD',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          border: InputBorder.none, // 去掉默认边框
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_month, color: AppTheme.primaryGreen),
            onPressed: _pickDate,
          ),
        ),
        onChanged: (value) {
          // 只有当输入完整的日期长度时才尝试解析
          if (value.length == 10) {
            try {
              final date = _dateFormat.parseStrict(value);
              widget.onDateChanged(date);
            } catch (_) {
              widget.onDateChanged(null);
            }
          }
        },
      ),
    );
  }
}
