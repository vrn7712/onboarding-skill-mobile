---
name: mobile-onboarding-implementation
description: Build, instrument, and iterate on mobile onboarding flows in code. Covers the React mount-all + CSS-toggle pattern (and SwiftUI / Flutter / React Native equivalents), magic link + SSO + OTP autofill auth, Remote Config architecture for per-screen A/B testing, Mixpanel-style event schema, A/B testing protocol and sample sizes, metrics benchmarks (TTV, open-to-trial, trial-to-paid), the 23.5-hour push pattern, skeleton screens, haptic and spring micro-interactions, Glassmorphism, fake-compute loaders, soft-launch strategy, and the full tooling stack (Firebase, LaunchDarkly, Mixpanel, RevenueCat, OneSignal, Adjust, screens.design). Invoke for any implementation, instrumentation, experimentation, or performance work on onboarding. Triggers: "implement onboarding", "onboarding code", "React Native onboarding", "SwiftUI onboarding", "Flutter onboarding", "remote config", "A/B test", "Mixpanel", "analytics events", "skeleton screen", "haptic feedback", "glassmorphism", "magic link", "OTP autofill", "onboarding metrics", "TTV", "time to value", "soft launch", "23.5 hour push", "RevenueCat", "Firebase remote config", "LaunchDarkly", "Statsig", "onboarding tooling".
---

# Mobile Onboarding — Implementation, Metrics & Experimentation Skill

This is the **"how to actually ship and iterate"** skill. It turns a blueprint (`mobile-onboarding-blueprint`), with its copy (`mobile-onboarding-psychology`) and sensitive-ask screens (`mobile-onboarding-permissions-and-paywall`), into running code that's instrumented, A/B-testable, and measurable.

The discipline this skill enforces: **every screen is independently flag-gated, every interaction fires an analytics event, and every hypothesis is a one-screen experiment.** That's the difference between an onboarding that compounds 22% → 28% → 31% open-to-trial over six months (Alex Schievano's quote: "you should never stop") and one that plateaus.

---

## 1. The golden implementation principle

**Every onboarding screen must be:**
1. Independently toggleable via Remote Config — so you can A/B test just this one screen.
2. Instrumented with view + interaction events — so you know what moved the metric.
3. Mounted simultaneously with siblings (mount-all pattern) — so transitions are fluid and state is preserved.
4. Driven by local-first state — so deferred registration works.
5. Loaded with skeletons, not spinners — for any wait >300ms.

Miss any of these and you're either losing conversion (#3, #5), flying blind on changes (#2), or locked out of the iteration loop that actually grows the business (#1).

---

## 2. The React mount-all + CSS-toggle pattern

Standard React tutorials teach conditional rendering. For onboarding specifically, **conditional rendering is an anti-pattern**. It:
- Destroys and remounts the step component on every navigation
- Loses form input state when the user goes back
- Causes jarring container height jumps between screens of different sizes
- Breaks smooth CSS transitions (you can't animate a component that doesn't exist yet)
- Produces flash-of-empty on remount

### ❌ The anti-pattern

```jsx
function OnboardingFlow() {
  const [step, setStep] = useState(0);
  return (
    <div className="onboarding">
      {step === 0 && <WelcomeStep onNext={() => setStep(1)} />}
      {step === 1 && <NameStep onNext={() => setStep(2)} onBack={() => setStep(0)} />}
      {step === 2 && <GoalStep onNext={() => setStep(3)} onBack={() => setStep(1)} />}
      {/* ... */}
    </div>
  );
}
```

### ✅ The pattern: mount all, toggle visibility via CSS

```jsx
function OnboardingFlow() {
  const [step, setStep] = useState(0);
  const [answers, setAnswers] = useState({});

  const steps = [
    <WelcomeStep />,
    <NameStep value={answers.name} onChange={(v) => setAnswers({...answers, name: v})} />,
    <GoalStep value={answers.goal} onChange={(v) => setAnswers({...answers, goal: v})} />,
    // ...
  ];

  return (
    <div className="onboarding-container">
      {steps.map((StepComponent, i) => (
        <div
          key={i}
          className="onboarding-step"
          style={{
            display: i === step ? 'flex' : 'none',
            // or use opacity + pointer-events for animated transitions
          }}
        >
          {StepComponent}
        </div>
      ))}
      <NavBar
        canGoBack={step > 0}
        onBack={() => setStep(step - 1)}
        onNext={() => setStep(step + 1)}
      />
    </div>
  );
}
```

### Why this matters
- **State preservation:** if the user goes back to re-edit their name, the input value is still there.
- **Consistent container:** all steps mount → container measures the tallest → no height jumps.
- **Smooth transitions:** you can use CSS `transition: opacity 200ms` with opacity + `pointer-events: none` instead of `display: none` for animated swaps.
- **Lifecycle hooks fire once:** `useEffect([], ...)` for each step runs once on mount, not every time you navigate to it.

