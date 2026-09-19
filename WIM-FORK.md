# WIM fork

Standalone fork of the published `react-native-enriched-markdown` package for [WIM](https://github.com/junko2013/wim).

## Upstream

- Monorepo: [software-mansion/enriched-markdown](https://github.com/software-mansion/enriched-markdown)
- Base npm version: `1.1.0-nightly-20260912-4c1270f48`

## WIM changes

1. **MD4C parser** — disable raw HTML; render image spans as links (no external image fetch in messages).
2. **Custom emoji input (iOS)** — `insertCustomEmoji`, `syncCustomEmojis`, `setPlainText` on `EnrichedMarkdownTextInput` with inline `NSTextAttachment` and post-format reapply.

Android stubs the new commands; WIM mobile falls back to overlay on Android.

## Versioning

Fork releases use `1.1.0-wim.N` while tracking upstream nightly. WIM pins this repo by git commit in `apps/mobile/package.json`.
