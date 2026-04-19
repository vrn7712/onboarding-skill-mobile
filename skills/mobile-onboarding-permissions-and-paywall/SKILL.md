---
name: mobile-onboarding-permissions-and-paywall
description: Handle the three highest-leverage and highest-risk moments in mobile onboarding — OS permission asks, personal data collection, and the paywall. Covers the Double-Gate permission priming strategy, per-permission microcopy templates (camera, location, notifications, ATT, contacts, health), progressive profiling, attribution survey design, trust theater, decoy pricing, Blinkist-style trial reassurance, quiz-tailored pricing, and Apple's 2026 policy changes. Invoke for any screen asking for permissions, personal data, payment, or trial signup. Triggers: "permission prompt", "permission priming", "double gate", "notification opt-in", "ATT tracking", "camera permission", "location permission", "progressive profiling", "data collection", "paywall design", "pricing plans", "decoy pricing", "trial reassurance", "subscription flow", "free trial", "onboarding paywall", "quiz-tailored pricing", "attribution survey", "where did you hear about us". Pairs with all three sibling skills.
---

# Mobile Onboarding — Permissions, Data, and Paywall Skill

This is the **"sensitive-ask moments"** skill. Three categories of screen — permissions, personal data, and paywall — share one property: **if you get them wrong, the user uninstalls immediately, and you often can't recover.** They deserve specialized doctrine.

Sibling skills:
- `mobile-onboarding-blueprint` — decides WHERE these moments sit in the flow
- `mobile-onboarding-psychology` — informs the copy inside each screen
- `mobile-onboarding-implementation` — the code, metrics, and A/B testing

---

## Part I — OS Permissions

Alex Schievano's tier list (screens.design, 2,300+ apps studied):
- **ATT/tracking permission:** A-tier **if you run ads**, D-tier if you don't (skip it).
- **Notification permission:** B-tier baseline, S-tier if notifications genuinely drive the core loop (habit tracker, fitness app, weather alerts).
- **Signing up in onboarding:** D-tier.
- **Signing up after trial activation:** S-tier.

Permissions are the most-often-broken part of mobile onboarding. The single most important pattern in this skill is the **Double-Gate Strategy**.

---

## 1. The Double-Gate Permission Strategy (non-negotiable)

### The problem
Native OS permission dialogs (iOS `UNUserNotificationCenter.requestAuthorization`, `CLLocationManager.requestWhenInUseAuthorization`, `AVCaptureDevice.requestAccess`, `ATTrackingManager.requestTrackingAuthorization`) are:
- Visually sterile
- Legally dense
- Can only be triggered **once per install** in most cases
- Irrecoverable from denial — the user has to open Settings > [App] > Permissions and toggle manually

**Stats from mobile telemetry studies:**
- Blind OS permission prompts (no priming): **12–17% acceptance rate**
- Only **3%** of users can correctly identify what they just agreed to when blindly prompted
- Primed prompts with a custom pre-prompt first: **~70% acceptance**

This is a 4× conversion swing on permissions that gate core functionality. It's not optional.

### The solution — two gates

**Gate 1: Custom branded pre-prompt.** Your own UI modal. You control the copy, visuals, animation. Includes a "Not now" or "Maybe later" button.

**Gate 2: The native OS prompt.** Triggered only if the user tapped "Allow" on Gate 1.

Flow logic:

```
User reaches moment that needs permission
    ↓
Show Gate 1 (custom branded pre-prompt)
    ↓
User taps "Allow"?           User taps "Not now"?
    ↓                             ↓
Fire Gate 2 (native OS prompt) Dismiss modal, no OS prompt fired
    ↓                             ↓
~70% acceptance               Can ask again later with another pre-prompt
```

If the user declines the pre-prompt, the native OS prompt is **never fired**. This preserves your one-shot OS prompt for when trust is higher.

### Contextual timing
**Never fire permission prompts on app launch.** Wait until the user reaches the feature that needs the permission:
- Camera permission → user taps "Take a photo" / "Scan food"
- Location permission → user taps "Find nearby" / "Show restaurants near me"
- Notification permission → user completes first lesson / finishes onboarding (notifications have future value only)
- ATT/tracking permission → after first aha moment, before the paywall
- Contacts permission → user taps "Invite friends" / "Find people you know"