### The animated variant
```jsx
<div
  className="onboarding-step"
  style={{
    opacity: i === step ? 1 : 0,
    pointerEvents: i === step ? 'auto' : 'none',
    position: i === step ? 'relative' : 'absolute',
    transition: 'opacity 200ms ease-in-out',
  }}
>
```

---

## 3. React Native equivalent

React Native doesn't have CSS, but the same pattern applies via `opacity` + `pointerEvents`:

```jsx
function OnboardingStep({ isActive, children }) {
  return (
    <View
      style={[
        StyleSheet.absoluteFill,
        {
          opacity: isActive ? 1 : 0,
          // In RN, using transforms keeps the layout consistent
        }
      ]}
      pointerEvents={isActive ? 'auto' : 'none'}
    >
      {children}
    </View>
  );
}
```

### With react-native-reanimated
For springy animations, use `react-native-reanimated`:

```jsx
import Animated, { useSharedValue, useAnimatedStyle, withSpring } from 'react-native-reanimated';

function OnboardingStep({ isActive, children }) {
  const opacity = useSharedValue(isActive ? 1 : 0);
  const translateX = useSharedValue(isActive ? 0 : 20);

  useEffect(() => {
    opacity.value = withSpring(isActive ? 1 : 0);
    translateX.value = withSpring(isActive ? 0 : 20);
  }, [isActive]);

  const animatedStyle = useAnimatedStyle(() => ({
    opacity: opacity.value,
    transform: [{ translateX: translateX.value }],
  }));

  return (
    <Animated.View
      style={[StyleSheet.absoluteFill, animatedStyle]}
      pointerEvents={isActive ? 'auto' : 'none'}
    >
      {children}
    </Animated.View>
  );
}
```

### With React Navigation
If using `@react-navigation/native-stack`, pass `detachPreviousScreen={false}` to preserve state between screens in the stack:

```jsx
<Stack.Navigator screenOptions={{ detachPreviousScreen: false }}>
  <Stack.Screen name="Welcome" component={WelcomeStep} />
  <Stack.Screen name="Name" component={NameStep} />
  {/* ... */}
</Stack.Navigator>
```

---

## 4. SwiftUI equivalent

```swift
struct OnboardingFlow: View {
    @State private var step = 0
    @State private var answers = OnboardingAnswers()

    var body: some View {
        ZStack {
            WelcomeStep(onNext: { step = 1 })
                .opacity(step == 0 ? 1 : 0)
                .allowsHitTesting(step == 0)

            NameStep(name: $answers.name, onNext: { step = 2 }, onBack: { step = 0 })
                .opacity(step == 1 ? 1 : 0)
                .allowsHitTesting(step == 1)

            GoalStep(goal: $answers.goal, onNext: { step = 3 }, onBack: { step = 1 })
                .opacity(step == 2 ? 1 : 0)
                .allowsHitTesting(step == 2)

            // ...
        }
        .animation(.spring(), value: step)
    }
}
```

`ZStack` is the SwiftUI equivalent of mount-all. State is preserved on the `@State` properties; the ZStack ensures all views are in the hierarchy.

---

## 5. Flutter equivalent

```dart
class OnboardingFlow extends StatefulWidget {
  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int step = 0;
  OnboardingAnswers answers = OnboardingAnswers();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Offstage(
          offstage: step != 0,
          child: TickerMode(
            enabled: step == 0,
            child: WelcomeStep(onNext: () => setState(() => step = 1)),
          ),
        ),
        Offstage(
          offstage: step != 1,
          child: TickerMode(
            enabled: step == 1,
            child: NameStep(answers: answers, onNext: () => setState(() => step = 2)),
          ),
        ),
        // ...
      ],
    );
  }
}
```

`Offstage` hides widgets without unmounting them; `TickerMode` stops animations on hidden screens for battery efficiency.

---

## 6. Authentication — magic links, SSO, and OTP autofill

Typed passwords on mobile keyboards are a conversion killer. Best-in-class apps use:

### Magic links (Slack pattern)
User enters email → receives a link → tap the link → app auto-authenticates via universal link (iOS) / app link (Android).

Implementation:
- Backend: generate single-use token, email it as a link
- Link format: `https://yourapp.com/auth/magic?token=abc123`
- iOS: Universal Link configured in `apple-app-site-association` → opens the app, passes token
- Android: App Link via `assetlinks.json` → same pattern
- Fallback: if the app isn't installed, the web URL shows a "Open in app" prompt

