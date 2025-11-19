#!/usr/bin/env sh
# setup-n8n-data-dir.sh
# Create a space-free symlink to your project folder and print export/Docker guidance
# Usage: ./scripts/setup-n8n-data-dir.sh [--force|-f] /absolute/path/to/HeirloomMobile [symlink-name]

set -eu

TARGET=""
SYMLINK_NAME="HeirloomMobile"
FORCE=0

usage() {
  cat <<EOF
Usage: $0 [--force|-f] /absolute/path/to/HeirloomMobile [symlink-name]

This script will:
  - create ~/Projects if missing
  - create a symlink at "\$HOME/Projects/<symlink-name>" -> the path you provide
  - print the recommended export command and a Docker -v example

Flags:
  -f, --force    Overwrite an existing symlink without prompting
  -h, --help     Show this message

If you run this script without a path it will prompt for the project path.
EOF
}

# Parse args (simple POSIX-friendly parser)
while [ "$#" -gt 0 ]; do
  case "$1" in
    -f|--force)
      FORCE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      usage
      exit 2
      ;;
    *)
      if [ -z "$TARGET" ]; then
        TARGET="$1"
      else
        SYMLINK_NAME="$1"
      fi
      shift
      ;;
  esac
done

if [ -z "$TARGET" ]; then
  printf "Enter the absolute path to your HeirloomMobile folder (e.g. /path/to/HeirloomMobile): \n"
  if ! read -r TARGET; then
    echo "No input; exiting." >&2
    exit 1
  fi
fi

# Normalize the TARGET (remove trailing slash)
TARGET="$(printf '%s' "$TARGET" | sed 's:/*$::')"

DEST_DIR="$HOME/Projects"
mkdir -p "$DEST_DIR"

SYMLINK_PATH="$DEST_DIR/$SYMLINK_NAME"

if [ ! -e "$TARGET" ]; then
  if [ "$FORCE" -eq 1 ]; then
    mkdir -p "$TARGET"
    echo "Created missing target directory: $TARGET"
  else
    printf "Target path '%s' does not exist. Create it? [y/N]: " "$TARGET"
    if read -r ans && { [ "${ans}" = "y" ] || [ "${ans}" = "Y" ]; }; then
      mkdir -p "$TARGET"
      echo "Created $TARGET"
    else
      echo "Target path missing. Aborting." >&2
      exit 1
    fi
  fi
fi

if [ -L "$SYMLINK_PATH" ]; then
  CURRENT_TARGET=$(readlink "$SYMLINK_PATH" || true)
  if [ "$CURRENT_TARGET" = "$TARGET" ]; then
    echo "Symlink already exists and points to the target: $SYMLINK_PATH -> $CURRENT_TARGET"
    echo "Nothing to do."
    exit 0
  fi
  if [ "$FORCE" -eq 1 ]; then
    rm "$SYMLINK_PATH"
    echo "Removed existing symlink: $SYMLINK_PATH"
  else
    printf "A symlink already exists at %s -> %s\n" "$SYMLINK_PATH" "$CURRENT_TARGET"
    printf "Replace it? [y/N]: "
    if read -r resp && { [ "$resp" = "y" ] || [ "$resp" = "Y" ]; }; then
      rm "$SYMLINK_PATH"
    else
      echo "Keeping existing symlink. Exiting." && exit 0
    fi
  fi
elif [ -e "$SYMLINK_PATH" ]; then
  echo "A file or directory exists at $SYMLINK_PATH and is not a symlink. Please remove or choose a different symlink name." >&2
  exit 1
fi

ln -s "$TARGET" "$SYMLINK_PATH"
echo "Created symlink: $SYMLINK_PATH -> $TARGET"

cat <<EOF

Add this to your shell startup (e.g. ~/.profile, ~/.bash_profile or ~/.zshrc):

export N8N_DEFAULT_BINARY_DATA_DIRECTORY="$SYMLINK_PATH"

Docker example (quote the host path in -v and use a container path without spaces):

docker run -d \
  --name n8n-production \
  -p 5678:5678 \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD="$(openssl rand -base64 32)" \
  -e N8N_HOST=n8n.yourdomain.com \
  -e N8N_PROTOCOL=https \
  -e WEBHOOK_URL=https://n8n.yourdomain.com/ \
  -e PROJECT_ROOT=/data/projects/heirloom-mobile \
  -e N8N_DEFAULT_BINARY_DATA_DIRECTORY=/data/projects/heirloom-mobile \
  -v "$TARGET":/data/projects/heirloom-mobile \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n

Notes:
- The environment variable value used by Docker should point to the container path (example: /data/projects/heirloom-mobile).
- If your host path contains spaces, the -v argument must be quoted (as shown above).
- If you want the export line without quotes (for use in some automation), use:
  export N8N_DEFAULT_BINARY_DATA_DIRECTORY=$SYMLINK_PATH

EOF

echo "Done. You can now add the export line to your shell startup file and restart your shell."
