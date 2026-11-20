import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/format.dart';
import '../../core/states.dart';

/// Kategori ağacından seçim; seçili düğümün altına satır içinde yeni alt kategori açılır.
class CategoryPicker extends ConsumerStatefulWidget {
  const CategoryPicker({
    super.key,
    required this.categoryId,
    required this.rootKey,
    required this.onChanged,
  });

  final String? categoryId;
  final String? rootKey;
  final void Function(String? categoryId, String? rootKey) onChanged;

  @override
  ConsumerState<CategoryPicker> createState() => _CategoryPickerState();
}

class _CategoryPickerState extends ConsumerState<CategoryPicker> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  // Seçim tek değerde: '' = kategorisiz, 'root:<anahtar>', 'cat:<kimlik>'.
  String get _selected => widget.categoryId != null
      ? 'cat:${widget.categoryId}'
      : widget.rootKey != null
      ? 'root:${widget.rootKey}'
      : '';

  void _select(String? v) {
    if (v == null) return;
    if (v.startsWith('cat:')) return widget.onChanged(v.substring(4), null);
    if (v.startsWith('root:')) return widget.onChanged(null, v.substring(5));
    widget.onChanged(null, null);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final roots = ref.watch(rootCategoriesProvider);
    final cats = ref.watch(categoriesProvider);
    return AsyncView(
      value: roots,
      onRetry: () => ref.invalidate(rootCategoriesProvider),
      data: (roots) {
        final all = cats.value ?? const <UserCategory>[];
        List<Widget> children(String? parent, String root, int depth) => [
          for (final c in all)
            if (c.parentId == parent && c.rootCategoryKey == root) ...[
              _tile(value: 'cat:${c.id}', label: c.name, depth: depth),
              ...children(c.id, root, depth + 1),
            ],
        ];
        return RadioGroup<String>(
          groupValue: _selected,
          onChanged: _select,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _tile(value: '', label: l.wizCategoryNone, depth: 0),
              for (final r in roots) ...[
                _tile(
                  value: 'root:${r.key}',
                  label: r.name(context),
                  depth: 0,
                  leading: RootBadge(
                    rootKey: r.key,
                    icon: r.icon,
                    color: r.color,
                    size: 32,
                  ),
                ),
                ...children(null, r.key, 1),
              ],
              if (_selected.isNotEmpty) ...[
                const SizedBox(height: Gap.l),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _name,
                        maxLength: 100,
                        decoration: InputDecoration(
                          labelText: l.wizSubcategoryName,
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: Gap.s),
                    BusyButton(
                      tonal: true,
                      label: l.wizNewSubcategory,
                      onPressed: _name.text.trim().isEmpty ? null : _create,
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Future<void> _create() => guard(context, () async {
    final c = await ref
        .read(categoryRepositoryProvider)
        .create(
          name: _name.text.trim(),
          parentId: widget.categoryId,
          rootCategoryKey: widget.categoryId == null ? widget.rootKey : null,
        );
    _name.clear();
    widget.onChanged(c.id, null);
  });

  Widget _tile({
    required String value,
    required String label,
    required int depth,
    Widget? leading,
  }) => Padding(
    padding: EdgeInsets.only(left: depth * Gap.xl),
    child: RadioListTile<String>(
      value: value,
      title: Text(label),
      secondary:
          leading ??
          (depth > 0
              ? const ExcludeSemantics(
                  child: Icon(Symbols.subdirectory_arrow_right_rounded),
                )
              : null),
    ),
  );
}
