#!/usr/bin/env bash
set -euo pipefail

# Cross-platform JDK 11 installer + JAVA_HOME setter
# - macOS: installs Temurin 11 via Homebrew Cask (or instructs how to install Homebrew)
# - Debian/Ubuntu: installs openjdk-11 via apt
# - Appends safe exports to the user's shell rc (~/.zshrc or ~/.bashrc)

fail() { echo "ERROR: $*" >&2; exit 1; }

OS_NAME="$(uname -s)"

append_if_missing() {
  local file="$1" line="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  if ! grep -Fqx "$line" "$file" 2>/dev/null; then
    echo "$line" >> "$file"
    echo "Added to $file: $line"
  else
    echo "Entry already present in $file: $line"
  fi
}

set_java_home_mac() {
  # Try to use macOS tool first
  if command -v /usr/libexec/java_home >/dev/null 2>&1; then
    JAVA_HOME_VAL="$(/usr/libexec/java_home -v 11 2>/dev/null || true)"
    if [ -n "$JAVA_HOME_VAL" ]; then
      echo "Detected JAVA_HOME: $JAVA_HOME_VAL"
      export JAVA_HOME="$JAVA_HOME_VAL"
      return 0
    fi
  fi

  # Fallback: try common Homebrew cask locations
  for prefix in "/opt/homebrew" "/usr/local"; do
    if [ -d "$prefix/opt/temurin@11" ]; then
      JAVA_HOME_VAL="$prefix/opt/temurin@11/libexec/openjdk.jdk/Contents/Home"
    elif [ -d "$prefix/opt/temurin11" ]; then
      JAVA_HOME_VAL="$prefix/opt/temurin11/libexec/openjdk.jdk/Contents/Home"
    elif [ -d "$prefix/opt/openjdk@11" ]; then
      JAVA_HOME_VAL="$prefix/opt/openjdk@11/libexec/openjdk.jdk/Contents/Home"
    fi
    if [ -n "${JAVA_HOME_VAL:-}" ] && [ -d "$JAVA_HOME_VAL" ]; then
      echo "Detected JAVA_HOME (brew): $JAVA_HOME_VAL"
      export JAVA_HOME="$JAVA_HOME_VAL"
      return 0
    fi
  done

  return 1
}

if [[ "$OS_NAME" == "Darwin" ]]; then
  echo "macOS detected. Preparing to install JDK 11 via Homebrew cask (Temurin)."

  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew not found. Please install Homebrew first:"
    echo "/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    fail "Homebrew is required on macOS. Re-run the script after installing Homebrew."
  fi

  echo "Updating Homebrew..."
  brew update || true

  # Prefer temurin11 cask; some Homebrew setups expose temurin11 or temurin@11
  echo "Installing Temurin 11 (or equivalent) cask..."
  if brew info --cask temurin11 >/dev/null 2>&1; then
    brew install --cask temurin11 || true
  elif brew info --cask temurin >/dev/null 2>&1; then
    # temurin cask may install latest; we try temurin (may be >11) but we'll still attempt to set JAVA_HOME for 11
    brew install --cask temurin || true
  else
    # Try generic adoptopenjdk/temurin variants
    brew install --cask temurin || true || true
  fi

  # Try to detect JAVA_HOME for Java 11
  if set_java_home_mac; then
    :
  else
    echo "Couldn't auto-detect a Java 11 installation. You may need to accept installer dialogs or install a specific JDK cask."
  fi

  # Choose shell rc file (prefer zsh on modern macOS)
  RC_FILE="$HOME/.zshrc"
  if [ -n "${SHELL:-}" ] && [[ "$SHELL" == */bash ]]; then
    RC_FILE="$HOME/.bashrc"
  fi

  if [ -n "${JAVA_HOME:-}" ]; then
    append_if_missing "$RC_FILE" "export JAVA_HOME=\"$JAVA_HOME\""
    append_if_missing "$RC_FILE" 'export PATH="$JAVA_HOME/bin:$PATH"'
    echo "Please run: source $RC_FILE or open a new terminal to apply JAVA_HOME."
  else
    echo "Please set JAVA_HOME manually after installation. Example (macOS):"
    echo '  export JAVA_HOME="$(/usr/libexec/java_home -v 11)"'
    echo '  export PATH="$JAVA_HOME/bin:$PATH"'
    echo "Then add those lines to your ~/.zshrc or ~/.bashrc."
  fi

  echo "Done (macOS). Verify with: java -version and echo \"$JAVA_HOME\""
  exit 0
fi

# --- Linux (Debian/Ubuntu) branch ---

if command -v apt-get >/dev/null 2>&1; then
  echo "Debian/Ubuntu detected. Installing openjdk-11-jdk via apt."
  sudo apt-get update
  sudo apt-get install -y openjdk-11-jdk

  # Try to auto-detect JAVA_HOME
  if command -v java >/dev/null 2>&1; then
    JAVA_BIN="$(readlink -f "$(command -v java)")"
    # go two levels up from bin/java -> jdk root
    JAVA_HOME_VAL="$(dirname "$(dirname "$JAVA_BIN")")"
    echo "Detected JAVA_HOME: $JAVA_HOME_VAL"
    export JAVA_HOME="$JAVA_HOME_VAL"
    RC_FILE="$HOME/.bashrc"
    if [ -n "${SHELL:-}" ] && [[ "$SHELL" == */zsh ]]; then
      RC_FILE="$HOME/.zshrc"
    fi
    append_if_missing "$RC_FILE" "export JAVA_HOME=\"$JAVA_HOME_VAL\""
    append_if_missing "$RC_FILE" 'export PATH="$JAVA_HOME/bin:$PATH"'
    echo "Please run: source $RC_FILE or open a new terminal to apply JAVA_HOME."
  else
    echo "java not found after install; something may have gone wrong."
  fi

  echo "Done (Linux). Verify with: java -version and echo \"$JAVA_HOME\""
  exit 0
fi

fail "Unsupported OS: $OS_NAME. This script supports macOS and Debian/Ubuntu Linux."
sudo apt update
sudo apt install -y openjdk-11-jdk
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc

./gradlew clean build