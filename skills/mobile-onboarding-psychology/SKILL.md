---
name: mobile-onboarding-psychology
description: Apply behavioral psychology and copywriting principles to mobile onboarding screens — the cognitive levers (Endowed Progress, Peak-End, Loss Aversion, Zeigarnik, Cognitive Load, Commitment, reason-giving) and the copy formulas that pull users through a funnel. Invoke whenever writing onboarding copy, microcopy, affirmation screens, welcome messages, quiz questions, stat screens, social proof blocks, or any screen where the words and emotional framing decide whether the user continues. Triggers: "onboarding copy", "welcome screen text", "affirmation screen", "quiz copy", "stat screen", "conversion copywriting", "why users drop off", "cognitive load", "endowed progress", "peak-end rule", "loss aversion", "social proof", "reason giving", "onboarding microcopy", "make this flow convert better". Use AFTER the blueprint skill (which sets structure), BEFORE or ALONGSIDE the implementation skill.
---

# Mobile Onboarding — Psychology & Copy Skill

This is the **"why each screen works"** skill. A blueprint gives you a skeleton; this skill gives it a nervous system. Good onboarding is psychology delivered through copywriting — they are the same thing in practice. Alex Schievano (screens.design, 2,300+ onboarding flows studied) ranks **psychology + copywriting as the top S-tier principle** — above UI design, above paywalls, above every tactical trick.

Sibling skills:
- `mobile-onboarding-blueprint` — the structure this skill fills with words
- `mobile-onboarding-permissions-and-paywall` — permission / paywall / data-ask copy (specialized)
- `mobile-onboarding-implementation` — the code and measurement

---

## 1. The core axiom

**Psychology is the lever. Copywriting is the hand that pulls it.**

Every onboarding screen should be pulling one named lever. If you can't name the psychological principle a screen is leveraging, either delete the screen or redesign it. "Nice visual" is not a principle. "Big CTA" is not a principle. The principles below are.

The second axiom: **show the outcome, never the features.**

| ❌ Feature framing | ✅ Outcome framing |
|---|---|
| "AI-powered photo food recognition with macro breakdown" | "In 2 months, you'll be 5kg lighter." |
| "End-to-end encrypted messaging with 12-factor auth" | "Only you and your team can read this." |
| "500M-track catalog with lossless audio" | "Every song you've ever wanted, in your pocket." |
| "Step tracking via device sensors" | "Walk 30 minutes more per day without thinking about it." |
| "Time-blocking calendar with AI scheduling" | "Save 30 minutes every morning." |

Features describe the app to itself. Outcomes describe the user to themselves. Only the second one converts.

---

## 2. The ten load-bearing psychological principles

### 2.1 Endowed Progress Effect

Humans finish what they've started — even when the "start" is a gift. The classic Nunes & Dreze (2006) car wash study: a loyalty card with **2 of 10 stamps pre-filled** was completed significantly faster than an otherwise-identical **blank 8-stamp card**, despite the actual effort being identical.

Application:
- Progress bars in onboarding should **start at ~10%, never at 0%**. "You're 1 of 5 steps in already" reads as momentum; "0 of 5" reads as a mountain.
- Segmented progress indicators (5 dots, 2 filled) outperform linear percentage fills.
- Post-onboarding checklists should show the first item as already ✓ checked ("Account created") before the user sees it.
- A/B test documented: adding a progress indicator alone drove **+18% completion rate** on an onboarding flow. Nothing else changed.

### 2.2 Goal Gradient Effect

Effort accelerates as the perceived finish line approaches. Rats run faster near the food; humans click faster near "Done". Application:
- Show the finish line. "2 steps left" on screen 48 of 50 is more motivating than "98% complete".
- Put the easiest tasks at the end of the flow. Signup field "first name only" on the last screen beats "everything please" on screen 3.
- Compress step durations as you approach the end. Long quiz screens early, short one-tap screens late.

### 2.3 Zeigarnik Effect

