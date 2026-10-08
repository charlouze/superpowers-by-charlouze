# L'extraction de writing-in-a-spec Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `writing-in-a-spec` porte ce qu'une spec contient, et les skills qui écrivent dans une spec l'invoquent à la place de leur copie.

**Architecture:** `writing-in-a-spec` reçoit de `using-batches` la section `What a Spec Says` et les lignes de `Red Flags` qui s'y rattachent. `using-batches`, `adopting-a-module`, `writing-a-batch` et `writing-a-user-story` l'invoquent là où elles écrivent un texte de spec, et ne gardent que ce qui est propre à leur étape. Les gardes du texte suivent le texte, et le contrat `shared` sur la question du test devient une garde sur `writing-in-a-spec` et une garde sur chaque skill qui l'invoque.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Rulings log

## Observed drift
