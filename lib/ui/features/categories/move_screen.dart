import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../core/format.dart';
import '../../core/states.dart';
import 'category_tree_screen.dart';

/// Sürükle-bırakın erişilebilir karşılığı: hedefi listeden seçerek taşıma.
class MoveScreen extends ConsumerWidget {
  const MoveScreen({super.key, required this.isCategory, required this.id});

  final bool isCategory;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final roots = ref.watch(rootCategoriesProvider);
    final cats = ref.watch(categoriesProvider).value ?? const <UserCategory>[];
    final data = ref.watch(planDataProvider).value;
    final name = isCategory
        ? cats.where((c) => c.id == id).firstOrNull?.name
        : data?.activities[id]?.title;
    // Kategori kendi alt dalına taşınamaz: alt ağaç listeden çıkarılır.
    final blocked = <String>{};
    if (isCategory) {
      blocked.add(id);
      var grew = true;
      while (grew) {
        grew = false;
        for (final c in cats) {
          if (c.parentId != null &&
              blocked.contains(c.parentId) &&
              blocked.add(c.id)) {
            grew = true;
          }
        }
      }
    }
    Future<void> move(String root, String? categoryId) async {
      await moveItem(
        context,
        ref,
        (isCategory: isCategory, id: id, name: name ?? ''),
        root: root,
        categoryId: categoryId,
      );
      if (context.mounted) context.pop();
    }

    return Scaffold(
      appBar: AppBar(title: Text(l.moveTitle)),
      body: AsyncView<List<RootCategory>>(
        value: roots,
        onRetry: () => ref.invalidate(rootCategoriesProvider),
        data: (roots) {
          List<Widget> branch(String? parent, String root, int depth) => [
            for (final c in cats)
              if (c.parentId == parent &&
                  c.rootCategoryKey == root &&
                  !blocked.contains(c.id)) ...[
                ListTile(
                  contentPadding: EdgeInsetsDirectional.only(
                    start: Gap.l + depth * Gap.xl,
                    end: Gap.l,
                  ),
                  leading: const ExcludeSemantics(
                    child: Icon(Symbols.folder_rounded),
                  ),
                  title: Text(c.name),
                  onTap: () => move(root, c.id),
                ),
                ...branch(c.id, root, depth + 1),
              ],
          ];
          return ListView(
            children: [
              for (final r in roots) ...[
                ListTile(
                  leading: RootBadge(
                    rootKey: r.key,
                    icon: r.icon,
                    color: r.color,
                    size: 32,
                  ),
                  title: Text(r.name(context)),
                  onTap: () => move(r.key, null),
                ),
                ...branch(null, r.key, 1),
              ],
            ],
          );
        },
      ),
    );
  }
}
