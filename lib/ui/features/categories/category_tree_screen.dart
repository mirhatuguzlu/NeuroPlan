import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/providers.dart';
import '../../../app/theme.dart';
import '../../../data/local/app_database.dart';
import '../../../data/repositories/category_repository.dart';
import '../../core/app_shell.dart';
import '../../core/format.dart';
import '../../core/states.dart';

/// Sürüklenen öğe: kategori ya da iş.
typedef Dragged = ({bool isCategory, String id, String name});

/// Taşıma işlemi; sürükle-bırak ve "Taşı" ekranı aynı yolu kullanır.
Future<void> moveItem(
  BuildContext context,
  WidgetRef ref,
  Dragged item, {
  required String root,
  String? categoryId,
}) async {
  final l = context.l10n;
  try {
    if (item.isCategory) {
      if (item.id == categoryId) throw ArgumentError();
      await ref
          .read(categoryRepositoryProvider)
          .move(item.id, newParentId: categoryId, newRootCategoryKey: root);
    } else {
      await ref
          .read(activityRepositoryProvider)
          .update(
            item.id,
            ActivitiesCompanion(
              categoryId: Value(categoryId),
              rootCategoryKey: Value(categoryId == null ? root : null),
            ),
          );
    }
    if (context.mounted) showSnack(context, l.catMoved(item.name));
  } on ArgumentError {
    if (context.mounted) showSnack(context, l.moveCannotIntoSelf);
  } catch (e) {
    if (context.mounted) showSnack(context, l.saveError);
  }
}

/// Beyin sekmesi (bu aşamada): kök kategoriler, kullanıcının ağacı ve her kökün çalıştırdığı
/// beyin bölgeleri + kanıt düzeyi. Bu liste ileride 3D sahnenin metin alternatifidir.
class CategoryTreeScreen extends ConsumerWidget {
  const CategoryTreeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final roots = ref.watch(rootCategoriesProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l.brainTitle)),
      body: AsyncView<List<RootCategory>>(
        value: roots,
        onRetry: () => ref.invalidate(rootCategoriesProvider),
        data: (roots) => ListView(
          padding: EdgeInsets.fromLTRB(
            Gap.l,
            0,
            Gap.l,
            AppShell.bottomInset(context),
          ),
          children: [
            Text(l.brainIntro, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: Gap.s),
            Text(l.catDragHint, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: Gap.l),
            for (final r in roots)
              Padding(
                padding: const EdgeInsets.only(bottom: Gap.m),
                child: _RootCard(root: r),
              ),
          ],
        ),
      ),
    );
  }
}

class _RootCard extends ConsumerStatefulWidget {
  const _RootCard({required this.root});

  final RootCategory root;

  @override
  ConsumerState<_RootCard> createState() => _RootCardState();
}

class _RootCardState extends ConsumerState<_RootCard> {
  var _open = false;
  var _science = false;