### Apple / Google SSO
Always offer these as the primary authentication method. They eliminate password creation entirely.

iOS (Sign in with Apple is required if you offer other social auth):
```swift
import AuthenticationServices

let provider = ASAuthorizationAppleIDProvider()
let request = provider.createRequest()
request.requestedScopes = [.fullName, .email]
let controller = ASAuthorizationController(authorizationRequests: [request])
controller.delegate = self
controller.presentationContextProvider = self
controller.performRequests()
```

React Native: `@invertase/react-native-apple-authentication` + `@react-native-google-signin/google-signin`.

### iOS OTP autofill
For SMS/email verification codes, use `textContentType="oneTimeCode"` in your input:

React Native:
```jsx
<TextInput
  textContentType="oneTimeCode"
  keyboardType="number-pad"
  autoComplete="sms-otp"  // Android
  placeholder="6-digit code"
/>
```

SwiftUI:
```swift
TextField("6-digit code", text: $otp)
    .textContentType(.oneTimeCode)
    .keyboardType(.numberPad)
```

iOS will surface the just-received code above the keyboard as a tap-to-fill suggestion. On Android, SMS Retriever API can auto-submit the code without any user action.

### Deep linking for email verification
Don't force users to leave the app, open email, copy the code, come back, and paste. Use a verification link in the email that deep-links directly into the authenticated app state.

---

## 7. Local-first state for deferred registration

The blueprint skill's §6 deferred-registration doctrine requires storing onboarding state locally before a server account exists.

### React Native
Use `@react-native-async-storage/async-storage` or `react-native-mmkv` (faster):

```jsx
import { MMKV } from 'react-native-mmkv';
export const storage = new MMKV();

// During onboarding
storage.set('onboarding.answers', JSON.stringify(answers));
storage.set('onboarding.progress', currentStep);
storage.set('onboarding.firstCoreActionCompleted', true);

// On signup (later)
async function syncToServer() {
  const answers = JSON.parse(storage.getString('onboarding.answers') ?? '{}');
  await api.post('/users/sync-onboarding', answers);
  storage.delete('onboarding.answers');  // now on server
}
```

### Swift
`UserDefaults` for simple state, `SwiftData` or Core Data for complex.

### Flutter
`shared_preferences` (simple) or `hive` (complex, faster).

---

## 8. Remote Config — the A/B testing substrate

**Every single onboarding screen must be backed by a Remote Config flag.** Not "most". Every. This is the substrate that makes iteration possible.

### The flag shape
```
onboarding.welcome.variant → "control" | "animated_triangle" | "mascot_hello"
onboarding.name_screen.enabled → true | false
onboarding.goal_screen.copy_variant → "short" | "long"
onboarding.paywall.price_tier → "standard" | "quiz_tailored" | "lifetime_decoy"
onboarding.notification_pre_prompt.style → "default" | "with_preview" | "mascot"
```

### Vendor choice

| Vendor | Strengths | Weaknesses | Best for |
|---|---|---|---|
| **Firebase Remote Config** | Free, deep Google integration, fast CDN | Basic UI, no native statistical significance calculator | Indie / early-stage apps |
| **LaunchDarkly** | Best-in-class segmentation, strong UI, feature-flag patterns | Expensive | Series-A+ with engineering headcount |
| **Statsig** | Integrated experimentation + analytics + feature flags | Newer, smaller ecosystem | Experiment-heavy product teams |
| **Amplitude Experiment** | Tight integration with Amplitude analytics | Lock-in to Amplitude | Teams already on Amplitude |
| **PostHog** | Open-source option, self-hostable | DIY overhead | Privacy-sensitive or self-hosted |
| **ConfigCat** | Simple, affordable mid-market | Fewer experiment features | Bootstrapped SaaS |

For most mobile apps just getting started: **Firebase Remote Config + Mixpanel** is the cost-free starter stack. Upgrade when you hit ≥100K MAU and need real segmentation.

### Flag naming convention
```
{product}.{feature}.{aspect}
onboarding.welcome.variant
onboarding.welcome.social_proof_style
paywall.pricing.has_lifetime_decoy
notification_prompt.preview_enabled
```

Keep flags flat and predictable. Deep hierarchies make tooling painful.

### Pre-compute flag values at onboarding start
Fetch all onboarding-related flags BEFORE rendering the first screen. Mid-flow flag changes (if the value refreshes) cause jarring UX. On app start:

```jsx
async function initOnboarding() {
  await remoteConfig().fetchAndActivate();
  const snapshot = {
    welcomeVariant: remoteConfig().getValue('onboarding.welcome.variant').asString(),
    paywallVariant: remoteConfig().getValue('onboarding.paywall.price_tier').asString(),
    // ...
  };
  // Persist snapshot for this session; don't re-fetch mid-flow
  return snapshot;
}
```

