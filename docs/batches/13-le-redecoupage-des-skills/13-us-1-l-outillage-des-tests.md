# L'outillage des tests Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La suite de tests lit la liste des skills et leur type dans un fichier de données, et porte les gardes génériques que les stories suivantes du lot complètent sans retoucher l'outillage.

**Architecture:** `tests/skills.txt` déclare chaque skill et son type. `tests/lib.sh`, que chaque fichier de test charge, lit cette liste et porte l'outil de lecture et les gardes de contenu, qui lisent aussi les `references/` d'une skill.

**Tech Stack:** bash, awk, sed, grep.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Rulings log

## Observed drift
