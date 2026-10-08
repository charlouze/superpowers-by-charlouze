# Writing a Batch Document Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Extraire dans la skill interne `writing-a-batch-document` la forme du document de lot et de ses champs, que `writing-a-batch` porte aujourd'hui.

**Architecture:** `writing-a-batch-document` reçoit de la skill qui l'invoque le `NN` et le slug d'un document à écrire, ou le document existant et ce qui y change. `writing-a-batch` l'invoque à l'ouverture et dans un amendement, et garde la conduite des deux. Les gardes qui tenaient le texte déplacé le suivent dans la nouvelle skill.

**Tech Stack:** Markdown pour les skills, Bash pour la suite de `tests/`.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** none
**Blocks:** none
**Technical:** yes

## Rulings log

## Observed drift
