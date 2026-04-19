# onboarding-skill-mobile

A bundle of four Claude skills for designing and shipping **high-converting mobile app onboarding flows** — plus a one-command installer so any Claude-compatible harness (Claude Code, Antigravity, etc.) picks them up automatically.

> Onboarding is the single highest-leverage surface in a mobile app. Day-one retention hovers near 20% across the ecosystem — **80% of users churn after one session** — and nearly every churn decision happens in the first ~60 seconds. These skills codify what actually moves that number, distilled from ~2,300 studied onboarding flows and teardowns of 30+ winning apps (Duolingo, Cal AI, Noom, Notion, Slack, Linear, Headspace, Grammarly, and more).

---

## Install

```bash
git clone https://github.com/vrn7712/onboarding-skill-mobile.git
cd onboarding-skill-mobile
./skills.sh
```

That drops all four skills into `~/.claude/skills/`. Restart your Claude harness and the skills auto-register.

Other install modes:

```bash
./skills.sh install --project     # install to ./.claude/skills (project-scoped)
./skills.sh install --target DIR  # install to a custom directory
./skills.sh install --force       # overwrite any existing install
./skills.sh install --dry-run     # preview what would happen
./skills.sh uninstall             # reverse the install
./skills.sh list                  # show what's in the bundle
./skills.sh status                # show what's currently installed
./skills.sh help                  # show all options
```

Cross-platform: macOS, Linux, WSL, Git Bash on Windows.

---

## The four skills

Each skill is narrowly scoped and triggered independently by Claude's skill system. Used together, they cover the full design → copy → trust → ship lifecycle of a mobile onboarding flow.

### 1. `mobile-onboarding-blueprint` — strategic design

The **"what to build"** skill. Invoked at the start of any onboarding work.

- Canonical 12-step anatomy of a best-in-class flow
- Niche → length decision matrix (fitness 30–80 screens, SaaS 3–8, AI 0–5, finance 20–40, etc.)
- Hard-gate vs soft-gate decision framework
- Deferred-registration (gradual engagement) doctrine
- When to skip onboarding entirely
- Teardowns of 30+ winning apps

### 2. `mobile-onboarding-psychology` — principles & copy

The **"why each screen works"** skill. Invoked for any copywriting or microcopy work.

- Ten load-bearing psychological principles (Endowed Progress, Peak-End, Loss Aversion, Zeigarnik, Cognitive Load, Commitment & Consistency, reason-giving, social proof, personalization, honesty-as-trust)
- Copy formulas for value-prop, quiz, affirmation, and outcome-reveal screens
- Microcopy templates by screen type
- Cultural / demographic adaptation
- Mascot trend and originality as a lever
- A full catalog of anti-patterns to avoid

### 3. `mobile-onboarding-permissions-and-paywall` — trust moments

The **"sensitive-ask"** skill. Invoked for permission prompts, data collection, and paywall design.

- The Double-Gate permission strategy (12–17% blind → ~70% primed opt-in)
- Per-permission microcopy templates (camera, location, notifications, ATT, contacts, health, calendar, photos)
- Progressive profiling rules
- Decoy pricing (the Steve Young framework)
- Blinkist-style trial reassurance timeline
- Quiz-tailored pricing (Grammarly's +20%)
- Apple's 2026 policy changes (what's banned, what still works)
- Attribution survey design with randomization

### 4. `mobile-onboarding-implementation` — code, metrics, experiments

The **"how to ship and iterate"** skill. Invoked for implementation, instrumentation, and A/B testing work.

- The mount-all + CSS-toggle pattern (React, React Native, SwiftUI, Flutter)
- Magic link + SSO + OTP autofill authentication
- Remote Config architecture for per-screen A/B testing
- Mixpanel-standard analytics event schema
- A/B testing protocol (one change at a time, sample-size calc, significance)
- Metrics benchmarks (TTV, open→trial, trial→paid, D1/D7/D30 retention, DAU/MAU)
- The 23.5-hour push retention pattern
- Skeleton screens, haptic feedback, Glassmorphism
- Full tooling stack recommendations (indie and scaled)

---

## How the skills trigger

Each skill's frontmatter contains a `description` that lists trigger phrases. When you ask Claude something like:

- *"Help me design an onboarding flow for my fitness app"* → `blueprint`
- *"Rewrite this welcome screen to be more compelling"* → `psychology`
- *"Should I ask for notifications on first launch?"* → `permissions-and-paywall`
- *"Set up A/B testing on my onboarding quiz"* → `implementation`

...Claude auto-loads the relevant skill. The four are designed to compose: a full onboarding project typically invokes all of them in sequence.

---

## Repository structure

```
onboarding-skill-mobile/
├── README.md
├── skills.sh                    # installer
└── skills/
    ├── mobile-onboarding-blueprint/
    │   └── SKILL.md
    ├── mobile-onboarding-psychology/
    │   └── SKILL.md
    ├── mobile-onboarding-permissions-and-paywall/
    │   └── SKILL.md
    └── mobile-onboarding-implementation/
        └── SKILL.md
```

---

## License

MIT — use it, fork it, ship it. Attribution appreciated but not required.
