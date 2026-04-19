---
name: mobile-onboarding-blueprint
description: Design the strategic structure of a mobile app onboarding flow — the screen-by-screen blueprint, canonical anatomy, niche-to-length matching, hard-vs-soft gating, deferred registration, and when to skip onboarding entirely. Invoke this skill at the start of any mobile onboarding work to decide WHAT to build before writing copy, code, or paywalls. Triggers: "design onboarding flow", "plan onboarding", "first-run experience", "onboarding structure", "how many onboarding screens", "should we have onboarding", "onboarding blueprint", "activation flow", "aha moment", "welcome screen", "deferred signup", "gradual engagement", "onboarding for fitness app / fintech / AI / SaaS / astrology". Use BEFORE the psychology/copy, permissions/paywall, or implementation skills — this one defines the skeleton they fill in.
---

# Mobile Onboarding — Blueprint Skill (Strategic Design)

This is the **"what to build"** skill. It decides the shape of the flow before anyone writes copy, picks a psychology lever, or touches code. Get this wrong and the most beautiful screens in the world won't save the funnel.

Three sibling skills handle downstream concerns — invoke them after this one:
- `mobile-onboarding-psychology` — the principles and copy inside each screen
- `mobile-onboarding-permissions-and-paywall` — the sensitive-ask moments
- `mobile-onboarding-implementation` — the code, A/B testing, and metrics

---

## 1. The operating thesis

Day-one retention sits at ~20% across mobile. **80% of downloads churn after one session** — and almost every churn decision happens in the first ~60 seconds. Onboarding is not a tutorial; it's a **conversion funnel**. Every screen is a conversion event. Treat it as the highest-leverage product surface you own.

Two non-negotiable framings:

1. **Goal of onboarding = deliver the user to their "aha moment" as fast as the niche allows, and convert that moment into a trial / signup / habit.** The aha is the first taste of core value: Airbnb's first booking, Netflix finding a show to watch, Mobin saving its first pin, Duolingo completing the first translation, Cal AI's first food photo.

2. **Onboarding flow and paywall are the same object.** Do not design them as separate features. A beautiful paywall preceded by a weak quiz leaves 5× money on the table; a strong onboarding followed by a cookie-cutter paywall wastes the commitment. Build them together.

For **new apps without features yet**: build the onboarding flow AND paywall FIRST. It forces decisions about copy, colors, psychology, value prop, and niche positioning. Feature work comes after. — Alex Schievano, screens.design

---

## 2. The plane-seat mental model

When the user opens your app for the first time, imagine they've just boarded a plane and fastened their seatbelt. For the next 60–90 seconds they are a **captive audience** — inches from the in-flight entertainment, not going anywhere. You have four jobs in that window:

| Stage | Goal | Duration |
|---|---|---|
| 1. Hook | Congratulate, show outcome (not features), establish social proof | ~5–15s |
| 2. Personalize | 1–5 intent/quiz questions that shape everything downstream | ~30–180s |
| 3. Deliver aha | Let them feel the value (first translation, first photo, first pin) | ~20–60s |
| 4. Commit | Prime permissions, then paywall / signup at peak-value | ~20–60s |

Each stage can be 1 screen or 40. Length is a function of niche (see §4), not taste.

---

## 3. Canonical 12-step anatomy

This is the structural skeleton of a best-in-class mobile onboarding flow. Implement in this order. Skip steps that don't apply, but **do not reorder without a tested hypothesis** — the sequence exploits specific psychological dependencies.