### Visual design of the pre-prompt
- Branded, not system-style
- Ideally uses Glassmorphism (backdrop blur + semi-transparency) — see `mobile-onboarding-implementation`
- Contains: icon, headline, 1–2 sentence explanation, BENEFIT statement, two buttons
- Button order: primary (Allow) on the right or bottom, secondary (Not now) visually present but smaller
- Optional: for notifications, include a **preview of the actual notification you'd send** (Cool Center does this)

---

## 2. Per-permission microcopy templates

Each permission has a specific psychology. One-size-fits-all fails.

### Notifications

The biggest permission win in onboarding. Good priming takes opt-in from ~40% to ~70%.

**Template:**
```
Icon: 🔔 or app mascot with a speech bubble

Headline: "Stay on track with daily reminders"
Body: "We'll send you [specific time]-of-day nudges so [specific habit/outcome]. You can turn these off any time in settings."
Preview: [mock of the actual notification that will appear]

Primary: "Turn on notifications"
Secondary: "Not now"
```

**Variants by app type:**

| App type | Copy |
|---|---|
| Language learning | "We'll remind you to practice so it becomes a habit." |
| Fitness | "Your daily workout reminder — 5 minutes, same time each day." |
| Habit tracker | "A gentle nudge when it's time for [habit]." |
| Weather | "Only if severe weather is coming — nothing routine." |
| News | "A single daily digest at 8 AM. Never more." |
| Meditation | "A calm reminder when you set aside time to practice." |
| Messaging | "Never miss a message from people you care about." |
| Finance | "Alerts only for unusual account activity." |

**Cool Center's preview-the-notification trick:** include an image mockup showing exactly what the notification will look like — content, time, and tone. Users opt in at higher rates when they see it's not a spam stream.

### Tracking / App Tracking Transparency (ATT) — iOS

ATT permission governs cross-app tracking (IDFA access). Global opt-in rates after ATT launch collapsed to ~25%. Skip this ask entirely if you're not running paid user acquisition. If you are:

**Template:**
```
Icon: 📊 or branded analytics icon

Headline: "Help us keep [App] free"
Body: "We use anonymous data about how you use the app to improve it and keep it [free / affordable]. This does not share your personal information."

Primary: "Allow"
Secondary: "Ask app not to track"
```

**Framing note:** frame ATT as supporting the app, not as "tracking you". Users understand the exchange: "allow basic analytics → the app stays free / good."

**If you skip it:** that's a valid choice. ATT is A-tier only if you run ads; D-tier otherwise.

### Camera

**Template:**
```
Icon: 📸

Headline: "Snap it in one tap"
Body: "We need camera access to [specific action — e.g., scan your food, take a profile picture, verify your ID]. Photos are processed on-device."

Primary: "Allow camera"
Secondary: "Not now"
```

### Location

**Template:**
```
Icon: 📍

Headline: "Show what's near you"
Body: "Allow location so we can [specific benefit — restaurants within walking distance / nearby gyms / local weather]. We never sell or share your location."

Primary: "Allow location"
Secondary: "Not now"
```

**Important:** for iOS, explicitly choose between "When in Use" vs "Always" — Always is a huge trust ask and usually unnecessary. Default to "When in Use".

### Microphone

**Template:**
```
Icon: 🎙️

Headline: "Speak instead of type"
Body: "Allow microphone so you can [dictate notes / record voice memos / use voice commands]. Recordings are processed on-device."

Primary: "Allow microphone"
Secondary: "Not now"
```

### Contacts

Single most-denied permission after ATT. Only ask if contacts genuinely power the core loop.

**Template:**
```
Icon: 👥

Headline: "Find friends already here"
Body: "We'll check which of your contacts already use [App] — we never upload contacts, and never message them without your permission."

Primary: "Find friends"
Secondary: "Skip for now"
```

**Do NOT default-import and silently message. Every messaging app that did this lost class-action lawsuits (LinkedIn, Path). Contact-scraping violates trust permanently.**

### Health / HealthKit

