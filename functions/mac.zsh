ip(){
	echo "Ethernet: `ipconfig getifaddr en0 \n`"
	echo "External: `curl -s http://ipecho.net/plain`"
  echo "WiFi    : `ifconfig | grep inet | grep broadc | cut -d ' ' -f 2`"
}

# iOS-safe H.264 (libx264). HW=1 to use h264_videotoolbox.
tx-to-x264() {
  emulate -L zsh
  set -o noglob  # prevent ? globbing in -map 0:a?

  if ! command -v ffmpeg >/dev/null; then echo "ffmpeg not found" >&2; return 127; fi

  for f in "$@"; do
    [[ -f "$f" ]] || { echo "skip: $f (not a file)"; continue; }
    base="${f%.*}"
    out="${base}-x264.mp4"
    echo "-> $out"

    if [[ -n "$HW" ]]; then
      ffmpeg -y -i "$f" \
        -map 0:v:0 -map 0:a\? \
        -c:v h264_videotoolbox -b:v "${BV:-6M}" -maxrate "${MR:-8M}" -bufsize "${BS:-12M}" -pix_fmt yuv420p \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2,fps=30" \
        -c:a aac -b:a 128k -ar 48000 \
        -movflags +faststart \
        "$out"
    else
      ffmpeg -y -i "$f" \
        -map 0:v:0 -map 0:a\? \
        -c:v libx264 -profile:v high -level 4.0 -pix_fmt yuv420p \
        -crf "${CRF:-20}" -preset "${X264_PRESET:-veryfast}" \
        -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2,fps=30" \
        -c:a aac -profile:a aac_low -b:a 128k -ar 48000 \
        -movflags +faststart \
        "$out"
    fi
  done
}
