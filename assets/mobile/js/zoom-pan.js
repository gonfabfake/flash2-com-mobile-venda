/**
 * zoom-pan.js — Zoom e pan por gesto (pinch-to-zoom) sobre a área do jogo.
 *
 * Regra de ouro: em escala 1×, NENHUM evento é consumido — o jogo recebe
 * toque normalmente. O zoom só "toma" a entrada quando há 2 dedos (pinch) ou
 * quando já está ampliado (pan com 1 dedo).
 */

export class ZoomPan {
  constructor({ target, min = 1, max = 4, onChange = null } = {}) {
    this.target = target;
    this.min = min;
    this.max = max;
    this.onChange = onChange || (() => {});

    this.scale = 1;
    this.tx = 0;
    this.ty = 0;

    this._pointers = new Map();
    this._lastDist = 0;
    this._lastMid = null;
    this._panOrigin = null;
    this._lastTap = 0;
    this._enabled = true;

    this._bind();
    this._apply();
  }

  get zoomed() { return this.scale > 1.001; }

  set enabled(v) { this._enabled = !!v; }

  _bind() {
    const t = this.target;

    t.addEventListener('pointerdown', (e) => {
      if (!this._enabled) return;
      this._pointers.set(e.pointerId, { x: e.clientX, y: e.clientY });

      if (this._pointers.size === 2) {
        // Inicia pinch — consome a partir daqui.
        e.preventDefault();
        try { t.setPointerCapture(e.pointerId); } catch { /* noop */ }
        this._lastDist = this._distance();
        this._lastMid = this._midpoint();
        this._panOrigin = null;
      } else if (this._pointers.size === 1 && this.zoomed) {
        // Só faz pan se já estiver ampliado — caso contrário, deixa o jogo clicar.
        e.preventDefault();
        try { t.setPointerCapture(e.pointerId); } catch { /* noop */ }
        this._panOrigin = { x: e.clientX - this.tx, y: e.clientY - this.ty, t: Date.now(), moved: false };
      } else {
        // 1 dedo em 1×: NÃO captura, NÃO preventDefault. O jogo recebe o toque.
        // Apenas registra o toque para detecção de duplo-toque.
        this._panOrigin = { x: e.clientX, y: e.clientY, t: Date.now(), moved: false, passive: true };
      }
    }, { passive: false });

    t.addEventListener('pointermove', (e) => {
      if (!this._enabled || !this._pointers.has(e.pointerId)) return;
      this._pointers.set(e.pointerId, { x: e.clientX, y: e.clientY });

      if (this._pointers.size === 2) {
        e.preventDefault();
        const d = this._distance();
        const mid = this._midpoint();
        if (this._lastDist > 0) this._zoomAt(mid.x, mid.y, this.scale * (d / this._lastDist));
        if (this._lastMid) { this.tx += mid.x - this._lastMid.x; this.ty += mid.y - this._lastMid.y; this._apply(); }
        this._lastDist = d;
        this._lastMid = mid;
      } else if (this._pointers.size === 1 && this._panOrigin && !this._panOrigin.passive) {
        e.preventDefault();
        this._panOrigin.moved = true;
        this.tx = e.clientX - this._panOrigin.x;
        this.ty = e.clientY - this._panOrigin.y;
        this._apply();
      } else if (this._panOrigin?.passive) {
        const dx = e.clientX - this._panOrigin.x;
        const dy = e.clientY - this._panOrigin.y;
        if (Math.hypot(dx, dy) > 8) this._panOrigin.moved = true;
      }
    }, { passive: false });

    const end = (e) => {
      if (!this._pointers.has(e.pointerId)) return;
      const wasPassive = this._panOrigin?.passive === true;
      const tapTime = this._panOrigin ? (Date.now() - this._panOrigin.t) : 9999;
      const moved = this._panOrigin?.moved ?? true;

      this._pointers.delete(e.pointerId);
      try { t.releasePointerCapture(e.pointerId); } catch { /* noop */ }

      if (wasPassive && !moved && tapTime < 260 && this.scale === 1) {
        // duplo toque → alterna 1× / 2×
        const now = Date.now();
        if (now - this._lastTap < 320) {
          this.scale = 2; this.tx = 0; this.ty = 0; this._apply();
          this._lastTap = 0;
        } else {
          this._lastTap = now;
        }
      }
      if (this._pointers.size < 2) { this._lastDist = 0; this._lastMid = null; }
      if (this._pointers.size === 0) this._panOrigin = null;
    };
    t.addEventListener('pointerup', end, { passive: false });
    t.addEventListener('pointercancel', end, { passive: false });
  }

  _distance() {
    const [a, b] = [...this._pointers.values()];
    return Math.hypot(a.x - b.x, a.y - b.y) || 1;
  }
  _midpoint() {
    const [a, b] = [...this._pointers.values()];
    return { x: (a.x + b.x) / 2, y: (a.y + b.y) / 2 };
  }

  _zoomAt(cx, cy, newScale) {
    newScale = Math.max(this.min, Math.min(this.max, newScale));
    if (Math.abs(newScale - this.scale) < 0.001) return;
    const k = newScale / this.scale;
    this.tx = cx - k * (cx - this.tx);
    this.ty = cy - k * (cy - this.ty);
    this.scale = newScale;
    this._apply();
  }

  _apply() {
    const w = this.target.clientWidth;
    const h = this.target.clientHeight;
    const maxX = Math.max(0, (this.scale - 1) * w);
    const maxY = Math.max(0, (this.scale - 1) * h);
    this.tx = Math.max(-maxX, Math.min(0, this.tx));
    this.ty = Math.max(-maxY, Math.min(0, this.ty));

    this.target.style.transform = `translate(${this.tx}px, ${this.ty}px) scale(${this.scale})`;
    this.onChange(this.scale, this.tx, this.ty);
  }

  reset() { this.scale = 1; this.tx = 0; this.ty = 0; this._apply(); }
  zoomIn() { this._zoomAt(this.target.clientWidth / 2, this.target.clientHeight / 2, this.scale * 1.5); }
  zoomOut() { this._zoomAt(this.target.clientWidth / 2, this.target.clientHeight / 2, this.scale / 1.5); }
}