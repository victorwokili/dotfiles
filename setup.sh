#!/usr/bin/env bash
set -e

echo "============================================================"
echo "💻 Setting up your colorful JetBrains + Powerlevel10k terminal"
echo "============================================================"

# 1️⃣ Homebrew
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed."
fi
brew update

# 2️⃣ Essentials
echo "🧰 Installing core tools..."
brew install git stow zsh gh neovim tmux wget curl tree || true

# 3️⃣ Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# 4️⃣ JetBrains Mono Nerd Font
echo "🎨 Installing JetBrains Mono Nerd Font..."
brew untap homebrew/cask-fonts >/dev/null 2>&1 || true
brew install --cask font-jetbrains-mono-nerd-font || \
brew install --cask font-jetbrainsmono-nerd-font || true

# 5️⃣ Oh My Zsh + Powerlevel10k
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "⚙️  Installing Oh My Zsh..."
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "✅ Oh My Zsh already installed."
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "💎 Installing Powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
  echo "✅ Powerlevel10k already installed."
fi

# 6️⃣ Create colorful Powerlevel10k config
echo "🌈 Creating colorful Powerlevel10k config..."
cat <<'EOF' > ~/.p10k.zsh
# POWERLEVEL10K COLORFUL THEME
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)
typeset -g POWERLEVEL9K_MODE='awesome-patched'
typeset -g POWERLEVEL9K_BACKGROUND_JOBS_FOREGROUND=2
typeset -g POWERLEVEL9K_OS_ICON_CONTENT_EXPANSION='🐧'
typeset -g POWERLEVEL9K_DIR_FOREGROUND=6
typeset -g POWERLEVEL9K_VCS_FOREGROUND=4
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND=2
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=1
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=3
typeset -g POWERLEVEL9K_TIME_FOREGROUND=7
typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS_FOREGROUND=10
typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS_FOREGROUND=1
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
EOF

# 7️⃣ Write .zshrc
echo "🧠 Writing ~/.zshrc..."
cat <<'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
autoload -Uz colors && colors
alias ls='ls -G'
export LSCOLORS="ExFxBxDxCxegedabagacad"
EOF

# 8️⃣ Fix Ghostty config (remove deprecated 'font' key)
echo "🧩 Fixing Ghostty config..."
mkdir -p ~/.config/ghostty
cat <<'EOF' > ~/.config/ghostty/config
background-blur-radius = 20
mouse-hide-while-typing = true
window-decoration = false
macos-option-as-alt = true
font-family = JetBrainsMono Nerd Font
EOF

# 9️⃣ VS Code terminal match
echo "🧬 Applying VS Code terminal font..."
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
mkdir -p "$(dirname "$VSCODE_SETTINGS")"
[ ! -f "$VSCODE_SETTINGS" ] && echo "{}" > "$VSCODE_SETTINGS"

/usr/bin/env python3 <<'PYCODE'
import json, os
p = os.path.expanduser("~/Library/Application Support/Code/User/settings.json")
with open(p) as f: d=json.load(f)
d.update({
 "terminal.integrated.fontFamily":"JetBrainsMono Nerd Font",
 "terminal.integrated.fontSize":14,
 "terminal.integrated.lineHeight":1.2,
 "terminal.integrated.cursorStyle":"underline",
 "terminal.integrated.cursorBlinking":True,
 "workbench.colorTheme":"Default Dark Modern",
 "workbench.iconTheme":"material-icon-theme",
 "terminal.integrated.tabs.enabled":True
})
with open(p,"w") as f: json.dump(d,f,indent=2)
PYCODE

# 🔟 Switch shell to Zsh
echo "🔁 Switching shell to Zsh..."
if [ "$SHELL" != "$(which zsh)" ]; then
  chsh -s "$(which zsh)" || true
fi

echo "============================================================"
echo "🎉 All done! Restart VS Code & Ghostty for the full color theme."
echo "============================================================"