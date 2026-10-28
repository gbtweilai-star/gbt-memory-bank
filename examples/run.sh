#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
PYTHONPATH=src python -m gbt_memory_bank info
PYTHONPATH=src python -m gbt_memory_bank check --payload '{}'
PYTHONPATH=src python -m gbt_memory_bank run   --payload '{}'