---

## 9. Analytics event schema — the Mixpanel-standard template

Every onboarding screen fires at least two events: view and interaction. Below is a complete schema ready to drop into Mixpanel, Amplitude, PostHog, or Segment.

### Core events

```
onboarding_started
  → { version, variant_ids: {...}, device_type, os_version, locale }

onboarding_screen_viewed
  → { step_index, step_name, variant_id, time_since_start_ms }

onboarding_screen_completed
  → { step_index, step_name, variant_id, time_on_screen_ms, value (if input) }

onboarding_screen_skipped
  → { step_index, step_name, variant_id }

onboarding_back_pressed
  → { from_step, to_step }

onboarding_exited
  → { last_step_index, last_step_name, total_time_ms, reason: "closed_app" | "tapped_x" }

onboarding_completed
  → { total_steps, total_time_ms, activation_outcome: "paywall_shown" | "skipped_paywall" | "trial_started" }
```

### Quiz / data input events

```
quiz_question_answered
  → { question_id, question_text, answer, time_to_answer_ms, is_multi_select }

quiz_question_skipped
  → { question_id }

data_input_validation_failed
  → { field_name, error_type }
```

### Permission events

```
permission_pre_prompt_shown
  → { permission_type, timing_context: "feature_tap" | "post_aha" | "on_launch" }

permission_pre_prompt_allowed
  → { permission_type }

permission_pre_prompt_denied
  → { permission_type }

permission_os_prompt_shown
  → { permission_type }

permission_os_prompt_result
  → { permission_type, result: "granted" | "denied" | "limited" }
```

### Paywall events

```
paywall_viewed
  → { paywall_variant, triggered_from: "onboarding" | "feature_gate" | "settings" }

paywall_plan_tapped
  → { plan_id, plan_price, plan_duration }

paywall_dismissed
  → { paywall_variant, dismissed_via: "x_button" | "back_gesture" | "restore_purchase" }

trial_started
  → { plan_id, plan_price, plan_duration, paywall_variant, source: "onboarding" | "re-engagement" }

purchase_completed
  → { plan_id, revenue_usd, currency, source }

trial_cancelled
  → { plan_id, day_of_trial, reason (if captured) }
```

### Activation events

```
first_core_action_completed
  → { action_type, time_since_install_ms }

signup_completed
  → { method: "apple" | "google" | "email_magic_link" | "phone_otp", had_onboarding_state_to_sync: true }
```

### User properties to set
```
user.onboarding_version
user.onboarding_completed_at
user.onboarding_variant (concatenation of all variant_ids seen)
user.quiz_answers (flattened quiz answers as properties)
user.acquisition_channel (from attribution survey)
user.first_paywall_shown_at
user.first_trial_started_at
user.lifetime_revenue_usd (RevenueCat handles this)
```

### Event firing discipline
- Fire view events in `useEffect([], ...)` / `onAppear` — once per screen instance
- Fire interaction events synchronously on tap — don't wait for network
- Batch events — don't block navigation on event dispatch
- Include `variant_id` on every event — you cannot A/B test otherwise

---

## 10. A/B testing protocol — the Kaizen discipline

Alex Schievano's framework, from ~2,300 winning apps studied:

### Rule 1: one change per test
Never change multiple screens at once. You cannot attribute the lift. **"Change only one onboarding step at a time."**

### Rule 2: one screen is the unit, not one button
**"A screen is enough and a good size as far as a test. I would not simply go crazy testing, you know, a different font for the button."**

Testing button colors or fonts is for Duolingo-scale apps that have already optimized everything else. For apps at Indie / early-SaaS scale, you don't have enough traffic to detect those effects. **Test whole screens or significant screen variants.**

