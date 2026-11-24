"""Forbidden-token scan for Lean sources, with comments and string literals stripped.

Copyright (c) 2026 Benjamin Stanley Frohman. Apache-2.0. Author: Benjamin Stanley Frohman.

Fails if any scanned file contains `sorry`, `admit`, `native_decide`, or an `axiom`
declaration in code (text inside `--` and `/- ... -/` comments and inside string
literals is ignored).

Usage:
  python3 scripts/check_forbidden_tokens.py [--exclude FILE ...] [--require-imported-by AUDIT.lean] PATH [PATH ...]

Each PATH is a .lean file or a directory scanned recursively (`.lake` is skipped).
Run from the Lake package root.  `--exclude FILE` skips one file (it is listed in the
output so the exclusion is visible).  `--require-imported-by AUDIT.lean` (repeatable)
additionally fails if some scanned file is not in the import closure of the AUDIT files, so the axiom
audit cannot silently miss a module.
"""
import re
import sys
from pathlib import Path

BAD = re.compile(
    r'(?<![A-Za-z0-9_.\'])(sorry|admit|native_decide)(?![A-Za-z0-9_\'])'
    r'|^\s*(@\[[^\]]*\]\s*)?((private|protected|noncomputable|unsafe)\s+)*axiom\s',
    re.M,
)


def strip(src: str) -> str:
    out, i, depth, n = [], 0, 0, len(src)
    while i < n:
        if depth == 0 and src.startswith('--', i):
            j = src.find('\n', i)
            i = n if j < 0 else j
            continue
        if src.startswith('/-', i):
            depth += 1
            i += 2
            continue
        if depth and src.startswith('-/', i):
            depth -= 1
            i += 2
            continue
        if depth == 0 and src[i] == '"':
            j = i + 1
            while j < n and src[j] != '"':
                j += 2 if src[j] == '\\' else 1
            out.append('""')
            i = j + 1
            continue
        if depth == 0:
            out.append(src[i])
        elif src[i] == '\n':
            out.append('\n')
        i += 1
    return ''.join(out)


def files(paths):
    for p in map(Path, paths):
        if p.is_file() and p.suffix == '.lean':
            yield p
        elif p.is_dir():
            for f in sorted(p.rglob('*.lean')):
                if '.lake' not in f.parts:
                    yield f
        else:
            sys.exit(f'path not found: {p}')


IMPORT = re.compile(r'^\s*(?:public\s+)?(?:meta\s+)?import\s+([\w.\u00ab\u00bb]+)', re.M)


def module_of(path: Path) -> str:
    return '.'.join(path.with_suffix('').parts)


def closure(audit: Path) -> set:
    seen, todo = set(), [audit]
    while todo:
        f = todo.pop()
        if f in seen or not f.exists():
            continue
        seen.add(f)
        for m in IMPORT.findall(strip(f.read_text(encoding='utf-8'))):
            todo.append(Path(*m.split('.')).with_suffix('.lean'))
    return {module_of(f) for f in seen if f != audit}


def main(argv):
    excludes, audits, paths = set(), [], []
    it = iter(argv)
    for a in it:
        if a == '--exclude':
            excludes.add(Path(next(it)))
        elif a == '--require-imported-by':
            audits.append(Path(next(it)))
        else:
            paths.append(a)
    if not paths:
        sys.exit(__doc__)
    for audit in audits:
        if not audit.exists():
            sys.exit(f'audit file not found: {audit}')
    reach = set().union(*(closure(a) for a in audits)) if audits else None
    audit = ' + '.join(map(str, audits))
    bad, missing, count = [], [], 0
    for f in files(paths):
        if f in excludes:
            print(f'EXCLUDED (not scanned): {f}')
            continue
        if reach is not None and module_of(f) not in reach:
            missing.append(str(f))
        count += 1
        code = strip(f.read_text(encoding='utf-8'))
        for k, line in enumerate(code.splitlines(), 1):
            if BAD.search(line):
                bad.append(f'{f}:{k}: {line.strip()}')
    print(f'scanned {count} Lean files under: {" ".join(paths)}')
    if count == 0:
        sys.exit('FAIL: no Lean files scanned')
    if missing:
        print('\n'.join(f'NOT IMPORTED by {audit}: {m}' for m in missing))
        sys.exit(f'FAIL: {len(missing)} scanned module(s) are outside the axiom audit')
    if audits:
        print(f'coverage: every scanned module is imported (transitively) by {audit}')
    if bad:
        print('\n'.join(bad))
        sys.exit(f'FAIL: {len(bad)} forbidden token(s) in code')
    print('PASS: no sorry / admit / native_decide / axiom declarations (comments excluded)')


if __name__ == '__main__':
    main(sys.argv[1:])
