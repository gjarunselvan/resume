#!/usr/bin/env bash
set -e

echo "🔥 AUTO RESUME BUILDER — NEXT LEVEL MODE 🔥"

PDF="ArunSelvanGJ.pdf"
OUT="site"
ASSETS="$OUT/assets"

if [ ! -f "$PDF" ]; then
  echo "❌ Resume PDF not found: $PDF"
  exit 1
fi

echo "📁 Preparing workspace..."
rm -rf "$OUT"
mkdir -p "$ASSETS"

echo "📄 Extracting text from PDF..."
pdftotext "$PDF" resume.txt

NAME=$(grep -m1 -E "Arun|Selvan" resume.txt | head -n1)
ROLE="DevOps & Systems Engineer"

echo "🖼 Extracting photo from PDF..."
pdfimages -png "$PDF" "$ASSETS/img" || true
PHOTO=$(ls "$ASSETS"/img-*.png 2>/dev/null | head -n1 || true)

if [ -n "$PHOTO" ]; then
  convert "$PHOTO" -resize 512x512 "$ASSETS/profile.webp"
else
  echo "⚠️ No photo found, skipping image"
fi

echo "📱 Generating QR code..."
qrencode -o "$ASSETS/qr.png" "https://resume.gjarunselvan.online"

echo "🎨 Generating website files..."

cat > "$OUT/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Arun Selvan G J — DevOps Engineer</title>

<meta name="description" content="DevOps Engineer · Homelab Architect · Cloudflare Zero Trust">
<meta property="og:title" content="Arun Selvan G J — DevOps Engineer">
<meta property="og:type" content="website">
<meta property="og:image" content="assets/profile.webp">

<link rel="preload" href="style.css" as="style">
<link rel="stylesheet" href="style.css">
</head>

<body>
<header class="hero">
  <div class="hero-3d">
    <img src="assets/profile.webp" alt="Profile" />
    <h1>Arun <span>Selvan</span> G J</h1>
    <p>DevOps • Homelab • Cloudflare Zero Trust</p>
    <div class="cta">
      <a href="#contact">Hire Me</a>
      <a href="assets/ArunSelvanGJ.pdf" download>Download PDF</a>
    </div>
  </div>
</header>

<section class="metrics">
  <div><span data-count="8">0</span>+ Years</div>
  <div><span data-count="99">0</span>.99% Uptime</div>
  <div><span data-count="40">0</span>+ Projects</div>
</section>

<section class="terminal">
<pre>
$ docker ps
✔ immich
✔ nextcloud
✔ plex
✔ jellyfin

$ cloudflared tunnel info
✔ connected to multiple edges

$ uptime
99.99%
</pre>
</section>

<section class="cards">
  <div class="card">Cloudflare Zero Trust</div>
  <div class="card">CI/CD Automation</div>
  <div class="card">Homelab Infrastructure</div>
  <div class="card">Monitoring & Observability</div>
</section>

<section id="contact">
  <h2>Let’s Build Something 🔥</h2>
  <a class="hire" href="mailto:arunselvangj@gmail.com">Contact Me</a>
  <img src="assets/qr.png" class="qr" />
</section>

<footer>
© 2026 Arun Selvan G J · Resume as Code
</footer>

<script src="script.js"></script>
</body>
</html>
EOF

cat > "$OUT/style.css" <<'EOF'
:root {
  --bg:#0b0d10; --fg:#e5e7eb; --accent:#5eead4;
}
@media (prefers-color-scheme: light){
  :root { --bg:#f9fafb; --fg:#111827; }
}
*{box-sizing:border-box}
body{margin:0;font-family:Inter,system-ui;background:var(--bg);color:var(--fg)}
.hero{height:100vh;display:flex;align-items:center;justify-content:center}
.hero-3d{text-align:center;transform-style:preserve-3d}
.hero img{width:160px;border-radius:50%;box-shadow:0 40px 120px #000}
h1 span{color:var(--accent)}
.cta a{margin:10px;padding:12px 20px;border-radius:10px;background:var(--accent);color:#000;text-decoration:none}
.metrics{display:flex;justify-content:center;gap:40px;padding:60px;font-size:2rem}
.terminal{background:#020617;color:#5eead4;padding:40px;margin:60px;border-radius:16px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px;padding:60px}
.card{background:#111827;padding:30px;border-radius:16px;transition:.3s}
.card:hover{transform:rotateX(8deg) rotateY(-8deg)}
#contact{text-align:center;padding:80px}
.hire{display:inline-block;padding:16px 30px;background:var(--accent);color:#000;border-radius:14px}
.qr{width:120px;margin-top:20px}
footer{text-align:center;opacity:.6;padding:40px}
EOF

cat > "$OUT/script.js" <<'EOF'
document.querySelectorAll('[data-count]').forEach(el=>{
  let t=0,max=+el.dataset.count
  let i=setInterval(()=>{
    t++; el.textContent=t
    if(t>=max) clearInterval(i)
  },20)
})

document.addEventListener('mousemove',e=>{
  const h=document.querySelector('.hero-3d')
  h.style.transform=`rotateY(${e.clientX/40}deg) rotateX(${-e.clientY/40}deg)`
})
EOF

cp "$PDF" "$ASSETS/ArunSelvanGJ.pdf"

echo "🧾 Initializing git versioning..."
git init >/dev/null 2>&1 || true
git add .
git commit -m "🔥 Auto-generated next-level resume" || true
git tag -f v1.0-resume

echo "✅ DONE."
echo "👉 Deploy folder: $OUT"
echo "👉 Push to GitHub → Cloudflare Pages"
echo "🔥 YOU JUST BUILT A MONSTER RESUME."