### Rule 3: sample size
**~400 users per arm minimum for most screen-level tests.** For borderline effects (1–3% lifts) you need 1,000–5,000 per arm. Before running:
- Estimate baseline conversion at the screen.
- Estimate the minimum detectable effect (MDE) you care about — usually 3–5% relative.
- Use a sample-size calculator (Evan Miller's online calculator is the standard) to compute N.
- Divide daily traffic to the screen into N and calculate test duration. If test duration >30 days, increase MDE or wait until scale.

### Rule 4: hypothesis-driven, not "let's see"
Every test needs a stated hypothesis. Good ones:
- "If we add a 'because' subtitle to the birth-location question, completion will rise 3%+ because reason-giving reduces suspicion."
- "If we show the paywall after the personalized plan reveal instead of before, trial start rate will rise 5%+ because peak-end rule."
- "If we replace the feature carousel with a quiz, open-to-trial will rise 10%+ because Headspace saw 10% from multi-intent alone."

Bad ones:
- "Let's try changing this."
- "Green buttons convert better, let's try green."
- "I have a feeling the copy is off."

### Rule 5: wait for significance
Don't peek at results mid-test and call it early. Common threshold: 95% statistical significance (p<0.05). Tools (LaunchDarkly, Statsig, Amplitude Experiment) compute this natively. With Firebase Remote Config, export to Mixpanel and compute manually.

### Rule 6: compound small wins
**"This is a business made of small uplifts of 1%, 2%, 3% that stacked together at the end of the day make up the whole difference between making millions and not."**

A realistic optimization trajectory:
- Month 1: 22% open-to-trial
- Month 3: 26%
- Month 6: 31%
- Month 12: 33%+

Each jump comes from a single-screen test that won. You stack them.

### Rule 7: don't test two tests at once on the same user
If you're testing Screen A variant and Screen C variant in parallel, users who see both are contaminated. Either (a) mutually exclude: a user is in EITHER the Screen A test OR the Screen C test, never both, or (b) test sequentially.

### Example test matrix (for a fitness app)

| Hypothesis | Control | Treatment | Expected lift | MDE | N per arm |
|---|---|---|---|---|---|
| Adding a progress bar to quiz screens | No progress bar | Segmented bar, starts at 10% | +5–8% completion | 3% | ~500 |
| Reason-giving on birthdate ask | "When's your birthday?" | "When's your birthday? — so we start you on the right plan for your age group" | +3% completion | 2% | ~800 |
| Multi-select vs single-select on goals | Single-select | Multi-select | +8–10% trial start | 5% | ~400 |
| Blinkist reassurance timeline on paywall | No timeline | 3-row timeline | +4% trial start | 3% | ~700 |
| Quiz-tailored pricing | Fixed pricing | Pricing varies by quiz answers | +15–20% plan upgrades | 10% | ~300 |
| Lifetime decoy tier | Weekly + Yearly | Weekly + Yearly + $349 Lifetime | +5% yearly selection | 3% | ~500 |
| Founder note at end | No note | Handwritten founder signature | +2% retention D7 | 2% | ~1000 |

---

## 11. Metrics — what to track and what's good

### The primary funnel

```
Install
   ↓ ~85%+ ← onboarding_started rate
Onboarding started
   ↓ 30–60% ← onboarding completion rate
Onboarding completed
   ↓ 40–80% ← paywall view rate
Paywall viewed
   ↓ 20–40% ← trial start rate (vs paywall views)
Trial started
   ↓ 25–50% ← trial-to-paid rate
Paid user
```

### Headline metrics

| Metric | Poor | OK | Good | Great | Notes |
|---|---|---|---|---|---|
| **Open → trial** | <10% | 15% | 22% | **33%+** | Alex's apps went 20 → 33 via iteration |
| **Trial → paid** | <15% | 20% | 28% | **33%+** | Fitness benchmark ~33% |
| **Open → paid** | <2% | 5% | 8% | **10%+** | Product of the above two |
| **Revenue per download** | <$0.50 | $1.00 | $2.00 | **$2.50+** | Cal AI hit $2.50/dl ($800k dl → $2M/mo) |
| **Time-to-value (TTV)** | >5 min | 3–5 min | 1–3 min | **<60s for utility; 3–6min for complex tools** | Notion 3–6 min |
| **Day-1 retention** | <15% | 20% | 30% | **40%+** | Baseline ecosystem is ~20% |
| **Day-7 retention** | <10% | 15% | 22% | **30%+** | |
| **Day-30 retention** | <5% | 10% | 15% | **25%+** | |
| **Push opt-in (with priming)** | <30% | 45% | 60% | **70%+** | Blind: 12–17%; primed: ~70% |
| **Onboarding completion rate** | <30% | 50% | 70% | **85%+** | |

### Per-screen drop-off
For every screen in the flow, compute:
```
drop_off_rate = 1 - (next_screen_viewed / this_screen_viewed)
```

Any screen with >15% drop-off that isn't the paywall is a candidate for iteration. The paywall will always have a significant drop — that's fine — but ensure it's within industry norms (~40–60% drop on soft-gate paywalls is typical).

### Stickiness (DAU/MAU)
After onboarding, post-activation retention is measured by DAU/MAU ratio:
```
DAU / MAU = how many unique daily users vs monthly users
```
- >50%: exceptional (Facebook, Instagram)
- 20–50%: strong habit product
- 10–20%: typical consumer app
- <10%: poor engagement

Use as a north star of "did onboarding deliver a habit".

### RevenueCat / Adapty for subscription metrics
These tools give you:
- MRR
- Trial conversion by cohort
- Subscription lifecycle (start, renew, cancel, lapse)
- Price experimentation
- Predictive LTV

Don't try to build these from raw platform receipts. Integrate RevenueCat or Adapty from day 1 of paid features.

---

## 12. The 23.5-hour push pattern

A specific, proven pattern for day-2 retention: **send a push notification exactly 23.5 hours after install.**

Why 23.5 specifically:
- The user installed the app at some specific time yesterday (say 8:30 PM because they had time after dinner).
- 23.5 hours later = 8:00 PM today — approximately the same moment in their routine when they originally downloaded. This is the **context** that motivated download.
- By 24+ hours you've missed the same-context window. By <23 hours you're interrupting a different context.

The half-hour offset also makes your push arrive NOT on the hour — reducing competition from every other app scheduled for 8:00 PM sharp.

### Content
Match the push to onboarding state:
- User completed onboarding but didn't start trial → "Ready to continue your plan?"
- User started but didn't complete → "You're 3 screens from seeing your plan."
- User started trial but didn't use product → "Your plan is waiting for you."

### Implementation
Use OneSignal, Braze, or Firebase Cloud Messaging + a backend scheduler:

```
On install → schedule push for now + 23.5h, conditional on user state
If user uses app before fire time → cancel or update the push
Fire the push; track delivery, open, and subsequent action
```

### Metrics to track
- push_delivered, push_opened, session_started_from_push
- Compare D2 retention of users who received vs didn't receive the push

---

## 13. Performance UX — skeleton screens and perceived speed

### Skeleton screens vs spinners
Research on mobile UI perception:
- Generic native spinner → users perceive wait as long, report lower satisfaction
- Skeleton screens (gray placeholder shapes matching incoming layout) → users perceive wait as significantly shorter, higher satisfaction

**Never ship a generic spinner for any wait >300ms during onboarding.** Use:
- Shimmering skeleton rectangles for text blocks
- Skeleton avatar circles for profile images
- Skeleton buttons (grayed with the same radius)

### Libraries
- React Native: `react-content-loader` or `react-native-skeleton-placeholder`
- SwiftUI: `SkeletonUI` or custom via `redacted(reason: .placeholder)`
- Flutter: `shimmer` package

### The fake-but-effective loader
Different from a skeleton: the "Building your plan…" loader is a **deliberate** 3–5s animated screen that exists to make the user feel their quiz input was processed. See `mobile-onboarding-permissions-and-paywall` §11. Implement as a timed animation, not a data-fetch wait.

```jsx
function BuildingPlanLoader({ onComplete }) {
  useEffect(() => {
    const timer = setTimeout(onComplete, 4500);
    return () => clearTimeout(timer);
  }, []);

  return (
    <View>
      <ProgressBar animated from={0} to={1} duration={4500} />
      <AnimatedList
        items={[
          { text: "Analyzing your goals", delay: 500 },
          { text: "Matching your preferences", delay: 1500 },
          { text: "Optimizing your schedule", delay: 2500 },
          { text: "Finalizing your plan", delay: 3500 },
        ]}
      />
    </View>
  );
}
```

---

## 14. Micro-interactions — haptics, springs, and motion

### Haptic feedback

iOS:
```swift
let generator = UIImpactFeedbackGenerator(style: .light)
generator.impactOccurred()
```

React Native (`expo-haptics`):
```jsx
import * as Haptics from 'expo-haptics';

// On selection
Haptics.selectionAsync();

// On success
Haptics.notificationAsync(Haptics.NotificationFeedbackType.Success);

// On impact
Haptics.impactAsync(Haptics.ImpactFeedbackStyle.Light);
```

Where to fire haptics in onboarding:
- Every quiz answer tap → `selectionAsync()`
- Personalized plan reveal → `notificationAsync(Success)`
- Paywall plan selection → `selectionAsync()`
- Permission granted → `notificationAsync(Success)`
- Trial started → `notificationAsync(Success)`

**Do NOT fire haptics on:**
- Passive screen transitions
- Every scroll
- Error states (except rarely, for critical errors)

### Spring animations
Use spring motion on interactive transitions. Feels alive in a way linear transitions don't.

React Native Reanimated:
```jsx
withSpring(targetValue, { damping: 15, stiffness: 120 })
```

SwiftUI:
```swift
.animation(.spring(response: 0.4, dampingFraction: 0.7), value: state)
```

Flutter:
```dart
SpringSimulation(SpringDescription(mass: 1, stiffness: 120, damping: 15), from, to, velocity)
```

### Signature moments (Focus Flight effect)
For the paywall or plan-reveal screen, consider one signature animated moment:
- Ticket "printing" from the top with haptic pulses (Focus Flight)
- Confetti on trial start
- Mascot wave / nod on plan reveal
- Progress bar filling with haptic ticks

---

## 15. Glassmorphism implementation

2025/2026 standard for onboarding modals, tooltips, and permission pre-prompts.

CSS (web / hybrid apps):
```css
.glass-modal {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
  border: 1px solid rgba(255, 255, 255, 0.18);
  border-radius: 16px;
}
```

SwiftUI:
```swift
Rectangle()
    .fill(.ultraThinMaterial)
    .cornerRadius(16)
```

React Native (`@react-native-community/blur` or Expo `BlurView`):
```jsx
import { BlurView } from 'expo-blur';

<BlurView intensity={80} tint="light" style={styles.glass}>
  <Text>Permission pre-prompt content</Text>
</BlurView>
```

Glassmorphism establishes Z-axis depth: the modal floats above the interface, the interface blurs beneath. Used right, it keeps context while focusing attention. Used wrong (everywhere), it's visual noise.

**Use for:** permission pre-prompts, tooltip overlays, temporary modals.
**Don't use for:** core screen backgrounds, text-heavy areas, high-contrast-required CTAs.

---

## 16. Soft launch strategy

Before a full launch, release to a restricted cohort:
- iOS: use App Store Connect's phased release or a TestFlight beta with ~1000 testers
- Android: staged rollout (10% → 50% → 100%) via Play Console
- Geo-restricted: launch in a small market (Canada, Australia, New Zealand, Ireland) and iterate before US/UK/EU hits

Target cohort size: **up to 100K users** or a single geographic segment. Enough volume to get statistical significance on onboarding funnel metrics; small enough that bad bugs don't burn your user base reputation.

During soft launch:
- Run baseline experiments on the three or four biggest-impact hypotheses
- Fix the top 2–3 drop-off points
- Verify push opt-in, paywall conversion, and D1/D7 retention hit targets
- Then open the floodgates

---

## 17. Tooling stack — recommended by layer

### Design / inspiration
- **Mobbin** — the reference library for UI patterns across 100K+ apps
- **Screens.design** — specialized for onboarding and paywall inspiration; has AI-generator that exports HTML (cf §19)

### Analytics
- **Mixpanel** — industry standard for onboarding funnels. Best funnel UX.
- **Amplitude** — Mixpanel alternative, strong cohort analysis
- **PostHog** — open-source option, good for privacy-conscious teams
- **Appcues** — designed specifically for onboarding flow analytics
- **UXCam / Smartlook** — session replay for spot-checking drop-offs

### Remote Config / Experimentation
- **Firebase Remote Config** + **Firebase A/B Testing** — free, good enough for <100K MAU
- **LaunchDarkly** — premium, best at scale
- **Statsig** — integrated flags + experiments + analytics
- **Amplitude Experiment** — if already on Amplitude
- **Growthbook** — open-source experimentation platform

### Paywall / Subscriptions
- **RevenueCat** — the default. Full subscription lifecycle, pricing tests, cross-platform entitlements. Start with this.
- **Adapty** — RevenueCat alternative, stronger on paywall templating + paywall A/B
- **Qonversion** — third option

### Push notifications
- **OneSignal** — free tier generous, solid default
- **Braze** — enterprise, deep segmentation
- **Customer.io** — strong for cross-channel (push + email + in-app)
- **Firebase Cloud Messaging** — bare-bones, no UI, for rolling your own

### Attribution
- **Adjust** — paid acquisition attribution standard
- **AppsFlyer** — Adjust alternative, similar
- **Branch** — deep linking + attribution, often paired with the above
- **Apple SKAdNetwork / Google Install Referrer** — direct platform attribution, free but limited

### Auth
- **Supabase / Firebase Auth** — bundled with backend, fast path to magic link + SSO
- **Clerk** — React Native + web, excellent developer UX
- **Auth0** — enterprise, expensive, full-featured

### Combined indie starter stack (near-free to start):
- Firebase (Auth + Remote Config + Messaging) + Mixpanel + RevenueCat + OneSignal
- Total cost at 10K MAU: ~$0–$200/month

### Scaled stack ($1M+ ARR):
- LaunchDarkly + Amplitude + RevenueCat + Braze + Adjust + Clerk
- Total cost: ~$3K–$15K/month

---

## 18. Accessibility — don't ship broken

Onboarding hits a particularly diverse user base (every new user), so accessibility is not a corner case:

- **Dynamic type** — support user-chosen text sizes. Never hardcode font sizes without a scale.
- **VoiceOver / TalkBack labels** — every image, icon, and button must have an accessible label.
- **Contrast ratios** — WCAG AA minimum (4.5:1 for body text, 3:1 for large text). Glassmorphism can violate this — always verify.
- **Haptic fallbacks** — if the device has haptics disabled (accessibility setting), provide a visual equivalent.
- **Skip paths** — users with motor impairments may struggle with long flows; always allow navigating directly via keyboard or assistive tech.
- **Keyboard navigation** — on iPad with keyboard, tab through onboarding must work.

### Testing
- iOS: Accessibility Inspector (macOS bundled)
- Android: Accessibility Scanner (Play Store)
- Both: VoiceOver / TalkBack walkthroughs on every onboarding screen before ship

---

## 19. The screens.design → Claude Code pipeline

A pattern worth calling out explicitly for agentic coding:

1. **Design inspiration:** browse screens.design library for onboarding flows in your niche.
2. **AI generation:** use screens.design's Create tool to generate a candidate flow. The tool outputs HTML.
3. **HTML → React Native conversion via Claude Code:** the HTML is actual code, not images. Claude Code can read the structure, map HTML elements to RN components, preserve animations as Reanimated equivalents, and convert CSS to StyleSheet objects. This is reportedly fast and high-fidelity.
4. **Iterate in code:** once in RN / SwiftUI / Flutter, apply this skill's patterns (mount-all, instrumentation, Remote Config).

This is the fastest known path from "I want an onboarding flow" to "instrumented, A/B-testable flow in my codebase" — a matter of hours, not weeks.

---

## 20. Code-level anti-patterns — never ship these

1. **Conditional-render steps** that destroy and remount on every navigation (§2).
2. **Permission prompts on launch** — breaks 50%+ of users' core functionality (§1 of permissions skill).
3. **Typed-password signup required** — magic link / SSO beats this every time (§6).
4. **Generic spinners >300ms** — use skeletons (§13).
5. **Hardcoded strings instead of Remote Config** — no A/B capability (§8).
6. **No analytics on a screen** — you cannot improve what you cannot measure (§9).
7. **Mid-flow Remote Config fetch** — causes jarring UX changes (§8).
8. **Blocking navigation on event dispatch** — makes UI feel laggy (§9).
9. **Ignoring dynamic type** — breaks for a significant minority of users (§18).
10. **Ignoring deferred registration architecture** — if your first-screen signup is the choice, re-check the blueprint (§7 + blueprint skill §6).
11. **Auto-importing contacts silently** — legal and trust disaster (permissions skill §2).
12. **Firing a single whole-flow A/B test with 10 changes at once** — uninterpretable results (§10 Rule 1).
13. **Testing button colors pre-scale** — no traffic for that signal (§10 Rule 2).

---

## 21. Output contract — what this skill delivers

When invoked for implementation, build, or measurement work, produce:

### Code deliverables
1. **Mount-all pattern** for the onboarding container (§2–5).
2. **One component per screen**, each wired to a Remote Config flag (§8).
3. **Magic link / SSO / OTP-autofill** auth, no typed passwords (§6).
4. **Local-first state** via MMKV / UserDefaults / Hive (§7).
5. **Skeleton screens** for any wait >300ms (§13).
6. **Haptic feedback** on every user decision (§14).
7. **Glassmorphism** on permission pre-prompts (§15).
8. **Analytics events** firing on view + interaction per the schema (§9).
9. **Accessibility labels** on every interactive element (§18).

### Instrumentation deliverables
1. **Full event schema** wired into Mixpanel (or equivalent) per §9.
2. **Remote Config flag list** documenting every testable screen (§8).
3. **Per-screen funnel dashboard** with drop-off visualizations.
4. **Cohort dashboard** segmenting by install source, onboarding variant, completion status.

### Experiment deliverables
1. **Hypothesis document** per test with stated expected lift + rationale (§10).
2. **Sample size calculation** for each test (§10 Rule 3).
3. **Per-test Remote Config configuration** with random user assignment (§8).
4. **Statistical significance check** before concluding any test (§10 Rule 5).
5. **Compound wins tracker** — a log of won experiments with their measured lifts (§10 Rule 6).

### Default stack recommendation
- **Indie/bootstrap:** Firebase (Auth + Remote Config + Messaging) + Mixpanel + RevenueCat + OneSignal
- **Scaled:** LaunchDarkly + Amplitude + RevenueCat + Braze + Adjust + Clerk

### Never ship
- A screen without Remote Config flag
- A screen without analytics events
- A permission prompt without priming
- A spinner where a skeleton would fit
- A typed-password signup when SSO exists
- A whole-flow A/B test changing multiple screens at once
- An onboarding optimized without an A/B testing substrate

This skill is the multiplier on every other skill in the series. The blueprint defines structure, psychology defines copy, permissions/paywall defines trust moments — **but this skill is what turns the whole thing into a system that compounds 1% at a time into a 10× business outcome.**
