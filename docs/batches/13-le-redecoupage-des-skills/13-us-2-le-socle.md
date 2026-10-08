# Le socle following-the-rules Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `following-the-rules` porte ce qui vaut en permanence, toute skill d'entrée l'invoque en commençant, et les règles du code gardé par un flag n'ont plus de reformulation partielle.

**Architecture:** Le socle reçoit de `using-batches` le modèle, le modèle git, l'autorité, la langue, la concision et la conversation, et de `writing-a-user-story` les règles d'exécution, la forme de la mention de flag et les règles du code gardé. `writing-a-user-story` garde les textes que `Global Constraints` recopie, qu'un contrat `shared` tient identiques à ceux du socle.

**Tech Stack:** Markdown, bash.

**Spec:** docs/specs/supercharlouze.md
**Batch:** docs/batches/13-le-redecoupage-des-skills/README.md
**Sections:** Feature flags > Code under a feature flag, Story > The user story document
**Blocks:** none

Cette story n'est pas technique : son premier commit supprime l'entrée du gaps register qu'elle résorbe, et une story technique ne retire rien.

## Rulings log

## Observed drift
