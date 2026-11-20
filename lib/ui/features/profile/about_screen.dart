import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../core/format.dart';

/// Hakkında: lisans ve atıflar. BodyParts3D atfı CC BY 4.0 gereğidir (D37).
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget block(IconData icon, String title, List<Widget> body) => Padding(
      padding: const EdgeInsets.only(bottom: Gap.xl),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: Gap.l),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium),
                const SizedBox(height: Gap.xs),
                ...body,
              ],
            ),
          ),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.aboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(Gap.l),
        children: [
          block(Symbols.code_rounded, l.appTitle, [Text(l.aboutAppBody)]),
          block(Symbols.psychology_rounded, l.aboutModelTitle, [
            Text(l.aboutModelBody),
            const SizedBox(height: Gap.s),
            SelectableText(
              '${l.aboutModelCredit}\n'
              'https://creativecommons.org/licenses/by/4.0/\n'
              'https://dbarchive.biosciencedbc.jp/en/bodyparts3d/',
              style: theme.textTheme.bodySmall,
            ),
          ]),
          block(Symbols.view_in_ar_rounded, 'Three.js', [
            Text(l.aboutThreeBody),
          ]),
          block(Symbols.text_fields_rounded, l.aboutFontsTitle, [
            Text(l.aboutFontsBody),
            const SizedBox(height: Gap.s),
            Text(
              embeddedFonts.map((f) => f.$1).join('\n'),
              style: theme.textTheme.bodySmall,
            ),
          ]),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              icon: const Icon(Symbols.description_rounded),
              label: Text(l.aboutLicenses),
              onPressed: () => showLicensePage(
                context: context,
                applicationName: l.appTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
