# memory_bank

**One capability bit from GBT V8, packaged standalone.** No. 163 of 341,
`mind` domain (Mind).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 记忆银行：**来源追踪 + 别名 + 零停机迁移**（蒸馏自 GitHub 周榜 #01 hindsight，只取架构）：`stamp` 给每条记忆打来源印章（ref/sha256/origin/session/why/evidence）；`trace` 同时报**印章在不在**与**内容有没有被改过**（当前 sha vs 印章 sha）；`alias`/`resolve` 记忆库别名（多级链 + **环检测**）；`migrate`/`migrate_apply` 搬家**先双写→逐文件校 sha→原子切别名→失败回滚**，旧目标只读保留（无删除路径）。op=stamp/trace/alias/resolve/aliases/migrate/migrate_apply/verify/where

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-memory-bank.git
cd gbt-memory-bank
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_memory_bank info                  # capability card
python -m gbt_memory_bank spec --json           # machine-readable contract
python -m gbt_memory_bank check --payload '{}'
python -m gbt_memory_bank run   --payload '{}'
```

Real `info` output from this machine:

```text
memory_bank  (mind)  v1.0.0
----------------------------------------
记忆银行：**来源追踪 + 别名 + 零停机迁移**（蒸馏自 GitHub 周榜 #01 hindsight，只取架构）：`stamp` 给每条记忆打来源印章（ref/sha256/origin/session/why/evidence）；`trace` 同时报**印章在不在**与**内容有没有被改过**（当前 sha vs 印章 sha）；`alias`/`resolve` 记忆库别名（多级链 + **环检测**）；`migrate`/`migrate_apply` 搬家**先双写→逐文件校 sha→原子切别名→失败回滚**，旧目标只读保留（无删除路径）。op=stamp/trace/alias/resolve/aliases/migrate/migrate_apply/verify/where

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : ref, sha256, origin, session, why, evidence
```

Wire a real implementation:

```python
from gbt_memory_bank import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（6 个）**：`ref`、`sha256`、`origin`、`session`、`why`、`evidence`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `memory_bank` |
| domain | `mind` |
| handler | `memory_bank` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [mind/memory_bank](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/mind/memory_bank.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