1. **Splash** — brand logo, subtle animation covering app initialization. ≤1s for utility, ≤3s for entertainment. Longer = impatience.
2. **Welcome / value proposition** — one screen, one sentence, show outcome not features. Animate or demo the product. Include social proof (logos, user count, review stars).
3. **Intent routing** (1–3 questions) — "Why are you here?" / "What's your goal?" / "What's your experience level?" Answers dynamically reconfigure templates, UI surfaces, default settings, and copy downstream.
4. **Personalization quiz** (optional, niche-dependent) — deeper profiling. Each question must visibly change the eventual plan/output. Every question needs a reason-given in its subtitle.
5. **Affirmation + stat screens** interleaved with quiz blocks — "Losing 5kg is realistic. 80% of our users hit their goal in 6 months." Breaks up form fatigue, delivers dopamine.
6. **Build-your-plan loader** — 3–5s "Analyzing your answers / Calibrating your plan / Crunching the numbers…". Performative compute. Users need to feel their input was consumed. Works in fitness, astrology, finance, anywhere a quiz was used. Do NOT use in productivity/business apps with no quiz — looks fake.
7. **Personalized outcome reveal** — "You'll hit 65kg by Aug 14" / "Your workspace is ready" / graph of the progress curve. This is the **peak** in Peak-End Rule terms. Make it emotional.
8. **Permission pre-prompts** — branded custom modals for notifications / tracking / camera / location BEFORE the OS dialog. See `mobile-onboarding-permissions-and-paywall`.
9. **Core action / first win (the aha)** — user does the thing. Translate a sentence. Take a food photo. Save a pin. Send a test message. Create a first page. Resolve a first issue.
10. **Checklist / scaffolded next steps** — persistent 3–6 item list replacing the blank-canvas feeling. Mural replacing popups with a 6-step checklist drove **+10% one-week retention**.
11. **Paywall** — at the peak of perceived value. Decoy pricing, social proof, reassurance timeline. See `mobile-onboarding-permissions-and-paywall`.
12. **Deferred signup / account creation** — AFTER trial activation or core action. Framed as "save your progress" / "sync across devices", never as a toll gate. Duolingo puts the user through 60 screens + a full lesson before this step.

### Trimmed skeletons by pattern
| Pattern | Minimum viable sequence |
|---|---|
| Utility / AI-first | 1 → 2 → 9 (skip quiz, paywall later, signup way later) |
| SaaS / productivity | 1 → 2 → 3 → 10 → 9 → 11 → 12 |
| Consumer (social, photo, content) | 1 → 2 → 3 → 8 → 9 → 10 → 11 → 12 |
| Quiz-driven (fitness, astrology, finance, health) | 1 → 2 → 3 → 4×N → 5×N → 6 → 7 → 8 → 11 → 9 → 12 |

---

## 4. Niche → length decision matrix

Industry average: **25 screens**. Variance by niche is enormous — copying Duolingo's 60-screen flow for a business SaaS tool will kill it. **Top 7 of the 10 longest flows in the industry are finance apps.** Match length to niche, never to taste.

| Niche | Typical screen count | Why this length works | Anchor apps |
|---|---|---|---|
| Fitness / health / diet | 30–80 | Quiz → personalized plan → endowment effect + commitment bias | Cal AI (~20), Noom (~80), Bitepal (61), Headspace |
| Finance / fintech / banking | 20–40 | Security theater + regulatory friction + trust-building | Wise, traditional banking, Acorns, PayPal |
| Astrology / spiritual / horoscope | 20–40 | Birth chart data is genuinely required + commitment | Co-Star, Starla, Pattern |
| Language / education | 20–60 | Gradual engagement: win before signup | Duolingo (~60), Babbel, Brilliant, Speak |
| Dating | 15–30 | Profile depth = match quality; one input per screen | Tinder, Bumble, Hinge |
| SaaS / productivity | 3–8 | Intent routing + task-driven checklist, no quiz | Notion, Linear, Slack, Asana, Superhuman |
| Consumer social / content / photo | 2–8 | Product is visual, grid speaks for itself | Instagram, Pinterest, TikTok |
| AI chat / AI utility / inspiration | 0–5 | First prompt IS the aha moment — get out of the way | ChatGPT, Claude, Mobin, Alma |
| Entertainment / streaming | 3–6 | Content library is the value prop | Netflix, Spotify |
| Games (hyper-casual) | 0–3 | Play → ads; tutorial embedded in first level | Most Unity games |

### The length paradox
Three of the shortest flows in the industry are AI products. Several of the longest (Cal AI, Duolingo, Bitepal) are the most successful. **Short is not better. Appropriate is better.**

Why long works when it works:
- The more data a user inputs, the more committed they feel (sunk-cost / endowment).
- More data = genuinely better personalization = higher perceived value.
- Affirmation stats between questions deliver dopamine every 2–3 screens.
- By screen 50, quitting feels like losing something they built.