**Template:**
```
Icon: ❤️

Headline: "Sync with Apple Health"
Body: "Import your steps, weight, and workouts to personalize your plan. We only read what you approve on the next screen."

Primary: "Continue"
Secondary: "Skip"
```

**Important:** HealthKit permission is granular — the next native screen lets the user check specific data types. Pre-explain this so the detailed list isn't overwhelming.

### Calendar

**Template:**
```
Icon: 📅

Headline: "See your schedule in [App]"
Body: "Allow calendar access to [schedule workouts around meetings / block focus time / surface upcoming events]. We never write events without asking."

Primary: "Allow calendar"
Secondary: "Not now"
```

### Photo library

Prefer limited-library access (iOS 14+). Don't ask for full-library access unless the app actually needs it.

**Template:**
```
Icon: 🖼️

Headline: "Pick the photo you want"
Body: "We only access photos you choose — never your full library."

Primary: "Choose photos"
Secondary: "Not now"
```

---

## Part II — Personal data collection

The rules for data asks are the same shape as permissions: ask only when you need it, give a reason, and make the ask feel reciprocal.

## 3. Progressive profiling

Ask for the **minimum viable profile** on day 1. Progressively profile over weeks as the user demonstrates engagement.

**Day-1 minimum (3–5 questions):**
- Goal / intent (already in the quiz)
- Name (for relationship building — `mobile-onboarding-psychology` §2.10)
- One demographic detail the app genuinely needs (age band, gender if the niche requires it, region)
- Optionally: experience level, preferences

**Defer to day 2+ (trigger on feature use):**
- Phone number (only when 2FA or SMS-required feature hit)
- Detailed financial data (only when a money feature is opened)
- Full address (only when shipping/delivery is triggered)
- Connected accounts (only when the feature needing them is tapped)

**Never during onboarding:**
- Credit card (unless hard-gate fintech)
- Passport / government ID (unless KYC-required financial app)
- Emergency contacts (unless core safety feature)
- Social security / tax ID (unless tax product)

### The reason-giving rule (reiterated)

**Every personal-data ask must include a `because` subtitle.** Starla's "Where were you born?" screen without a reason is a known A/B test loser. Adding "so we can align your chart with regional traditions" lifts progression measurably.

Full template library in `mobile-onboarding-psychology` §2.8.

---

## 4. The attribution survey — design with care

"Where did you hear about us?" screens are common and legitimately useful for tracking the performance of paid acquisition channels and influencer deals. But:

**95% of users will lie or click randomly.** Alex Schievano, blunt: "you have to account for the fact that 95% of people are going to lie."

The failure mode: users tap whichever option is closest to their thumb. With five options stacked vertically, Facebook (top) gets over-clicked simply because the thumb is already at the top of the screen. Results are statistically meaningless.

### The randomization rule
**Always randomize the order of attribution survey options for each user.** Without randomization, thumb-position creates false positives for whichever option you place near the thumb's default landing zone.

With randomization across 1000s of users, the noise cancels out and you get usable (though still imperfect) signal.

### When to include this screen
- **Include if:** you're spending money on paid acquisition (ads, influencer sponsorships, partnerships) and genuinely need channel attribution
- **Skip if:** you're 100% organic (ASO, referral, word of mouth). The data is noise that isn't worth a dropped screen on conversion.

