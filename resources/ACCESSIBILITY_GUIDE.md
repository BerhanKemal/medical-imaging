# Accessibility Quick Reference

**Multiplatform Mobile Software Engineering in Practice — AGH University of Krakow**

!!! info "Why this page exists"
    The project rubric allocates 15 points for **Industry & Regulatory Awareness**, with accessibility explicitly listed in the top band: *"screen reader support, sufficient contrast, scalable text."* This guide shows you **how** to implement these in Flutter.

---

## Why Accessibility Matters in Mobile Apps

Accessibility is essential for all mobile apps, but especially critical in regulated industries. Health apps serve people who may have visual, motor, or cognitive impairments — including the very conditions the app is designed to help with. A diabetes management app used by elderly patients, or a mental health tracker used during a crisis, **must** be usable by everyone. These examples from mHealth illustrate a universal principle: accessibility is a core quality attribute for any serious mobile application.

For the theoretical background, refer to the Week 5 and Week 6 lecture materials on design principles and regulatory context.

---

## The 5 Things That Matter Most

### 1. Semantic Labels

Screen readers (TalkBack on Android, VoiceOver on iOS) read widget descriptions aloud. Without semantic labels, interactive elements are invisible to blind users.

**Before — invisible to screen readers:**

```dart
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: () => _deleteEntry(entry.id),
)
```

A screen reader announces: *"Button"* — the user has no idea what it does.

**After — accessible:**

```dart
Semantics(
  label: 'Delete mood entry',
  child: IconButton(
    icon: const Icon(Icons.delete),
    onPressed: () => _deleteEntry(entry.id),
  ),
)
```

Now the screen reader announces: *"Delete mood entry, button."*

**Key widgets and properties:**

| Widget / Property | When to Use |
|------------------|-------------|
| `Semantics(label: '...')` | Wrap any widget that needs a screen reader description |
| `Image.asset('...', semanticLabel: 'Patient photo')` | Images that convey meaning |
| `Icon(Icons.add, semanticsLabel: 'Add new entry')` | Icons used as standalone elements |
| `ExcludeSemantics(child: ...)` | Decorative elements that should be **ignored** by screen readers |

!!! tip
    A good test: close your eyes and have someone read only the semantic labels. Can you still use the app?

### 2. Contrast Ratios

Low contrast makes text unreadable for users with low vision — and for everyone in bright sunlight.

**WCAG requirements:**

- **Normal text** (< 18pt): minimum **4.5:1** contrast ratio
- **Large text** (≥ 18pt or 14pt bold): minimum **3:1** contrast ratio

**How to check:**

- Use the [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/) — paste your hex colors and verify the ratio
- In Flutter DevTools, use the **Accessibility Inspector** tab

**Using Flutter's ColorScheme (recommended):**

```dart
ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.teal,
    brightness: Brightness.light,
  ),
  useMaterial3: true,
)
```

`ColorScheme.fromSeed()` generates accessible color combinations automatically. But if you use **custom colors**, you must verify contrast manually.

**Common mistake — custom colors with poor contrast:**

```dart
// BAD: light gray on white — ratio ~1.5:1
Text('Important info', style: TextStyle(color: Color(0xFFBDBDBD)))

// GOOD: dark gray on white — ratio ~7:1
Text('Important info', style: TextStyle(color: Color(0xFF424242)))
```

### 3. Scalable Text

Users with low vision increase their device's text size. If you hardcode font sizes, your layout will break.

**Before — hardcoded, ignores user preferences:**

```dart
Text(
  'Mood Score',
  style: TextStyle(fontSize: 14),
)
```

**After — respects system text scaling:**

```dart
Text(
  'Mood Score',
  style: Theme.of(context).textTheme.bodyMedium,
)
```

Flutter's `TextTheme` automatically responds to the system text scale factor. Using it instead of hardcoded sizes means your text scales gracefully.

**Testing text scaling:**

```dart
// Programmatically check the current scale factor
final textScaler = MediaQuery.textScalerOf(context);
```

On the device: **Settings → Accessibility → Font size** — set it to the maximum and see if your layout still works.

!!! warning
    If text overflows or clips at 200% scale, fix the layout. Use `Flexible`, `Expanded`, or `SingleChildScrollView` to accommodate larger text.