Why short works when it works:
- AI/utility products prove themselves on the first prompt — any quiz is a roadblock.
- Visual/inspiration products sell themselves in the grid — tell-don't-show.
- Returning users reinstalling on a new device want a fast path.

---

## 5. Hard vs soft gating — the decision

Every onboarding must decide: do we force the user to cross a barrier (payment, signup, full quiz) before delivering any value, or do we always offer a "Skip" / "Not now" escape hatch?

| Strategy | Mechanism | Ideal niches | Trial-to-paid benchmark | Risk |
|---|---|---|---|---|
| **Hard gate** | Must pay/signup/complete before *any* value is delivered | Fitness, premium journalism, single-purpose utilities with acute value, high-security fintech | ~35% (fitness) | Brutal in discretionary categories — immediate uninstall if value not acutely needed |
| **Soft gate** | "Skip", "Not now", "Maybe later" always visible | Consumer SaaS, social, entertainment, general productivity, AI chat | Lower immediate revenue, higher lead quality and LTV | Fewer immediate conversions; slower to monetize |

### Hybrid: the "try before you buy" cheat code
One pattern that outperforms both: let users try the **core AI feature** once before any gate. Alma does this with voice AI. This is rare in AI apps and highly effective — it bypasses the trust-in-AI barrier.

### Gating decision flowchart
1. Is the app's value acute/need-based (I'm trying to lose weight / get a job / manage my taxes)? → **Hard gate works**
2. Is the app's value discretionary/nice-to-have (productivity, content, social)? → **Soft gate**
3. Is there regulatory/compliance friction (fintech, healthcare)? → Hard gate is expected and signals trust
4. Do users have unlimited free alternatives in the category? → **Soft gate**
5. Is the aha moment cheap to deliver (AI prompt, first photo)? → Try-before-buy hybrid

---

## 6. Deferred registration (gradual engagement) — the doctrine

The single highest-leverage architectural decision in consumer onboarding: **delay the signup screen until the user has already achieved a win.**

Duolingo's flow:
- Screens 1–60: intent, quiz, personalization, first actual lesson, first "Correct!" celebration, streak start.
- Screen 61: "Sign up to save your progress."

At that point the user has invested 5 minutes, earned a virtual reward, and is attached. Signup is framed as **loss prevention** (protect what I built), not as a **toll gate**. Conversion lifts dramatically versus front-loaded signup.

### When deferred registration works
- Progress / state / personalization can be stored locally first, synced to server on signup
- The first win is cheap to deliver without a server account
- You're not in a hard-regulated niche (fintech KYC, healthcare)

### Technical requirement
Local-first state. Persist quiz answers, created content, progress, streak, and app config to device storage (AsyncStorage / UserDefaults / MMKV). On signup, push to server. See `mobile-onboarding-implementation`.

### Counter-case: hard-gate fintech
Signup/KYC up front is the RIGHT move for a neobank or investment app — users expect it, and not asking would feel like a red flag. Match the pattern to the trust level your category requires.

---

## 7. When NOT to build onboarding

Not every app needs an onboarding flow. Some products are actively hurt by one.

| Product type | Why onboarding hurts | What to do instead |
|---|---|---|
| AI chat (ChatGPT, Claude-consumer) | First prompt is the aha — any delay is friction | Empty input field, one-line placeholder hint |
| Visual inspiration (Mobin, Pinterest) | The grid sells itself | Straight to grid, tooltips only on first interaction |
| Content apps where discovery = value | Forced quiz delays the feed | Minimal language/region selection, then feed |
| Returning users on a new device | They already know the product | "I already have an account" visible on screen 1 |
| Hyper-casual games | Tutorial belongs IN the first level | Embed tutorial as gameplay |

### The 5-second test
If a human engineer can articulate the app's value in under 5 seconds by just pointing at the home screen, you probably don't need a 20-step quiz to say it in words. Show, don't sell.

### Returning-user escape hatch (always)
Every onboarding flow — even 60 screens long — must show "I already have an account" or "Log in" on screen 1 or 2. Power users, re-installers, and users with a new phone will rage-uninstall otherwise.

---

## 8. Regional and cultural considerations

**Web onboarding is 21% shorter than iOS onboarding** on average. Why: mobile has permission prompts, paywalls, native integrations, and higher trust-capital required. Don't try to cut mobile flows to web lengths.

