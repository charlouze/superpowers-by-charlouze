# L'extraction de detecting-concurrency Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `detecting-concurrency` porte la détection de concurrence, et les skills qui la conduisaient l'invoquent à la place de leur copie.

**Architecture:** `detecting-concurrency` reçoit la spec, les sections et, quand elle existe, la branche du travail, qu'elle écarte de sa lecture. Elle fetch, lit les déclarations des travaux en vol sur le remote, et rend les conflits et les déclarations illisibles. `writing-a-user-story` l'invoque à son étape 1 et `using-batches` pour le changement borné ; chacune lui passe ce qui varie et garde l'arrêt. `following-the-rules` garde la définition d'un conflit et de ce qu'un travail déclare. Les gardes du texte suivent le texte, et chaque contrat `shared` qui exigeait des copies devient une garde sur `detecting-concurrency` et une garde sur chaque skill qui l'invoque.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Rulings log

## Observed drift
