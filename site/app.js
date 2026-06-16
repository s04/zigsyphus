const state = { filter: "", summary: null };
const fmt = new Intl.NumberFormat("en-US");

const el = {
  chart: document.querySelector("#chart"),
  filter: document.querySelector("#filter"),
  runs: document.querySelector("#runs"),
  stats: document.querySelector("#stats"),
};

function esc(value) {
  return String(value ?? "").replace(/[&<>"']/g, (char) => ({
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&#039;",
  })[char]);
}

async function fetchJson(path) {
  for (const candidate of [path, `../${path}`, `/${path}`]) {
    try {
      const response = await fetch(candidate, { cache: "no-store" });
      if (response.ok) return response.json();
    } catch {
      // Try next layout.
    }
  }
  throw new Error(`Could not load ${path}`);
}

function stat(label, value, detail) {
  return `
    <div class="stat rounded-box border border-base-300 bg-base-100 shadow-sm">
      <div class="stat-title text-xs font-bold uppercase">${esc(label)}</div>
      <div class="stat-value text-2xl lg:text-3xl">${esc(value)}</div>
      <div class="stat-desc">${esc(detail)}</div>
    </div>
  `;
}

function renderStats() {
  const latest = state.summary.latest || {};
  el.stats.innerHTML = [
    stat("Runs", fmt.format(state.summary.runCount || 0), "committed attempts"),
    stat("Latest score", latest.score ?? "-", latest.slug || "no run yet"),
    stat("Tests", `${latest.passed ?? 0}/${latest.total ?? 0}`, latest.status || "unknown"),
    stat("Next diff", state.summary.nextDifficulty ?? "-", latest.model || "-"),
  ].join("");
}

function renderChart() {
  const scores = state.summary.scores || [];
  if (!scores.length) {
    el.chart.innerHTML = `<div class="grid min-h-48 place-items-center text-base-content/60">No runs yet.</div>`;
    return;
  }
  const width = Math.max(640, scores.length * 34);
  const height = 220;
  const points = scores.map((item, index) => {
    const x = 24 + index * ((width - 48) / Math.max(scores.length - 1, 1));
    const y = height - 24 - (Number(item.score || 0) / 100) * (height - 48);
    return { ...item, x, y };
  });
  el.chart.innerHTML = `
    <svg viewBox="0 0 ${width} ${height}" class="w-full min-w-[640px]" role="img" aria-label="Score trend">
      <line x1="24" y1="${height - 24}" x2="${width - 24}" y2="${height - 24}" stroke="currentColor" opacity="0.2" />
      <line x1="24" y1="24" x2="24" y2="${height - 24}" stroke="currentColor" opacity="0.2" />
      <polyline fill="none" stroke="oklch(var(--p))" stroke-width="3" points="${points.map((p) => `${p.x},${p.y}`).join(" ")}" />
      ${points.map((p) => `<circle cx="${p.x}" cy="${p.y}" r="4" fill="oklch(var(--p))"><title>${esc(p.date)} ${esc(p.slug)}: ${esc(p.score)}</title></circle>`).join("")}
    </svg>
  `;
}

function renderRuns() {
  const needle = state.filter.toLowerCase();
  const rows = (state.summary.recentRuns || []).filter((row) =>
    [row.slug, row.name, row.status, row.model].some((value) => String(value || "").toLowerCase().includes(needle)),
  ).reverse();
  if (!rows.length) {
    el.runs.innerHTML = `<div class="grid min-h-32 place-items-center text-base-content/60">No matching runs.</div>`;
    return;
  }
  el.runs.innerHTML = `
    <div class="table-wrap">
      <table class="table table-sm table-zebra table-pin-rows">
        <thead>
          <tr>
            <th>Date</th><th>Exercise</th><th class="num">Diff</th><th>Status</th>
            <th class="num">Passed</th><th class="num">Score</th><th>Attempt</th>
          </tr>
        </thead>
        <tbody>
          ${rows.map((row) => `
            <tr>
              <td>${esc(row.date)}</td>
              <td>${esc(row.name)} <span class="text-base-content/50">(${esc(row.slug)})</span></td>
              <td class="num">${esc(row.difficulty)}</td>
              <td><span class="badge badge-outline">${esc(row.status)}</span></td>
              <td class="num">${esc(row.passed)}/${esc(row.total)}</td>
              <td class="num">${esc(row.score)}</td>
              <td><a class="link link-primary" href="${esc(row.solutionPath)}">solution</a></td>
            </tr>
          `).join("")}
        </tbody>
      </table>
    </div>
  `;
}

function render() {
  renderStats();
  renderChart();
  renderRuns();
}

el.filter.addEventListener("input", (event) => {
  state.filter = event.target.value;
  renderRuns();
});

fetchJson("data/gold/summary.json")
  .then((summary) => {
    state.summary = summary;
    render();
  })
  .catch((error) => {
    state.summary = {
      latest: {},
      recentRuns: [],
      runCount: 0,
      scores: [],
    };
    render();
    el.runs.innerHTML = `<div class="alert">No attempts have been committed yet. First daily run will create the audit log.</div>`;
  });