**Eastern markets tolerate information-heavy interfaces better than Western markets.** What reads as "cluttered" to a US/UK user reads as "efficient" to a user in Japan, Korea, or China. If targeting those regions, don't over-minimize.

If shipping globally, consider:
- Geo-based Remote Config variants (see `mobile-onboarding-implementation`)
- Localized social proof (regional testimonials, local press logos)
- Platform-default copy tone (iOS polite, Android direct, Chinese markets value detail)

---

## 9. Case teardowns — blueprints to steal

| App | Niche | Signature structural move | Replicable pattern |
|---|---|---|---|
| **Duolingo** | Education | 60 screens + full first lesson before signup; streak reward mid-flow | Deferred registration via gradual engagement; "save your progress" framing |
| **Cal AI** | Fitness | 20 screens: market research → personalization → stats → privacy → plan reveal → paywall | Interleave affirmation stats between quiz blocks; market-research questions mid-funnel; "first 7 days slow" honest promise reduces refunds |
| **Noom** | Weight loss | ~80-screen quiz with behavioral-science positioning | Commitment through quiz length; psych-pretense as differentiation |
| **Notion** | SaaS | 1 intent question → AI-generated starter workspace | Eliminate blank-canvas paralysis with templated defaults |
| **Slack** | SaaS | Magic-link auth + behavior-triggered tooltips | Zero-password entry; teach only what the user touches |
| **Linear** | SaaS | Mandatory task-driven checklist; Cmd+K taught on screen 1 | Force real UI interaction instead of watching a tour |
| **Airbnb** | Marketplace | CEO video shown at aha moment (first listing published), not at signup | Save founder touch for the peak, not the start |
| **Headspace** | Wellness | Multi-select (not single-select) on goals | One checkbox change → +10% trial conversion |
| **Tinder** | Dating | Acknowledges your birthday | Human moments over generic copy |
| **Bumble** | Dating | Animated loading & verification screens | Make dull steps delightful; never leave a blank loading |
| **Bitepal** | Diet | 61 screens; name your virtual raccoon | Endowment via character attachment |
| **Base Camp** | SaaS | Personal founder note post-signup | Intention signal, not sales |
| **Superhuman** | Productivity | Signup with company logos as social proof sidebar | Copy tweak, massive trust lift |
| **Alma** | AI | Try the core AI feature before signup | Lowers AI-trust barrier; rare and effective |
| **Grammarly** | Productivity | Quiz-tailored pricing plans at paywall | +20% plan upgrades from quiz-driven price personalization |
| **Focus Flight** | Lifestyle | Choose map style during onboarding; flight-ticket-shaped paywall with haptic "printing" | Early personalization (map style) + delightful paywall |
| **Timo** | Finance | Full-page social proof immediately before paywall | Social-proof-then-paywall sequencing |
| **One Year** | Lifestyle | Handwritten founder's note in onboarding | Humanization > polish |
| **Brilliant** | Education | Home page already populated with personalized courses on first open | "You haven't used it yet, but it works" feeling |
| **Dollar Shave Club** | Commerce | Conversational quiz copy | +5% subscriptions from tone alone |
| **House** | Productivity | Split signup form across multiple screens | +15% conversion from splitting one form into N |
| **Mural** | SaaS | Replaced popups with a 6-step checklist | +10% one-week retention |
| **Cool Center** | Utility | Shows preview of the actual notification during pre-prompt | +opt-in rate on notifications |
| **Cake Equity** | Fintech | Tooltips explaining dry financial concepts + real-time password validation | Contextual teaching of abstract concepts |
| **Shazam** | Utility | Minimalist, one-tap onboarding | Product does the talking |
| **BoostUp Social** | Creator tools | Instagram-stories row of real user testimonials during paywall | Familiar UI pattern + authentic proof = high trust |
| **Tight** | Wellness | Download → 2 questions → watch → customize → signup | Minimal quiz + personalization preview |
| **Speak** | Language | "In 2 months you'll be able to communicate while traveling in France" + graph | Time-bound promise + visual proof |
| **Front Butts** | Consumer | Animation on app open — no words needed | Show don't tell, taken to extreme |
| **Beside** | Wellness | Quiz paired with one-time offer for urgency at paywall | Quiz → urgency → convert |
| **Endos** | Wellness | 6-question quiz → personalized outcome reveal screen | Every question visibly shapes the reveal |

