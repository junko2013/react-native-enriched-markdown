import type { ASTNode } from './types';
import type { Md4cFlags } from '../types/MarkdownStyle';
export declare function parseMarkdown(markdown: string, { underline, latexMath, superscript, subscript, highlight, hardSoftBreaks, preserveBlankLines, admonitions, }?: Md4cFlags): Promise<ASTNode>;
//# sourceMappingURL=parseMarkdown.d.ts.map