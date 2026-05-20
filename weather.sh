#!/bin/bash

# Путь до index.html
OUTPUT="/var/www/html/index.html"

CITY=$1

# Получаем координаты через геокодер Open-Meteo
GEO=$(curl -s "https://geocoding-api.open-meteo.com/v1/search?name=${CITY}&count=1&language=en&format=json")
LAT=$(echo "$GEO" | jq '.results[0].latitude')
LON=$(echo "$GEO" | jq '.results[0].longitude')

# Получаем погоду по координатам
WEATHER=$(curl -s "https://api.open-meteo.com/v1/forecast?latitude=${LAT}&longitude=${LON}&current=temperature_2m,wind_speed_10m,relative_humidity_2m")

TEMP=$(echo "$WEATHER" | jq '.current.temperature_2m')
HUMIDITY=$(echo "$WEATHER" | jq '.current.relative_humidity_2m')
WIND=$(echo "$WEATHER" | jq '.current.wind_speed_10m')

# Генерируем HTML
cat > "$OUTPUT" <<EOF
<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="refresh" content="60">
  <title>Погода — ${CITY}</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Geist+Mono:wght@300;400;500&family=Geist:wght@300;400;500&display=swap" rel="stylesheet">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
 
    :root {
      --bg: #0d0f10;
      --surface: #161a1c;
      --surface2: #1e2326;
      --border: rgba(255,255,255,0.07);
      --text: #e8eaeb;
      --muted: #6b7579;
      --accent: #4ecca3;
      --accent-dim: rgba(78,204,163,0.12);
    }
 
    body {
      font-family: 'Geist', sans-serif;
      background: var(--bg);
      color: var(--text);
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem;
    }
 
    .card {
      background: var(--surface);
      border: 1px solid var(--border);
      border-radius: 20px;
      padding: 2.5rem;
      width: 100%;
      max-width: 420px;
    }
 
    .location {
      font-size: 13px;
      font-weight: 400;
      color: var(--muted);
      letter-spacing: 0.08em;
      text-transform: uppercase;
      margin-bottom: 0.4rem;
    }
 
    .city {
      font-size: 26px;
      font-weight: 500;
      color: var(--text);
      margin-bottom: 2rem;
    }
 
    .temp-block {
      display: flex;
      align-items: flex-start;
      gap: 0.25rem;
      margin-bottom: 2rem;
    }
 
    .temp-value {
      font-family: 'Geist Mono', monospace;
      font-size: 80px;
      font-weight: 300;
      line-height: 1;
      color: var(--accent);
    }
 
    .temp-unit {
      font-family: 'Geist Mono', monospace;
      font-size: 28px;
      font-weight: 300;
      color: var(--accent);
      margin-top: 10px;
    }
 
    .divider {
      height: 1px;
      background: var(--border);
      margin-bottom: 1.5rem;
    }
 
    .metrics {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 12px;
      margin-bottom: 2rem;
    }
 
    .metric {
      background: var(--surface2);
      border: 1px solid var(--border);
      border-radius: 12px;
      padding: 1rem 1.1rem;
    }
 
    .metric-label {
      font-size: 11px;
      letter-spacing: 0.1em;
      text-transform: uppercase;
      color: var(--muted);
      margin-bottom: 0.4rem;
    }
 
    .metric-value {
      font-family: 'Geist Mono', monospace;
      font-size: 22px;
      font-weight: 400;
      color: var(--text);
    }
 
    .metric-unit {
      font-size: 13px;
      color: var(--muted);
      margin-left: 2px;
    }
 
    .footer {
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
 
    .updated {
      font-size: 12px;
      color: var(--muted);
    }
 
    .badge {
      font-size: 11px;
      background: var(--accent-dim);
      color: var(--accent);
      border: 1px solid rgba(78,204,163,0.2);
      border-radius: 20px;
      padding: 3px 10px;
      letter-spacing: 0.04em;
    }
 
    .countdown {
      font-size: 12px;
      color: var(--muted);
      font-family: 'Geist Mono', monospace;
    }
  </style>
</head>
<body>
  <div class="card">
    <p class="city">${CITY}</p>
 
    <div class="temp-block">
      <span class="temp-value">${TEMP}</span>
      <span class="temp-unit">°C</span>
    </div>
 
    <div class="divider"></div>
 
    <div class="metrics">
      <div class="metric">
        <div class="metric-label">Влажность</div>
        <div class="metric-value">${HUMIDITY}<span class="metric-unit">%</span></div>
      </div>
      <div class="metric">
        <div class="metric-label">Ветер</div>
        <div class="metric-value">${WIND}<span class="metric-unit">км/ч</span></div>
      </div>
    </div>
 
    <div class="footer">
      <span class="updated">Обновлено: ${UPDATED}</span>
      <span class="badge">обновление через <span class="countdown" id="cd">60</span>с</span>
    </div>
  </div>
 
  <script>
    let s = 60;
    const el = document.getElementById('cd');
    setInterval(() => { s--; if (s >= 0) el.textContent = s; }, 1000);
  </script>
</body>
</html>
EOF