---

## 10. Creative originality — the hidden lever

Cookie-cutter flows (identical welcome → quiz → paywall patterns across multiple apps from the same studio) leave money on the table. Apple will increasingly reject them. Users have seen dozens.

The fix is not to ignore frameworks — it's to **add one truly original element**. Examples:
- **BoostUp Social** animated a triangle showing their three-corner value prop. +3–4% open-to-trial. That's a material lift from one creative choice.
- **Mascots** (friendly characters like Duolingo's owl, Bitepal's raccoon) create striking visual memory and feel friendly. The "teddy bear effect" — users attach to them. Mascots are a 2025/2026 trend, not fading.
- **Focus Flight** shaped its paywall as a flight ticket, with the phone vibrating as the ticket "prints". The paywall itself is memorable.
- **Charts and graphs** are baseline. Users expect them. Originality is on top of that baseline — your triangle, your mascot, your flight ticket.

Rule: **benchmark the framework, innovate one element.** Don't reinvent the whole flow; do reinvent one screen.

---

## 11. Output contract — what this skill delivers

When invoked on a new onboarding design task, this skill produces a **blueprint document** before any code or copy is written. The blueprint must contain:

1. **Niche classification** (from §4 table) with a justified screen-count target range.
2. **Gating decision** (hard / soft / hybrid) with reasoning from §5.
3. **Numbered screen list** (using §3's anatomy) with one-line purpose per screen.
4. **Aha moment** explicitly called out on the screen list.
5. **Returning-user escape hatch** location noted.
6. **Signature originality element** — one unique creative choice this flow will carry (§10).
7. **Deferred-vs-gated registration decision** with rationale (§6).
8. **Geographic/cultural variants** if targeting multiple regions (§8).

Do NOT generate screen designs, copy, permission microcopy, or code until the blueprint is approved. Pass control to:
- `mobile-onboarding-psychology` — for copy and principles per screen
- `mobile-onboarding-permissions-and-paywall` — for permission/paywall/data-ask screens
- `mobile-onboarding-implementation` — for code, A/B testing, and metrics

---

## 12. Quick-reference blueprint checklist

Before approving a blueprint, verify:

- [ ] Niche identified and screen-count target set from §4
- [ ] Gating strategy chosen from §5 with rationale
- [ ] Each step from §3 present or explicitly skipped with reason
- [ ] Aha moment placed before the paywall
- [ ] Paywall at peak perceived value, not before personalization reveal
- [ ] Signup deferred unless niche explicitly requires KYC/compliance
- [ ] "I already have an account" visible by screen 2
- [ ] One signature originality element named (mascot, animated metaphor, unique paywall, handwritten touch, CEO video at peak)
- [ ] Returning-user path exists
- [ ] Web / iOS / Android length differences considered if multi-platform
- [ ] Onboarding and paywall treated as a single funnel, not separate features

---

## 13. Anti-patterns — do not ship these blueprints

1. **Feature-dump carousel** (5–7 static swipeable "here's what we do" screens before interaction). Users skip. Retention near zero.
2. **Signup on screen 1** in a discretionary / consumer app. Kills top-of-funnel.
3. **Paywall before personalization reveal.** Users haven't hit the peak yet; they'll bounce.
4. **Cookie-cutter flow** identical to another app from the same studio. Apple rejection risk + long-term profit ceiling.
5. **No "skip" / "back" / "I have an account"** path. Trapped users uninstall.
6. **Generic flow** for every user type (no intent routing). Personal trainer ≠ college student — same flow loses both.
7. **Short flow in a niche that rewards commitment** (e.g. a 3-screen weight-loss app). Users don't feel personalized — low LTV.
8. **Long flow in a niche that doesn't reward it** (e.g. 30-screen AI chat). Users quit before the aha.
9. **Aha moment after the paywall.** Reversed causality. Never works.
10. **Onboarding designed without the paywall in view.** They're one funnel — design them together or the handoff is janky.

---

This skill sets the skeleton. The next three skills flesh it out: words, trust, and code.