The brain fixates on **unfinished** tasks far more than completed ones. A partial checklist is a mental itch. Application:
- Onboarding checklists persist AFTER the initial flow. Keep "3 of 5 steps done" visible on the home screen for days. Users return to close the gap.
- **Mural** replaced popups with a 6-step checklist and got **+10% one-week retention**.
- Don't auto-dismiss the checklist after the flow ends. Let the user dismiss it manually, or better, let it remain as a small gear-icon drawer.

### 2.4 Cognitive Load Theory — one decision per screen

Working memory is finite. When a screen asks two questions, shows three images, displays a 400-character subtitle, and has two CTAs, cognitive overload = abandonment. Application:
- **One decision per screen.** Name. Age. Goal. Gender. Never two at once. Starla's female-oriented flow uses strictly one input per screen — very clean, very effective.
- **House Realty** split one signup form across multiple screens → **+15% conversion**. Same fields, same data, just one per screen.
- **Dollar Shave Club** rewrote quiz copy to be more conversational (shorter, question-framed, less businesslike) → **+5% subscriptions**.
- **Headspace** allowed multi-select instead of single-select on goals → **+10% free-trial conversion**. One checkbox decision change.

### 2.5 Peak-End Rule

Users judge an entire experience by two moments: the emotional peak, and the ending. The middle is forgotten. Application:
- **Engineer the peak deliberately.** In quiz-driven flows, the peak is the personalized-outcome reveal ("You'll hit 65kg by Aug 14" with a curve graph). Put the best visual, strongest copy, and most emotional moment here.
- **Engineer the end deliberately.** Don't end with a boring "You're all set." End with a celebration animation, a founder's handwritten note (like One Year), or a CEO video at the aha moment (like Airbnb after first listing).
- A mediocre middle is OK. A mediocre peak or ending is fatal.

### 2.6 Loss Aversion and the Endowment Effect

Losing something you have hurts ~2× more than gaining something of equal value. Once users **own** something — data, a configured profile, a virtual pet, a streak, a named workspace — quitting feels like loss.