### 4. Touch Targets

Small tap targets are frustrating for everyone and impossible for users with motor impairments.

**Minimum size:** **48×48 dp** (Material Design guideline, also WCAG 2.5.8)

**Before — too small (24×24):**

```dart
IconButton(
  icon: const Icon(Icons.info, size: 16),
  onPressed: () {},
)
```

**After — meets minimum target size:**

```dart
IconButton(
  icon: const Icon(Icons.info),
  onPressed: () {},
  // IconButton already enforces 48x48 minimum by default
)
```

`IconButton`, `ElevatedButton`, and other Material widgets enforce the 48×48 minimum by default. Problems arise when you use `GestureDetector` or `InkWell` on small custom widgets:

```dart
// Ensure custom tap targets meet the minimum
SizedBox(
  width: 48,
  height: 48,
  child: InkWell(
    onTap: () => _showDetails(),
    child: const Icon(Icons.chevron_right),
  ),
)
```

### 5. Meaningful Error States

When an error occurs, sighted users see a red message. Screen reader users need the error **announced** to them.

**Before — visible but silent to screen readers:**

```dart
if (_hasError)
  Text('Failed to save entry', style: TextStyle(color: Colors.red))
```

**After — announced by screen readers:**

```dart
if (_hasError)
  Semantics(
    liveRegion: true,
    child: Text(
      'Failed to save entry. Please check your connection and try again.',
      style: TextStyle(color: Theme.of(context).colorScheme.error),
    ),
  )
```

`liveRegion: true` tells the screen reader to announce this text immediately when it appears — similar to `aria-live="polite"` in web development.

**Tips for error messages:**

- Be specific: *"Failed to save entry"* is better than *"Error"*
- Suggest a fix: *"Please check your connection and try again"*
- Use theme colors (`colorScheme.error`) instead of hardcoded `Colors.red` for proper contrast

---

## Testing Your App

Before presenting your project, walk through these three checks:

### 1. Screen Reader Test

1. **Android:** Settings → Accessibility → TalkBack → On
2. **iOS:** Settings → Accessibility → VoiceOver → On
3. Navigate your entire app using only swipe gestures (TalkBack) or swipe + double-tap (VoiceOver)
4. Can you reach every interactive element? Does every button have a meaningful label?

### 2. Text Scaling Test

1. Go to device Settings → Accessibility → Font size / Display size
2. Set text to the **maximum** size (typically ~200%)
3. Open your app and check every screen:
    - Does text overflow or get clipped?
    - Do layouts break or overlap?
    - Can you still read everything?

### 3. Accessibility Inspector

1. Run your app in debug mode
2. Open Flutter DevTools (in VS Code: `Ctrl+Shift+P` → "Open DevTools")
3. Go to the **Inspector** tab
4. Enable the **Accessibility** overlay
5. Check for warnings about missing labels or insufficient contrast

---

## Checklist for Final Presentation

Use this binary checklist to verify your app's accessibility before presenting. You do **not** need to pass every item, but each "yes" strengthens your Industry & Regulatory Awareness score:

- [ ] All interactive elements (buttons, links, form fields) have semantic labels
- [ ] Decorative images/icons are excluded from the semantics tree
- [ ] Text contrast ratios meet WCAG minimums (4.5:1 for body text)
- [ ] All text uses `TextTheme` or relative sizing (no hardcoded pixel sizes for body text)
- [ ] Touch targets are at least 48×48 dp
- [ ] Error messages are descriptive and announced to screen readers (`liveRegion: true`)
- [ ] The app is navigable using TalkBack or VoiceOver
- [ ] Layout does not break at 200% text scale
- [ ] Color is not the **only** way to convey information (e.g., error states also have icons or text)
- [ ] Form fields have visible labels (not just placeholder text that disappears on focus)

---

## Further Reading

- [Flutter accessibility documentation](https://docs.flutter.dev/ui/accessibility-and-internationalization/accessibility)
- [Material Design accessibility guidelines](https://m3.material.io/foundations/accessible-design/overview)
- [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- [WCAG 2.1 Quick Reference](https://www.w3.org/WAI/WCAG21/quickref/)