### Where to place it
Mid-funnel, after the user is committed (screen 5–15 in a quiz flow). Don't put it early (front-funnel drop-off is higher) and don't put it right before the paywall (you'll lose high-intent users to a non-essential ask).

### Template
```
Headline: "Where did you first hear about us?"
Subtitle (optional): "This helps us know how to reach more people like you."
Options (RANDOMIZED ORDER):
  - TikTok
  - Instagram
  - YouTube
  - Friend / family
  - Google / App Store search
  - Podcast
  - News article
  - Other
Secondary: [Skip]
```

---

## 5. Trust-building — privacy screens and security theater

### Privacy reassurance screen
After a dense data ask (quiz, health connect, etc.), insert a single privacy-focused screen:

```
Icon: 🔒 or 🛡️

Headline: "Your data is yours."
Body:
• Never sold. Never shared with advertisers.
• Stored [on-device / encrypted on our servers].
• You can delete everything at any time in Settings.

Primary: "Continue"
```

Cal AI does this right before the paywall — it's a critical trust moment before the money ask. Place it similarly in your flow.

### Security theater in fintech

In fintech, healthcare, and financial planning apps, users EXPECT some friction as a trust signal. Adding brief loading screens like "Verifying your secure connection…" (2–3 seconds) with a lock icon measurably increases trust — even if those seconds add nothing cryptographic.

**Don't do this in non-fintech contexts** — it'll feel contrived and broken.

Examples of effective security theater:
- Two-step verification screens (even when the first step is just email)
- Progress bars during KYC ("Verifying identity… Matching records… Confirming…")
- Breaking a single verification into multiple visual steps
- Explicit "SSL-encrypted" / "256-bit encryption" badges (even when standard)

### The reassurance timeline (Blinkist-invented trial pattern)

For any free trial, show a three-row timeline:

```
✓ Today       Full access starts. No charge.
✓ Day 2       We'll remind you before the trial ends.
✓ Day 3       Your subscription begins — unless you cancel first.
```

Blinkist pioneered this pattern. It works because:
1. Removes uncertainty about when charging happens
2. Promises a reminder before charge (reduces dark-pattern anxiety)
3. Makes cancellation feel easy ("you can cancel before day 3")

Use this on any trial-to-paid paywall. Documented to reduce refund requests and cancellation-after-charge disputes significantly.

---

## Part III — The Paywall

The paywall is the single highest-revenue-impact screen in the entire app. Alex Schievano ranks it **S-tier** — above UI, above social proof, above everything except psychology+copy (which it embodies).

**Reminder:** onboarding and paywall are the same funnel. A great paywall without personalization context underperforms. A great onboarding that hands off to a cookie-cutter paywall leaves 30%+ on the table.

---

## 6. Paywall anatomy — 10 components in order

A high-converting paywall, top to bottom:

1. **Personalized header** — use the user's name and their goal: "Your plan, Vrushal: lose 5kg by August 14."
2. **Plan preview** — a card or graph showing what they're buying (their personalized plan, their workspace, their feature set).
3. **Social proof block** — Instagram-stories row OR named-user testimonials OR real App Store review screenshots.
4. **Feature/benefit comparison** — Free vs Pro table, benefit-framed (not feature-framed).
5. **Pricing tiers with decoy** — see §7.
6. **Reassurance timeline** — Blinkist 3-day structure (§5).
7. **Primary CTA** — "Start my free trial" or "Claim my plan" (not "Subscribe").
8. **Secondary options** — "Restore purchase", "Terms", "Privacy".
9. **Optional: urgency element** — one-time offer, limited-time decoy, countdown (use sparingly).
10. **Close/skip escape hatch** — a dismissible X, unless you're explicitly hard-gating.

### Component-by-component examples

- **Personalized header:** "Here's your plan, Vrushal." (Cal AI, Noom, Bitepal all do this)
- **Plan preview:** weight curve graph with goal date, or workspace template preview, or calorie target breakdown
- **Social proof:** BoostUp Social's Instagram-stories row pattern (§2.9 in `mobile-onboarding-psychology`)
- **Feature comparison:** two columns, benefits (not features), with emojis or icons
- **Decoy pricing:** see §7
- **Reassurance timeline:** see §5
- **CTA:** "Start my free trial" beats "Subscribe" by ~15% in most A/B tests; "Continue" is worst
- **Close:** soft-gate has dismissible X; hard-gate doesn't (see blueprint skill for gating decision)

---

## 7. Decoy pricing — the Steve Young framework

The single most effective psychological trick on a paywall is **price anchoring via decoy**. From Alex Schievano (via Steve Young's podcast):

> "Make sure that one of the plans has a very outrageously high price that you don't want users to convert on. Users feel, 'Okay, this price is like outrageous. I'm making a good deal by selecting the yearly or the weekly or whatever, the other option.'"

### The three-tier decoy
```
Weekly    $4.99/week    → (impulse anchor; low commitment)
Yearly    $49.99/year   → (target option; pre-selected, "Best Value" badge)
Lifetime  $349.99       → (the decoy; wildly overpriced vs monthly math)
```

Numbers to know:
- BoostUp Social (Alex's app): $9.99/month baseline, lifetime at $350 — monthly felt like a bargain.
- Cal AI: AUD$49.99/year — yearly is the target, with month/weekly and potentially a higher decoy.

### Why lifetime works as a decoy
- Most users will never spend $349 up front for a consumer app — so they skip it.
- A few warm-intro users (referred by friend who loves the app) will — bonus revenue.
- Critically: seeing $349 makes $49.99/year feel reasonable by comparison.
- The decoy does its job by **existing**, not by converting.

### Quiz-tailored pricing (Grammarly +20%)

Show different pricing based on quiz answers. "Busy professional" gets a slightly higher price point, "student" gets a discount tier. Grammarly saw **+20% plan upgrades** from quiz-tailored pricing alone.

Implement via Remote Config variants keyed on quiz answers. See `mobile-onboarding-implementation`.

### One-time offer + urgency

**Beside** pairs a quiz with a one-time offer on the paywall — urgency framing ("this price won't be here tomorrow") lifts conversion when done sparingly. Overuse and it becomes noise.

---

## 8. Paywall delight — the Focus Flight lesson

**Focus Flight** shaped its paywall as a printed flight ticket. The phone vibrates (haptic) as the ticket "prints" from the top of the screen. It's memorable. It's delightful. It's still a paywall — but users remember it, screenshot it, share it.

Compare to the default cookie-cutter paywall: title, three pricing rows, a CTA. Users have seen 1,000 of these. They skip.

**The paywall is a peak moment in Peak-End Rule terms.** Engineer delight there — a unique visual, a haptic, a founder's video, a celebratory animation on conversion. Any one of those beats a generic template.

But: **don't make a paywall delightful and a weak salesperson**. The delight must AMPLIFY the pitch, not distract from it. Alex's warning: some beautiful crafted paywalls underperform because they lose focus on the actual conversion ask. Delight + clear ask = ideal.

---

## 9. Review prompts on or near the paywall

Asking for App Store review during onboarding is a **B-tier tactic** (per Alex). Can work, with risks:

**When it works:**
- User has just had a peak experience (personalized plan reveal, first win)
- User is already pre-qualified as happy (high quiz score, positive signals)
- App is already rated well — you're not asking strangers

**When it backfires:**
- Unqualified / confused user gets an iOS-style "rate this app" popup → they give 1 star out of annoyance
- Asking on the paywall itself can distract from conversion
- Over-asking (every new feature triggers a review prompt) burns out the mechanic

**Better alternatives:**
- In-app "How's it going?" prompt (1–5 star internal rating) — only route 4–5 star raters to the App Store prompt
- Direct outreach: email happy users and ask them to leave a review
- Reward screenshot-takers who post positive reviews (BoostUp Social's playbook — converts those into Instagram-stories social proof)

### The rating-before-paywall question
Some apps (Starla) request an App Store rating right before the paywall. Works when it works. Fresh 2026 reality: Apple's algorithmic tricks change monthly, and what worked six months ago may be banned today. **Revisit this assumption monthly** — Alex's guidance.

---

## 10. Apple's 2026 policy changes — what's banned

As of late 2026:

### The "Enable Free Trial" toggle (BANNED)
The pattern: a paywall with a "Start free trial" toggle that, when toggled on, reveals the price and trial length. When off, the trial option is hidden.

- Apple review began rejecting apps using this pattern in late 2025.
- If your app still ships this, expect rejection on the next submission.
- Replace with: a clear three-tier pricing layout where trial length is visible upfront.

### What still works
- Clear pricing tiers with decoy (§7)
- Blinkist reassurance timeline (§5)
- Social proof above pricing
- Personalized headers / plan previews
- One-time offers on quiz-tailored paywalls
- Dismissable X for soft-gate paywalls

### Ongoing watch list
- App Store review requests on paywalls (Apple periodically cracks down)
- "Dark pattern" close-button placement (tiny X in corner) — Apple sometimes rejects
- Countdown timers claiming false urgency
- Pricing that changes when the user hits back

**Revisit Apple's current rules every release cycle.** What's documented here is accurate as of early 2026 and can change.

---

## 11. "Building your plan" loader — the performative compute pattern

In quiz-driven flows, the transition from "last quiz answer" to "paywall" is jarring. Insert a loading screen:

```
Headline: "Building your personalized plan..."
Sub-animations (each fades in over ~1.5s):
  ✓ Analyzing your goals
  ✓ Matching your preferences
  ✓ Optimizing for your schedule
  ✓ Calibrating your plan
Progress bar: animates 0 → 100% over 3–5s
```

**Why it works:**
- Users need to feel their input was "used" (you asked 15 questions, show that you processed them).
- A 2-second loader feels fake. A 5-second loader feels thorough. 7+ feels broken.
- The progress bar satisfies Endowed Progress psychology.
- It's a natural pacing break before the paywall — the peak before the peak.

**Don't use in productivity/business apps** with no quiz — they'll feel contrived. This is a fitness / astrology / dieting / horoscope / wellness pattern.

---

## 12. The plan reveal screen — engineering the peak

Right after the "Building your plan" loader, reveal the plan in a way that feels personal and specific:

- **Fitness:** weight curve graph with goal date, calorie target, macros, workout count.
- **Language:** "In 2 months you'll be able to communicate while traveling in France" + speaking-vs-reading graph (Speak app).
- **Astrology:** birth chart visualization with highlighted planet placements.
- **Finance:** projected savings graph with goal date.
- **Productivity:** templated workspace preview with user's name pre-filled.

**The reveal screen is the Peak.** Put your best design, strongest copy, most emotional visual here. The paywall follows immediately — users convert when the peak is fresh.

---

## 13. Paywall copy — specific patterns

### Primary CTA, ranked by conversion
| CTA | Relative performance |
|---|---|
| "Start my free trial" | Baseline (best in most tests) |
| "Claim my plan" | Close 2nd, especially post-quiz |
| "Continue" | -5 to -10% |
| "Subscribe" | -15% |
| "Pay now" | -25% — never ship this |

### Above-the-CTA microcopy
- "3 days free, then $49.99/year. Cancel anytime."
- "Free for 3 days. Billed annually unless cancelled."
- "Join 2.3M users improving daily."
- "Covered by our 30-day money-back guarantee." (if you have one)

### Below-the-CTA microcopy
- Secondary small links: "Restore purchase · Terms · Privacy"
- Apple-required: "Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless cancelled at least 24 hours before the end of the current period."

### Lifetime plan copy (the decoy)
- "One-time payment. Never pay again." (makes it sound like a good deal despite being the decoy)
- Include the total "Save $XXX over 5 years" to anchor value
- Badge: often blank or "Rare" (don't say "Recommended" — you don't want users picking the decoy)

---

## 14. Output contract — what this skill delivers

When invoked for permission, data, or paywall work, produce:

### For permission screens:
1. **Named permission** and the specific feature that needs it.
2. **Contextual timing decision** — when in the flow does this trigger?
3. **Gate 1 copy** (pre-prompt) — following the per-permission template (§2).
4. **Fallback behavior** — what happens if the user declines; can we ask again?
5. **Preview-the-notification** mockup if it's a notification ask.
6. **Visual spec** — branded modal, Glassmorphism if appropriate.

### For data-ask screens:
1. **Reason-giving subtitle** on every question.
2. **Justification** — why this data is needed on day 1 (vs. deferred).
3. **Input type** (picker, slider, text, multi-select) optimized for mobile keyboards.
4. **Randomization** applied to attribution surveys.

### For paywall screens:
1. **Positioned at peak value** (after plan reveal, not before).
2. **All 10 anatomy components** from §6 present or explicitly skipped.
3. **Decoy pricing** structured per §7.
4. **Blinkist reassurance timeline** if offering a trial.
5. **Apple 2026 compliance** — no banned patterns (§10).
6. **Social proof block** sourced from real users.
7. **Delight element** if the niche supports it (§8).
8. **Escape hatch** if soft-gate.

### Always:
- Never blind-fire an OS permission prompt.
- Never ship a paywall without an identifiable peak preceding it.
- Never include fake reviews or AI-generated testimonials.
- Always include reasoning for every data ask.
- Always pair a trial offer with the Blinkist reassurance timeline.
