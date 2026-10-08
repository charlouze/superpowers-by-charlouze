# L'extraction de writing-in-a-gaps-register Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** La skill interne `writing-in-a-gaps-register` porte la forme du gaps register, les règles d'une entrée et les gestes, et les skills qui écrivent dans un gaps register l'invoquent à la place de leur copie.

**Architecture:** `writing-in-a-gaps-register` reçoit de `adopting-a-module` la forme du gaps register et les règles d'une entrée, et de chaque skill qui en portait une copie le texte des gestes : ajouter, supprimer, réserver, libérer. `adopting-a-module`, `closing-a-batch`, `using-batches`, `writing-a-batch` et `writing-a-user-story` l'invoquent avant d'écrire dans un gaps register, et ne gardent que ce qui est propre à leur étape : quel geste, sur quelle entrée, à quel moment. Les gardes du texte suivent le texte, et chaque contrat `shared` qui exigeait des copies devient une garde sur `writing-in-a-gaps-register` et une garde sur chaque skill qui l'invoque.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Rulings log

## Observed drift
