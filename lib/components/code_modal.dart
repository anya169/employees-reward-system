import 'package:flutter/material.dart';
import '../styles/app_colors.dart';
import '../styles/theme.dart';

class CodeModal extends StatelessWidget {
  final Function(String) onConfirm;

  const CodeModal({
    super.key,
    required this.onConfirm
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Введите код мероприятия",
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Код',
                hintText: 'Введите код',
              ),
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.text,
            ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: AppTheme.primaryButton,
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      onConfirm(controller.text);
                    }
                  },
                  child: Text("Активировать", style: Theme.of(context).textTheme.labelMedium),
                ),

                const SizedBox(width: 12),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: AppTheme.tertiaryButton,
                  child: Text("Отмена", style: Theme.of(context).textTheme.labelMedium,)
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}