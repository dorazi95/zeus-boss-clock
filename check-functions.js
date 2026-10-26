// 배포 전 점검: 호출하는데 정의되지 않은 함수가 있는지 본다.
// 문법 검사만으로는 "함수가 사라진" 실수를 못 잡는다.
const fs = require('fs');
const js = fs.readFileSync(process.argv[2] || 'index.html', 'utf8').match(/<script>([\s\S]*)<\/script>/)[1];
const def = new Set();
for (const m of js.matchAll(/function\s*([A-Za-z_$][\w$]*)?\s*\(([^)]*)\)/g)) {
  if (m[1]) def.add(m[1]);
  m[2].split(',').forEach(p => { const n = p.trim(); if (/^[A-Za-z_$][\w$]*$/.test(n)) def.add(n); });
}
for (const m of js.matchAll(/\bvar\s+([^;\n]+)/g))
  m[1].split(',').forEach(p => { const n = p.trim().split(/[\s=]/)[0]; if (/^[A-Za-z_$][\w$]*$/.test(n)) def.add(n); });
for (const m of js.matchAll(/\bcatch\s*\(\s*([A-Za-z_$][\w$]*)/g)) def.add(m[1]);
const called = new Set();
for (const m of js.matchAll(/(?:^|[^.\w$'"])([a-z][\w$]*|[A-Z][A-Z_0-9]{2,})\s*\(/gm)) called.add(m[1]);
const builtin = new Set(['if','for','while','switch','catch','return','typeof','function','new','do','else','try','var','parseInt','parseFloat','isNaN','fetch','alert','confirm','require','setTimeout','setInterval','clearInterval','clearTimeout','encodeURIComponent','decodeURIComponent','String','Number','Boolean','Array','Object','Date','Math','JSON','Promise','Error','RegExp','Image','Response','EventSource','AudioContext','SpeechSynthesisUtterance','PointerEvent','Event']);
const missing = [...called].filter(n => !def.has(n) && !builtin.has(n));
if (missing.length) { console.error('✗ 정의되지 않은 함수: ' + missing.join(', ')); process.exit(1); }
console.log('✓ 함수 점검 통과');
