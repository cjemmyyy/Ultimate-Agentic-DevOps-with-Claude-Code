# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Static HTML/CSS portfolio website deployed to AWS using S3 and CloudFront, provisioned with Terraform, and automated via GitHub Actions

## Architecture

Pure HTML5 and CSS3. No JavaScript. No build step. No framework.

- **`index.html`** — the main single-page site with all sections: navbar, hero, book, courses, contact, footer, community/trust. Uses inline `<script>` at the bottom (hamburger menu toggle + smooth scroll). Links to Font Awesome 6.5 via CDN.
- **`privacy.html`** / **`terms.html`** — standalone legal pages with self-contained inline `<style>` blocks (dark theme `#111827` background, different from the main site).
- **`style.css`** — All styles for `index.html`. Responsive breakpoints at 900px (tablet) and 600px/768px (mobile). Color scheme: black/white with yellow (`#facc15`) and blue (`#3b82f6`) accents. CSS-only animations (`fadeUp` keyframes).
- **`images/`** — static assets (logo, profile, signature, book covers, hero banner)

## Commands

```bash
# Terraform
cd terraform && terraform init
cd terraform && terraform plan
cd terraform && terraform apply
```

## Key Conventions

- All infrastructure changes go through Terraform — never modify AWS resources manually
- No JavaScript in this project
- CSS uses mobile-first approach with breakpoints at 900px, 768px, and 600px

## Safety

Never put secrets in this file. No API keys, passwords, or AWS credentials.

