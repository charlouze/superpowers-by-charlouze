# L'extraction de abandoning-a-story Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `abandoning-a-story` porte le geste d'abandon d'une story, et les skills qui le recopiaient l'invoquent à la place de leur copie.

**Architecture:** `abandoning-a-story` reçoit la branche de la story. Elle ferme sa pull request sans la fusionner s'il y en a une, supprime la branche en local et sur le remote, et retire l'espace de travail. `writing-a-batch` et `writing-a-user-story` l'invoquent là où elles écrivaient le geste, et chacune garde le moment où elle abandonne. Les gardes du texte suivent le texte, et le contrat `shared` qui exigeait des copies devient une garde sur `abandoning-a-story` et une garde sur chaque skill qui l'invoque.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Rulings log

## Observed drift
