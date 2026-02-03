for f in *.*; do
  [ -f "$f" ] && mkdir -p "${f%.*}" && mv "$f" "${f%.*}/"
done