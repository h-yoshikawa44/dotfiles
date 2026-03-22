#!/usr/bin/env python3

# https://nyosegawa.com/posts/claude-code-statusline-rate-limits/
"""Status line: current directory, git branch, model name, and context usage"""
import json, sys, os, subprocess

if sys.platform == 'win32':
    sys.stdout.reconfigure(encoding='utf-8')

data = json.load(sys.stdin)

BLOCKS = ' ▏▎▍▌▋▊▉█'
R = '\033[0m'
DIM = '\033[2m'
CYAN = '\033[36m'
YELLOW = '\033[33m'
BLUE = '\033[34m'

def gradient(pct):
    if pct < 50:
        r = int(pct * 5.1)
        return f'\033[38;2;{r};200;80m'
    else:
        g = int(200 - (pct - 50) * 4)
        return f'\033[38;2;255;{max(g,0)};60m'

def bar(pct, width=10):
    pct = min(max(pct, 0), 100)
    filled = pct * width / 100
    full = int(filled)
    frac = int((filled - full) * 8)
    b = '█' * full
    if full < width:
        b += BLOCKS[frac]
        b += '░' * (width - full - 1)
    return b

def fmt(label, pct):
    p = round(pct)
    return f'{label} {gradient(pct)}{bar(pct)} {p}%{R}'

def get_git_branch(cwd):
    try:
        result = subprocess.run(
            ['git', '-C', cwd, '--no-optional-locks', 'symbolic-ref', '--short', 'HEAD'],
            capture_output=True, text=True, timeout=2
        )
        if result.returncode == 0:
            return result.stdout.strip()
        # Detached HEAD: show short commit hash
        result2 = subprocess.run(
            ['git', '-C', cwd, '--no-optional-locks', 'rev-parse', '--short', 'HEAD'],
            capture_output=True, text=True, timeout=2
        )
        if result2.returncode == 0:
            return f'({result2.stdout.strip()})'
    except Exception:
        pass
    return None

cwd = data.get('workspace', {}).get('current_dir') or data.get('cwd', os.getcwd())

# Shorten home directory to ~
home = os.path.expanduser('~').replace('\\', '/')
cwd_display = cwd.replace('\\', '/')
if cwd_display.startswith(home):
    cwd_display = '~' + cwd_display[len(home):]

git_branch = get_git_branch(cwd)

model = data.get('model', {}).get('display_name', 'Claude')

parts = []

# Model name
parts.append(f'{BLUE}{model}{R}')

# Context usage
ctx = data.get('context_window', {}).get('used_percentage')
if ctx is not None:
    parts.append(fmt('ctx', ctx))

five = data.get('rate_limits', {}).get('five_hour', {}).get('used_percentage')
if five is not None:
    parts.append(fmt('5h', five))

week = data.get('rate_limits', {}).get('seven_day', {}).get('used_percentage')
if week is not None:
    parts.append(fmt('7d', week))

print(f'{DIM}│{R}'.join(f' {p} ' for p in parts), end='')
