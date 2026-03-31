#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd -- "${SCRIPT_DIR}/../.." && pwd)"
DIST_DIR="${ROOT_DIR}/dist/linux-packages"
MESON_BUILD_DIR="${DIST_DIR}/meson-build"
STAGE_DIR="${DIST_DIR}/stage"
APPDIR="${DIST_DIR}/Parfait.AppDir"
ARTIFACTS_DIR="${DIST_DIR}/artifacts"
TOOLS_DIR="${DIST_DIR}/tools"
APP_ID="dev.pinkpixel.Parfait"

usage() {
  cat <<'EOF'
Usage: ./packaging/linux/build-packages.sh [deb] [rpm] [appimage]

Builds native Linux packages for Parfait by reusing the Meson install tree.
If no package format is passed, the script builds a tested AppImage.
EOF
}

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

map_nfpm_arch() {
  case "$1" in
    x86_64 | amd64) echo "amd64" ;;
    aarch64 | arm64) echo "arm64" ;;
    armv7l) echo "arm7" ;;
    i386 | i686) echo "386" ;;
    *)
      echo "Unsupported architecture for nfpm: $1" >&2
      exit 1
      ;;
  esac
}

map_appimage_arch() {
  case "$1" in
    x86_64 | amd64) echo "x86_64" ;;
    aarch64 | arm64) echo "aarch64" ;;
    *)
      echo "Unsupported architecture for AppImage automation: $1" >&2
      exit 1
      ;;
  esac
}

download_if_missing() {
  local url="$1"
  local output="$2"

  if [ ! -f "$output" ]; then
    need_cmd curl
    curl -L --fail --output "$output" "$url"
  fi

  chmod +x "$output"
}

prepare_stage_tree() {
  need_cmd meson
  need_cmd cargo

  rm -rf "$MESON_BUILD_DIR" "$STAGE_DIR"
  mkdir -p "$ARTIFACTS_DIR" "$TOOLS_DIR"

  meson setup "$MESON_BUILD_DIR" --buildtype=release --prefix=/usr
  meson compile -C "$MESON_BUILD_DIR"
  DESTDIR="$STAGE_DIR" meson install -C "$MESON_BUILD_DIR" --no-rebuild
}

build_nfpm_package() {
  local packager="$1"
  need_cmd nfpm

  NFPM_ARCH="${NFPM_ARCH:-$(map_nfpm_arch "$(uname -m)")}" \
  PARFAIT_VERSION="${PARFAIT_VERSION:-$(sed -nE 's/^version = \"([^\"]+)\"/\\1/p' "${ROOT_DIR}/Cargo.toml" | head -n 1)}" \
    nfpm package \
      --config "${ROOT_DIR}/packaging/linux/nfpm.yaml" \
      --packager "$packager" \
      --target "${ARTIFACTS_DIR}/"
}

prepare_appdir() {
  need_cmd glib-compile-schemas

  rm -rf "$APPDIR"
  mkdir -p "$APPDIR/usr"
  cp -a "${STAGE_DIR}/usr/." "$APPDIR/usr/"
  install -m 755 "${ROOT_DIR}/packaging/linux/AppRun" "${APPDIR}/AppRun"

  sed -i 's#^Exec=.*#Exec=parfait#' \
    "${APPDIR}/usr/share/applications/${APP_ID}.desktop"

  glib-compile-schemas "${APPDIR}/usr/share/glib-2.0/schemas"
}

resolve_appimagetool() {
  local host_arch="$1"
  local appimagetool_bin="${APPIMAGETOOL_BIN:-}"

  if [ -z "$appimagetool_bin" ]; then
    if [ "$host_arch" != "x86_64" ]; then
      echo "Set APPIMAGETOOL_BIN for non-x86_64 AppImage builds." >&2
      exit 1
    fi

    appimagetool_bin="${TOOLS_DIR}/appimagetool-x86_64.AppImage"
    download_if_missing \
      "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" \
      "$appimagetool_bin"
  fi

  echo "$appimagetool_bin"
}

build_appimage() {
  local appimage_arch
  local appimagetool_bin
  local root_desktop
  local root_icon
  local appstream_alias
  local output_name

  appimage_arch="$(map_appimage_arch "$(uname -m)")"
  appimagetool_bin="$(resolve_appimagetool "$appimage_arch")"
  output_name="Parfait.AppImage"

  prepare_appdir

  root_desktop="${APPDIR}/${APP_ID}.desktop"
  root_icon="${APPDIR}/${APP_ID}.png"
  appstream_alias="${APPDIR}/usr/share/metainfo/${APP_ID}.appdata.xml"

  cp "${APPDIR}/usr/share/applications/${APP_ID}.desktop" "$root_desktop"
  cp "${APPDIR}/usr/share/icons/hicolor/256x256/apps/${APP_ID}.png" "$root_icon"
  cp "${APPDIR}/usr/share/icons/hicolor/256x256/apps/${APP_ID}.png" "${APPDIR}/.DirIcon"
  cp "${APPDIR}/usr/share/metainfo/${APP_ID}.metainfo.xml" "$appstream_alias"

  sed -i 's#^Exec=.*#Exec=AppRun#' "$root_desktop"

  env APPIMAGE_EXTRACT_AND_RUN=1 \
    ARCH="${appimage_arch}" \
    "$appimagetool_bin" \
      "$APPDIR" \
      "${ARTIFACTS_DIR}/${output_name}"
}

main() {
  local formats=("$@")

  if [ "${#formats[@]}" -eq 0 ]; then
    formats=(appimage)
  fi

  if [ "${formats[0]}" = "--help" ] || [ "${formats[0]}" = "-h" ]; then
    usage
    exit 0
  fi

  prepare_stage_tree

  for format in "${formats[@]}"; do
    case "$format" in
      deb | rpm)
        build_nfpm_package "$format"
        ;;
      appimage)
        build_appimage
        ;;
      *)
        echo "Unsupported package format: $format" >&2
        usage >&2
        exit 1
        ;;
    esac
  done

  echo "Packaged artifacts are available in ${ARTIFACTS_DIR}"
}

main "$@"