Application:
- **Long quiz flows work because of this.** By screen 50 the user has invested time and thought. Quitting means discarding a sunk cost. Cal AI (~20 screens), Noom (~80), Bitepal (61) all lean on this.
- **Named virtual pets** (Bitepal's raccoon) multiply the endowment — now they have a relationship with a character.
- **Early streaks** (Duolingo's "you've just started a 1-day streak!") create something to lose.
- **Deferred signup + local state** weaponizes this: after 10 minutes of use, the signup ask lands as "save what you've built", not "give us your data".

### 2.7 Commitment and Consistency (Cialdini)

Small early choices create internal pressure to stay consistent — users justify continued engagement to themselves. Application:
- Ask users to **pick a theme color, avatar, mascot**, or favorite goal early. Focus Flight lets users choose their map style during onboarding — the app feels theirs before they've really used it.
- The deeper the investment, the more irrational the abandonment feels to the user.
- Every screen the user taps "Continue" on is a micro-commitment. By screen 8, quitting feels like admitting the first 7 were a mistake.

### 2.8 Reason-giving (Cialdini's "because" experiment)

Ellen Langer's classic Xerox experiment: asking to cut a copier line with **any reason attached** dramatically outperformed asking with no reason — even when the reason was nonsensical. "Can I cut? **Because I need to make copies**" worked.

Application to onboarding:
- **Every data ask must include a `because` in its subtitle.** No exceptions.

| ❌ No reason | ✅ With reason |
|---|---|
| "Where were you born?" | "Where were you born? — So we can align your birth chart with regional astrology traditions." |
| "What's your height?" | "What's your height? — We use this to calculate your personalized calorie target." |
| "Phone number?" | "Phone number? — We'll text a 6-digit code to verify. We never send marketing SMS." |
| "Enable notifications?" | "Enable notifications? — We'll remind you to practice so it becomes a habit." |
| "Allow camera access?" | "Allow camera access? — So you can scan your food in one tap." |
| "Birthday?" | "Birthday? — So we can start you on the right plan for your age group." |

**Starla's "Where were you born?" screen lacks a reason and is a known A/B test opportunity** — adding "so we can align your chart with your regional horoscope tradition" has been observed to lift progression measurably.

### 2.9 Social proof — the real kind

Social proof is a credibility multiplier. But **fake social proof destroys trust**. Users have been trained to recognize AI-generated profile pictures, stock-photo testimonials, and Shopify-template 2016 review rows.

**Ranked by effectiveness:**

| Social proof type | Trust level | Effort to produce |
|---|---|---|
| Video testimonial of a real named user | Highest | High |
| Real App Store screenshot, refreshed on-camera | Very high | Medium |
| Instagram-stories circle row of real users (BoostUp Social's pattern) | Very high | Medium — get real users, reward screenshot-takers |
| Press / partner / customer logos | High | Low |
| User count ("Join 2.3M users") | Medium | Very low |
| Star rating ("4.9★ on App Store") | Medium | Low |
| Text testimonials with real names + photos | Medium | Medium |
| Text testimonials with AI-generated avatars | **Negative** (reduces conversion) | Low |
| Stock-photo testimonials | **Negative** | Low |

**The Instagram-stories pattern (BoostUp Social):** build a row of circular story avatars at the top of the paywall or welcome screen. Each avatar opens to a testimonial from a real named user. This works because:
1. Familiar UI — users know how to tap a story circle
2. Authenticity signal — stories format is associated with real people
3. Invites tapping — "Don't believe? Tap to find out"
4. Easy to populate — reward users with free credits / Pro features for screenshots and testimonials, capture those, display them

**Do not** use fake reviews / AI avatars / stock photos. Users detect them. Reduced conversion is documented.

### 2.10 Personalization = relationship

Ask the user's name early. Use it on subsequent screens. This creates a perceived relationship between the user and the app.

Riverside (recording software) does this with "In Vadim's studio" throughout its interface. Duolingo addresses the user by name. The lift is small per-screen but compounds across a 20-screen flow.

**Asking the name is "neutral friction"** — you're adding a form field, but the payoff (every subsequent screen feels personalized) exceeds the cost. Place it mid-flow, never first (first-impression = value, not interrogation).

Copy patterns:
- "Ready, Vrushal?"
- "Your plan, Vrushal"
- "Vrushal, you're almost done"

---

## 3. Copy formulas — the four templates that cover 80% of onboarding screens

### 3.1 Value prop screen (welcome)

```
[OUTCOME verb + USER state]
[Subtitle: the time frame + proof]
[CTA: first-person verb]
```

Examples:
- "Lose 5kg by August. / 80% of Cal AI users hit their goal in 6 months. / [Let's go →]"
- "Ship weekly, not quarterly. / 500+ engineering teams use Linear daily. / [Start →]"
- "Every song, offline. / 500M tracks, 4.8★ on App Store. / [Get started →]"

### 3.2 Quiz question screen (one decision per screen)

```
[QUESTION, second person, direct]
[Subtitle: the `because` — why we ask]
[OPTIONS, labeled with verbs or specific nouns — never "Option A"]
```

Examples:
- "What's your main goal? / So we can tailor your plan. / [Lose weight] [Build muscle] [Eat better]"
- "How often do you work out? / Helps us set realistic targets. / [Never] [1–2×/week] [3–5×/week] [Daily]"

Note Cal AI's trick: the **first question is about workout frequency, not weight goal** — it hooks into the "why" without assuming the user came to lose weight (some are bulking). Never assume the goal; ask.

### 3.3 Affirmation / stat screen (dopamine hit between quiz blocks)

```
[POSITIVE STATEMENT about the user + their goal]
[STAT or graph supporting realism]
[Optional: "Not alone — X% of our users hit this"]
[CTA: Continue]
```

Examples:
- "Losing 5kg is realistic. / 90% of Cal AI users say the change is obvious within 30 days. / [Continue →]"
- "You're setting ambitious goals. / Our most successful users start exactly where you are. / [Continue →]"
- "We see you. / In 14 days, you'll notice your first win. / [Continue →]"

Interleave affirmation screens **every 2–4 quiz screens** in long flows. They break fatigue, deliver dopamine, and reinforce commitment.

### 3.4 Personalized outcome reveal (the peak)

```
[HEADLINE with a specific date/number/target]
[VISUAL: graph, timeline, plan card]
[SUPPORTING COPY: what they'll see / feel]
[CTA: button that moves toward the paywall, not away from it]
```

Examples:
- "By August 14, you'll be 65kg. / [graph of projected weight curve] / Your personalized plan is ready. / [See my plan →]"
- "In 2 months, you'll be able to travel in France. / [graph: speaking vs reading learning curves] / You've already started. / [Continue →]"
- "Your workspace is ready. / [preview of templated workspace] / Configured for: Personal projects / [Enter →]"

---

## 4. Honesty as a trust-building lever

**Overpromising creates refund requests. Underpromising + honest pacing creates loyalty.**

Cal AI's onboarding includes a screen explicitly saying: **"Based on our data, weight loss is usually slow at first — but after 7 days, you can burn fat like crazy."** This is counterintuitive (most apps would promise immediate results). It works because:

1. Sets realistic expectations → fewer refund requests when results are slow in week 1.
2. Builds trust — "they're being honest with me, they must know what they're doing".
3. Reduces churn in the critical first-week window.
4. When results DO kick in at day 7, the user feels validated, not surprised.

Apply this pattern anywhere you're selling a result that takes time: fitness, language learning, habit apps, therapy apps, financial planning.

**Follow-up screen: privacy reassurance.** After admitting the system is honest about timing, naturally follow with a trust-focused screen: "Your data stays on your device. We never sell it." This reinforces the honesty brand.

---

## 5. Originality and mascots

Users open 3–5 new apps per month. Over a year, they've seen dozens of onboarding flows. Identical patterns blur together. **One truly original element per flow** yields disproportionate returns.

### The triangle example (BoostUp Social)
BoostUp Social animated a triangle to represent its three-corner value prop (hashtags, AI chat, captions). Compared to charts-and-graphs, this single animation drove **+3–4% open-to-trial**. One creative decision, measurable revenue impact.

### Mascots — the 2025/2026 trend

Mascots (friendly characters like Duolingo's owl, Bitepal's raccoon, Noom's coach) work because:
- **"Teddy bear effect"** — users attach to characters more than abstract icons.
- **Memorability** — a cartoon raccoon is more striking than a clean abstract logo in a crowded memory.
- **Tone-setting** — a mascot gives you an emotional register to write in (friendly, caring, playful).
- **Humanization** — reduces the "talking to a corporation" friction.

Considerations:
- Mascots require consistent art direction throughout the app, not just onboarding.
- Not appropriate in serious-trust niches (fintech, healthcare) — looks unprofessional.
- Great in wellness, fitness, education, productivity, consumer.

### Non-cookie-cutter copy tone

Signature phrases reinforce originality:
- Gen Z Bible: "This is not your grandma's Bible."
- Tinder acknowledging your birthday.
- One Year: handwritten signature + hand-drawn flower in onboarding.
- Base Camp: personal founder note after account creation.
- Airbnb: CEO video after the user publishes their first listing.

These feel human, not corporate. A single handwritten element or founder's note is worth ten polished screens.

---

## 6. Microcopy templates by screen type

### Welcome / value prop
- Headline: 3–6 words, outcome verb
- Subtitle: 8–15 words, with social proof
- CTA: 1–3 words, first person
- AVOID: taglines, puns, product names longer than 1 word, "Welcome to [App]"

### Intent routing question
- Question: 3–7 words, second person
- Subtitle (the reason): 6–12 words
- Options: parallel verb structure, 1–4 words each
- AVOID: "Other", "Not sure", "Prefer not to say" unless legally required

### Quiz question
- Same as intent routing
- If it's a range (age, weight, frequency): prefer sliders or pickers over text input
- If text input: autofocus, appropriate keyboard (numeric for numbers), never require "000" or leading zeros

### Affirmation / stat
- Headline: positive declaration about the user, 5–10 words
- Stat: single number, not a sentence
- CTA: "Continue" or similar — don't compete with the affirmation

### Loading / building plan
- Headline: active verb ("Analyzing", "Building", "Calibrating", "Crunching")
- Duration: 3–5 seconds feels right. Under 2s feels fake. Over 7s feels broken.
- Optional: sub-steps animating in ("Analyzing your goals…" → "Matching your plan…" → "Optimizing for your schedule…")
- AVOID: static "Loading…" with no sub-copy

### Outcome reveal (the peak)
- Headline: specific number or date
- Visual: chart, graph, timeline, plan preview — concrete
- Sub-copy: 1–2 sentences reinforcing achievability
- CTA: moves forward toward paywall

### Signup deferred
- Headline: "Save your progress" / "Sync across devices" / "Don't lose your plan"
- NEVER "Create an account" / "Sign up to continue"
- Buttons: SSO options first, email last

---

## 7. Cultural and demographic adaptation

### Age-based tone
- **18–25:** direct, meme-aware, conversational ("hey, your vibe today?"). Gen Z Bible's "what's your vibe right now?" question is exactly this register.
- **25–40:** efficient, benefits-first, results-oriented.
- **40–55:** warmer, slightly more formal, emphasize ease-of-use.
- **55+:** larger text defaults, simpler flows, one-input-per-screen (Starla-style), more explicit reason-giving.

### Gender-targeted copy
- **Female-oriented apps** (Starla, Clue, horoscope/astrology): softer tone, "align with the stars", emphasize care and community.
- **Male-oriented apps** (fitness, dating): direct, competitive framings ("beat your last time"), stat-heavy.
- **Gender-neutral apps:** default to outcome framing without gendered adjectives.

### Regional defaults
- **Eastern markets (Japan, Korea, China):** information-dense is normal, even preferred. Don't over-minimize.
- **Western markets (US, UK, EU):** one idea per screen, whitespace, minimalism.
- **LATAM, MENA:** warm/relational framing, family-oriented where relevant, vibrant color palettes.

---

## 8. Writing for the mobile scan

Users don't read onboarding. They **scan**. Copy that requires reading is copy that gets skipped.

Rules:
- **No paragraphs longer than 2 lines.**
- **Front-load keywords.** "Lose 5kg by August" not "Our app, which uses AI, helps users lose weight, sometimes up to 5kg by summer."
- **No jargon.** "End-to-end encrypted" is jargon; "only you and your team can read this" is plain.
- **No cleverness over clarity.** A pun is a missed conversion.
- **No brand names in headlines.** "Welcome to SuperFitnessAI" is wasted copy real estate. Say the outcome.
- **Microcopy on every interactive element.** A button labeled "Next" is weaker than "See my plan".

---

## 9. Stat and affirmation patterns — pacing long flows

Long quiz flows (20+ screens) need **pacing beats** or users fatigue. The pattern:

```
Quiz → Quiz → Quiz → AFFIRMATION → Quiz → Quiz → STAT → Quiz → Quiz → Quiz → AFFIRMATION → ...
```

### Affirmation screen content
- "You're setting a realistic goal."
- "90% of users your age hit this target."
- "You're already ahead of where most people start."
- "This is a great plan. Let's get specific."

### Stat screen content (back with data)
- "80% of Cal AI users maintain their weight loss after 6 months."
- "Users who answer this question hit their goal 2× faster on average."
- "Our top 10% of users started exactly where you are."

These screens cost almost nothing to build (single line + background) but dramatically improve completion rates. Never skip them in quiz-driven flows longer than 10 screens.

---

## 10. The delight layer — making long flows feel short

Duolingo has ~60 onboarding screens. **It doesn't feel long.** Why:
- Smooth animations on every transition — even loading states (Bumble does this exceptionally well)
- Micro-celebrations (checkmarks pop, confetti on completion)
- Character reactions (owl nods when you pick the right answer)
- Sound effects on taps (very light — mute by default, but audible if the user leaves sound on)
- Haptic feedback on every selection

Bitepal: 61 screens, "and the onboarding was a lot of fun. It has really amazing animations. The raccoon is quite lovable and you even get to name your virtual pet raccoon."

**If your blueprint has >15 screens, the delight layer is not optional.** See `mobile-onboarding-implementation` for the haptic / animation implementation patterns.

---

## 11. Paywall copy (brief pointer — deep dive in sibling skill)

Paywall copy is the convergence of everything above: peak-end (paywall comes at the peak), loss aversion (emphasize what they'd lose without), social proof, personalization, reason-giving.

Brief patterns:
- Open with the personalized plan: "Here's your plan, Vrushal."
- Social proof block IMMEDIATELY before pricing (Timo, BoostUp Social)
- Pricing with a decoy: a clearly-overpriced lifetime makes monthly feel like a bargain ($350 lifetime / $9.99/month — the monthly wins, but the lifetime anchors value).
- CTA microcopy: "Start my free trial" > "Continue" > "Subscribe" (most coercive wording loses).
- Reassurance: Blinkist-style 3-day trial timeline (today start → day 2 reminder → day 3 charge unless cancelled).

Full paywall doctrine in `mobile-onboarding-permissions-and-paywall`.

---

## 12. Anti-patterns in copy — never ship these

1. **Walls of text.** Users scan, not read. If a screen has more than 30 words of non-CTA copy, you're losing people.
2. **Jargon / product-speak.** "Leverage our AI-powered intent graph" — nobody reads past "leverage".
3. **Features over benefits.** "12-factor auth, E2E encrypted, SOC2 compliant" is a B2B pitch, not onboarding.
4. **Clever over clear.** Puns, wordplay, or double meanings slow scanning. Be direct.
5. **Generic microcopy.** "Next", "Continue", "Submit" are weaker than task-specific verbs.
6. **Missing reasons.** Every data ask without a `because` is friction you're choosing to keep.
7. **Overpromising.** "Lose 20kg in a month" creates refund requests. Cal AI's honest pacing pattern is the counterexample.
8. **Brand-name worship.** "Welcome to [AppName]" wastes the most valuable real estate on the flow.
9. **Fake social proof.** AI-avatar testimonials, stock-photo reviews, unverifiable user counts. Detected. Lowers conversion.
10. **Cookie-cutter copy.** If your welcome screen could be swapped with a competitor's and nobody'd notice, you're invisible.

---

## 13. Output contract — what this skill delivers

When invoked on copy work, produce:

1. **Named psychological principle** for every screen (§2). If no principle applies, the screen shouldn't exist.
2. **Copy in the template format** from §3 appropriate to the screen type.
3. **Reason-giving subtitle** on every data ask (§2.8).
4. **Outcome framing** on every headline (§1).
5. **Personalization pattern** (user's name, their answer, their plan) wherever possible (§2.10).
6. **Affirmation/stat pacing** in any flow >10 screens (§9).
7. **Cultural/demographic adaptation** noted if the target user profile is specified (§7).
8. **Originality element** called out — what makes this flow's copy not interchangeable with any other flow (§5).

Do NOT write copy without an identified principle per screen. Do NOT ship fake social proof. Do NOT use feature framing on headlines.

Hand off paywall / permission microcopy to `mobile-onboarding-permissions-and-paywall` — those have specialized patterns beyond the generic templates here.
