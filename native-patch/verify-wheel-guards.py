"""Verify wheel hooks against the locally generated drawing templates.

Usage: python verify-wheel-guards.py PATH_TO_RAC_RS_INSTALLATION
Reads source files only. Requires the generated PAL v1.00 recompiler tree.
"""
from pathlib import Path
import re
import sys

root = Path(sys.argv[1]).resolve()
source = (root / "rac-rs/src/retail/rift_wheel.rs").read_text(encoding="utf-8")
entries = re.findall(
    r"Hand\{entry:(0x[0-9a-f]+),end:(0x[0-9a-f]+),hash:(0x[0-9a-f]+),est:0,f:hide\}, // level (\d+)",
    source,
)
assert entries, "No guarded draw entries found"
cache = {}
for address, end, digest, level in entries:
    if level not in cache:
        cache[level] = [
            p.read_text(encoding="utf-8")
            for p in (root / "oracle/rec").glob(f"l{level}_*/src/lib.rs")
        ]
    wrapper = rf"pub fn f_{address[2:]}\(c: &mut Cpu\) \{{ rec_sh_04::t_(350|353)\("
    matches = [(s, re.search(wrapper, s)) for s in cache[level]]
    matches = [(s, m) for s, m in matches if m]
    assert len(matches) == 1, f"Not an exact drawing template: level {level}, {address}"
    generated, template = matches[0]
    length = {350: 0x870, 353: 0x628}[int(template[1])]
    assert int(end, 16) - int(address, 16) == length, (level, address, "length")
    metadata = rf"Fn \{{ entry: {address}, end: {end}, hash: {digest},"
    assert re.search(metadata, generated), (level, address, "hash/end")
assert "a<z &&" in source, "An empty level range must use the fallback"
assert "c.mem.wr8(BASE+0x48,2)" in source, "Guard revision handshake missing"
print(f"Verified {len(entries)} exact draw routines on {len(cache)} level layouts; no gameplay routines admitted.")
