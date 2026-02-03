for f in *.*; do
  mkdir -p "${f%.*}" && mv "$f" "${f%.*}/"
done