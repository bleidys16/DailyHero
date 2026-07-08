import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/theme.dart';
import '../../../models/habit.dart';
import '../../../providers/habit_provider.dart';
import '../../../utils/habit_ui.dart';

/// Hoja inferior para crear un nuevo hábito / misión.
class AddHabitSheet extends ConsumerStatefulWidget {
  const AddHabitSheet({Key? key}) : super(key: key);

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const AddHabitSheet(),
    );
  }

  @override
  ConsumerState<AddHabitSheet> createState() => _AddHabitSheetState();
}

class _AddHabitSheetState extends ConsumerState<AddHabitSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  HabitFrequency _frequency = HabitFrequency.daily;
  HabitDifficulty _difficulty = HabitDifficulty.medium;
  HabitCategory _category = HabitCategory.health;
  double _xpReward = 50;
  bool _saving = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(habitNotifierProvider.notifier).createHabit(
            title: _titleCtrl.text.trim(),
            description:
                _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
            frequency: _frequency,
            difficulty: _difficulty,
            category: _category,
            xpReward: _xpReward.toInt(),
          );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo crear el hábito: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('Nuevo hábito',
                  style: AppTheme.pixel.copyWith(
                      fontSize: 18, color: AppColors.textPrimary)),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ej: Ir al gimnasio',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ingresa un título' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descCtrl,
              decoration: const InputDecoration(
                labelText: 'Descripción (opcional)',
              ),
            ),
            const SizedBox(height: 16),
            _Label('Categoría'),
            Wrap(
              spacing: 8,
              children: HabitCategory.values.map((c) {
                final selected = _category == c;
                return ChoiceChip(
                  label: Text(HabitUi.categoryLabel(c)),
                  avatar: Icon(HabitUi.categoryIcon(c),
                      size: 16,
                      color: selected ? Colors.white : HabitUi.categoryColor(c)),
                  selected: selected,
                  selectedColor: HabitUi.categoryColor(c),
                  backgroundColor: AppColors.surface,
                  onSelected: (_) => setState(() => _category = c),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _Label('Dificultad'),
            Wrap(
              spacing: 8,
              children: HabitDifficulty.values.map((d) {
                final selected = _difficulty == d;
                return ChoiceChip(
                  label: Text(HabitUi.difficultyLabel(d)),
                  selected: selected,
                  selectedColor: HabitUi.difficultyColor(d),
                  backgroundColor: AppColors.surface,
                  onSelected: (_) => setState(() => _difficulty = d),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            _Label('Frecuencia'),
            Wrap(
              spacing: 8,
              children: HabitFrequency.values.map((f) {
                final selected = _frequency == f;
                return ChoiceChip(
                  label: Text(HabitUi.frequencyLabel(f)),
                  selected: selected,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onSelected: (_) => setState(() => _frequency = f),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _Label('Recompensa base: ${_xpReward.toInt()} XP'),
              ],
            ),
            Slider(
              value: _xpReward,
              min: 10,
              max: 200,
              divisions: 19,
              activeColor: AppColors.xp,
              label: '${_xpReward.toInt()}',
              onChanged: (v) => setState(() => _xpReward = v),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Crear hábito'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.textMuted, fontWeight: FontWeight.w600)),
    );
  }
}