  /// Satır içi "alt kategori ekle" alanının açık olduğu düğüm ('' = kök).
  String? _addingUnder;
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final under = _addingUnder;
    final ok = await guard(
      context,
      () => ref
          .read(categoryRepositoryProvider)
          .create(
            name: _name.text.trim(),
            parentId: under == '' ? null : under,
            rootCategoryKey: under == '' ? widget.root.key : null,
          ),
    );
    if (ok) {
      _name.clear();
      setState(() => _addingUnder = null);
    }
  }

  Future<void> _delete(UserCategory c) async {
    final l = context.l10n;
    try {
      await ref.read(categoryRepositoryProvider).delete(c.id);
      if (!mounted) return;
      showSnack(
        context,
        l.itemDeleted(c.name),
        actionLabel: l.commonUndo,
        onAction: () => ref
            .read(writerProvider)
            .update(
              ref.read(databaseProvider).userCategories,
              c.id,
              const UserCategoriesCompanion(deletedAt: Value(null)),
            ),
      );
    } on CategoryInUseException {
      if (mounted) showSnack(context, l.catInUse);
    } catch (_) {
      if (mounted) showSnack(context, l.saveError);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final root = widget.root;
    final cats = ref.watch(categoriesProvider).value ?? const <UserCategory>[];
    final activities =
        ref.watch(planDataProvider).value?.activities.values.toList() ??
        const <Activity>[];

    List<Widget> branch(String? parent, int depth) => [
      for (final c in cats)
        if (c.parentId == parent && c.rootCategoryKey == root.key) ...[
          _NodeTile(
            item: (isCategory: true, id: c.id, name: c.name),
            depth: depth,
            icon: Symbols.folder_rounded,
            onDrop: (d) =>
                moveItem(context, ref, d, root: root.key, categoryId: c.id),
            actions: [
              IconButton(
                tooltip: l.catAddSub,
                icon: const Icon(Symbols.add_rounded),
                onPressed: () => setState(() => _addingUnder = c.id),
              ),
              IconButton(
                tooltip: l.commonDelete,
                icon: const Icon(Symbols.delete_rounded),
                onPressed: () => _delete(c),
              ),
            ],
          ),
          if (_addingUnder == c.id) _addField(depth + 1),
          for (final a in activities)
            if (a.categoryId == c.id)
              _NodeTile(
                item: (isCategory: false, id: a.id, name: a.title),
                depth: depth + 1,
                icon: Symbols.circle_rounded,
              ),
          ...branch(c.id, depth + 1),
        ],
    ];

    final tree = [
      for (final a in activities)
        if (a.categoryId == null && a.rootCategoryKey == root.key)
          _NodeTile(
            item: (isCategory: false, id: a.id, name: a.title),
            depth: 0,
            icon: Symbols.circle_rounded,
          ),
      ...branch(null, 0),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DragTarget<Dragged>(
            onAcceptWithDetails: (d) =>
                moveItem(context, ref, d.data, root: root.key),
            builder: (context, candidates, _) => Container(
              color: candidates.isEmpty
                  ? null
                  : theme.colorScheme.secondaryContainer,
              child: MergeSemantics(
                child: ListTile(
                  minTileHeight: 72,
                  leading: RootBadge(icon: root.icon, color: root.color),
                  title: Text(
                    root.name(context),
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(root.description(context)),
                  trailing: ExcludeSemantics(
                    child: Icon(
                      _open
                          ? Symbols.expand_less_rounded
                          : Symbols.expand_more_rounded,
                    ),
                  ),
                  onTap: () => setState(() => _open = !_open),
                ),
              ),
            ),
          ),
          AnimatedSize(
            duration: AppTokens.duration(context, Durations.medium2),
            curve: AppTokens.of(context).standardCurve,
            child: !_open
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(bottom: Gap.s),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: const ExcludeSemantics(
                            child: Icon(Symbols.science_rounded),
                          ),
                          title: Text(l.brainRegionsTitle),
                          trailing: ExcludeSemantics(
                            child: Icon(
                              _science
                                  ? Symbols.expand_less_rounded
                                  : Symbols.expand_more_rounded,
                            ),
                          ),
                          onTap: () => setState(() => _science = !_science),
                        ),
                        if (_science) _Regions(rootKey: root.key),
                        const Divider(),
                        if (tree.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: Gap.l,
                            ),
                            child: Text(l.catEmpty),
                          ),
                        ...tree,
                        if (_addingUnder == '')
                          _addField(0)
                        else
                          Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: Gap.s,
                              ),
                              child: TextButton.icon(
                                icon: const Icon(Symbols.add_rounded),
                                label: Text(l.catAddSub),
                                onPressed: () =>
                                    setState(() => _addingUnder = ''),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _addField(int depth) => Padding(
    padding: EdgeInsets.fromLTRB(Gap.l + depth * Gap.l, Gap.s, Gap.l, Gap.s),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _name,
            autofocus: true,
            maxLength: 100,
            decoration: InputDecoration(labelText: context.l10n.catName),
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _name.text.trim().isEmpty ? null : _add(),
          ),
        ),
        const SizedBox(width: Gap.s),
        IconButton(
          tooltip: context.l10n.commonClose,
          icon: const Icon(Symbols.close_rounded),
          onPressed: () => setState(() => _addingUnder = null),
        ),
        BusyButton(
          tonal: true,
          label: context.l10n.actionAdd,
          onPressed: _name.text.trim().isEmpty ? null : _add,
        ),
      ],
    ),
  );
}

/// Ağaçtaki düğüm: basılı tutup sürüklenir; kategoriyse üstüne bırakılabilir.
class _NodeTile extends ConsumerWidget {
  const _NodeTile({
    required this.item,
    required this.depth,
    required this.icon,
    this.onDrop,
    this.actions = const [],
  });

  final Dragged item;
  final int depth;
  final IconData icon;
  final void Function(Dragged)? onDrop;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    Widget tile(bool highlighted) => Container(
      color: highlighted ? scheme.secondaryContainer : null,
      padding: EdgeInsetsDirectional.only(start: depth * Gap.l),
      child: ListTile(
        leading: ExcludeSemantics(
          child: Icon(icon, size: item.isCategory ? 24 : 12),
        ),
        title: Text(item.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: l.catMove,
              icon: const Icon(Symbols.drive_file_move_rounded),
              onPressed: () => context.push(
                '/move/${item.isCategory ? 'category' : 'activity'}/${item.id}',
              ),
            ),
            ...actions,
          ],
        ),
      ),
    );
    final draggable = LongPressDraggable<Dragged>(
      data: item,
      feedback: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
        child: Padding(
          padding: const EdgeInsets.all(Gap.m),
          child: Text(item.name),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.4, child: tile(false)),
      child: tile(false),
    );
    if (onDrop == null) return draggable;
    return DragTarget<Dragged>(
      onWillAcceptWithDetails: (d) => d.data.id != item.id,
      onAcceptWithDetails: (d) => onDrop!(d.data),
      builder: (_, candidates, _) => candidates.isEmpty
          ? draggable
          : LongPressDraggable<Dragged>(
              data: item,
              feedback: const SizedBox.shrink(),
              child: tile(true),
            ),
    );
  }
}

class _Regions extends ConsumerWidget {
  const _Regions({required this.rootKey});

  final String rootKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = context.l10n;
    final weights = ref.watch(regionWeightsProvider(rootKey));
    final regions = ref.watch(brainRegionsProvider).value ?? const {};
    return AsyncView(
      value: weights,
      skeletonRows: 2,
      onRetry: () => ref.invalidate(regionWeightsProvider(rootKey)),
      data: (list) => Column(
        children: [
          for (final w in [
            ...list,
          ]..sort((a, b) => b.weight.compareTo(a.weight)))
            MergeSemantics(
              child: ListTile(
                dense: true,
                contentPadding: const EdgeInsetsDirectional.only(
                  start: Gap.xxl * 2,
                  end: Gap.l,
                ),
                title: Text(regions[w.regionKey]?.name(context) ?? w.regionKey),
                subtitle: Text(
                  [
                    l.evidenceLevel(w.evidenceLevel),
                    if (w.sourceIds.isNotEmpty)
                      l.evidenceSources(w.sourceIds.join(', ')),
                  ].join(' · '),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
