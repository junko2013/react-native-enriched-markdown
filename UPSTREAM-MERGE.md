# Upstream merge guide

This repo is a **standalone fork** of the published npm package `react-native-enriched-markdown`, not a git fork of the full [software-mansion/enriched-markdown](https://github.com/software-mansion/enriched-markdown) monorepo. Upstream sources live under `packages/react-native-enriched-markdown` in that monorepo.

## WIM-only changes to preserve

When merging a newer upstream nightly/release, **re-apply** these intentional diffs:

### A. Message-safe parsing (`cpp/parser/MD4CParser.cpp`)

1. Parser flags: use `MD_FLAG_NOHTML | MD_FLAG_SPOILERS` (not `MD_FLAG_NOHTMLSPANS`).
2. `MD_SPAN_IMG`: create `NodeType::Link` instead of `NodeType::Image`.

### B. iOS custom emoji input

Keep or re-apply the entire block:

- New files: `ios/input/ENRMCustomEmojiEntry.*`, `ENRMCustomEmojiStore.*`, `ENRMCustomEmojiAttachment.*`
- Hooks in `ios/input/EnrichedMarkdownTextInput.mm`: store, `reapplyCustomEmojiAttachmentsInRange:`, `insertCustomEmoji:`, `syncCustomEmojis:`, `setPlainText:`
- Codegen helper: `ios/generated/ReactCodegen/EnrichedMarkdownTextSpec/RCTComponentViewHelpers.h`
- JS: `src/EnrichedMarkdownTextInputNativeComponent.ts`, `src/EnrichedMarkdownTextInput.tsx`, mirrored under `lib/`
- Android stubs: `EnrichedMarkdownTextInputManager.kt` + generated delegate/interface

Tip: compare against tag `1.1.0-nightly-20260912-4c1270f48` commit in this repo (`37ae75d` series) or run:

```sh
npm pack react-native-enriched-markdown@<UPSTREAM_VERSION> -C /tmp/upstream
diff -ruN /tmp/upstream/package .
```

### C. Consumer install layout (fork-only)

Do **not** restore upstream `prepare`, `prepack`, or heavy `devDependencies` unless you are rebuilding `lib/` locally. Keep:

- `"devDependencies": {}`
- `"postinstall": "node -e \"process.exit(0)\""`
- Prebuilt `lib/` committed after any TS/codegen change

## Merge procedure

1. **Pick upstream version** from npm or monorepo tag matching WIM's target SDK.
2. **Extract tarball** or copy `packages/react-native-enriched-markdown` from monorepo at that tag into a branch.
3. **Apply sections A + B** (use git cherry-pick from this repo's `main` if paths still align, else manual merge).
4. **Rebuild artifacts** if upstream changed TS/native commands:
   - Temporarily restore devDependencies from upstream `package.json`
   - Run upstream build (`bob build`, codegen) in a clean checkout
   - Copy resulting `lib/` and `ios/generated/` / `android/generated/` back
   - Remove devDependencies again; restore noop postinstall
5. **Bump** `"version": "1.1.0-wim.N"` in `package.json`.
6. **Commit**, push, tag optional `v1.1.0-wim.N`.
7. **Notify WIM** to update `apps/mobile/package.json` git SHA and `pnpm-workspace.yaml` allowBuilds entry.

## WIM downstream update (after push)

In [junko2013/wim](https://github.com/junko2013/wim):

```json
"react-native-enriched-markdown": "github:junko2013/react-native-enriched-markdown#<new-full-sha>"
```

```yaml
# pnpm-workspace.yaml allowBuilds
react-native-enriched-markdown@https://codeload.github.com/junko2013/react-native-enriched-markdown/tar.gz/<new-full-sha>: true
```

Then: `pnpm install`, iOS prebuild + pod install, rebuild dev client, run composer acceptance (see WIM `docs/decisions/enriched-markdown-fork.md`).

## Conflict hotspots

| Area | Risk |
|---|---|
| `EnrichedMarkdownTextInput.mm` | High — upstream edits formatting pipeline often |
| `RCTComponentViewHelpers.h` | High — regenerate vs manual command list |
| `MD4CParser.cpp` | Medium — upstream parser flags may change |
| `package.json` scripts | Low — keep WIM consumer layout |

## Version naming

- `1.1.0-wim.1` = first WIM fork based on upstream `1.1.0-nightly-20260912-4c1270f48`
- Increment `wim.N` for each WIM-side release; record upstream base in `WIM-FORK.md` and commit message
