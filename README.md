# 🏥 Rainbow Eye Hospital

A state-of-the-art, fully responsive Eye Hospital web and mobile application built with **Flutter 3.x** and **Material 3**. Designed for maximum visual impact, accessibility, and high performance across all screen sizes (PC, Laptop, Tablet, and Mobile).

---

## 📋 Table of Contents

- [Hospital Information & Contact](#-hospital-information--contact)
- [Official Branding & Logo](#-official-branding--logo)
- [Eye Animation Loader](#-eye-animation-loader)
- [Features Built](#-features-built)
- [Responsive Screen Architecture](#-responsive-screen-architecture)
- [Animation & UX Highlights](#-animation--ux-highlights)
- [Tech Stack & Packages](#-tech-stack--packages)
- [Project Architecture](#-project-architecture)
- [Getting Started](#-getting-started)
- [Upcoming Roadmap](#-upcoming-roadmap)

---

## 📍 Hospital Information & Contact

- **Address**: `Opp. SVBN EM School, Kapparada, NGGO Colony, P.R Gardens, Madhavadhara, Visakhapatnam – 530018`
- **Mobile / Emergency**: `+91 - 8341104525`
- **Landline**: `0891 - 2554525`
- **Operating Hours**: `Mon – Sat: 9 AM – 7 PM`

---

## 🏷️ Official Branding & Logo

- **Signature Logo Mark**: Custom vector silhouette of the capital letter **`R`** embedded with an anatomical **Eye contour**, central iris/pupil cutout, and specular highlight reflection bubble.
- **Stylized Typography**:
  - `RAINBOW`: Bold, wide geometric sans-serif (`Montserrat 900`, `letterSpacing: 2.2`).
  - `EYE HOSPITAL`: Bold uppercase tracking (`Montserrat 800`, `letterSpacing: 3.4`, teal brand color).
- **Color Identity**: Retains the hospital's primary medical teal gradient (`#0891B2` / `#0E7490`) and dark slate navy (`#0F172A`).

---

## 👁️ Eye Animation Loader

- **Periodic Eyelid Blinking**: Anatomical eyelid animation that smoothly closes and re-opens at timed intervals.
- **Pupil Scanning Physics**: The iris and pupil scan left-to-right and center smoothly.
- **Vision Wave Pulse**: Radiating radar wave rings around the eye.
- **Brand Reveal**: Fades smoothly on initial page startup and can be replayed anytime.

---

## 🌟 Features Built

### 1. Top Utility & Info Bar
- Official Visakhapatnam clinic address with map tooltip.
- Landline (`0891-2554525`) and Mobile (`+91 83411 04525`) numbers with one-tap dialing (`url_launcher`).
- Clinic operating timings.
- Social media icon hub with hover animations.

### 2. Header & Main Navigation
- **Official "R with Eye" Logo**: Scalable vector emblem with matching signage typography.
- **Centered Nav Links**: *Home, About ▾, Services ▾, Doctors, Blog, Contact*.
- **Compact Floating Dropdown Cards**: 
  - **About Card** (230px): 4 structured links with icons and hover highlights.
  - **Services Card** (265px): 7 clinical eye specialty links with medical icons.
- **Book Appointment CTA Button**: Scalable with calendar icon and glowing hover gradient.
- **Mobile Drawer**: Slide-in drawer with the official logo, expandable categories, and contact info.

### 3. Infinite Hero Carousel Slider
- **Infinite Forward-Looping Transitions**: Continuous auto-rotation every 5 seconds without backward snapping.
- **Staggered Animations**: Eyebrow badge ➔ Headline ➔ Subtext ➔ CTA buttons ➔ Live highlight badge.
- **Ambient Glowing Orbs**: Soft floating background effects.

### 4. Trust Stats & Numerical Ticker Bar
- **Count-Up Tickers**: `25+ Years`, `50+ AIIMS Surgeons`, `1,00,000+ Procedures`, `4.9 Rating`.
- **Interactive Hover Cards**: Floating card lift (`translateY(-6px)`) and glowing borders.

---

## 📐 Responsive Screen Architecture

| Screen Tier | Width Range | Layout Strategy |
|---|---|---|
| **Large PC / 4K** | `≥ 1180px` | Full Desktop Header: Official Logo + Centered Nav + Book Appointment CTA |
| **Laptop / Compact Desktop** | `960px – 1179px` | Compact Desktop Header: Scaled Logo + Compact Centered Nav + Book Appointment CTA |
| **Tablet** | `600px – 959px` | Tablet Header: Logo + Book Appointment CTA + Hamburger Menu (`MobileDrawer`) |
| **Mobile** | `< 600px` | Mobile Header: Logo + Hamburger Menu; utility bar hidden; hero buttons stacked |

---

## 📁 Project Architecture

```
lib/
├── main.dart                                # App entry point & theme
├── core/
│   ├── constants/
│   │   ├── app_colors.dart                  # Brand colors & gradients
│   │   ├── app_typography.dart              # Typography hierarchy
│   │   └── app_breakpoints.dart             # Responsive breakpoints
│   └── utils/
│       └── responsive_helper.dart           # Device type helpers
├── features/
│   └── home/
│       ├── home_screen.dart                 # Assembly + Eye Loader integration
│       └── widgets/
│           ├── top_utility_bar.dart         # Section 1: Official contact strip
│           ├── header/
│           │   ├── header_widget.dart       # Section 2: Sticky header with RainbowLogo
│           │   ├── nav_menu.dart            # Compact floating dropdown cards
│           │   └── mobile_drawer.dart       # Mobile drawer with official branding
│           ├── hero/
│           │   └── hero_slider.dart         # Section 3: Infinite carousel + ambient orbs
│           └── trust_stats/
│               └── trust_stats_bar.dart     # Section 4: Numerical counter & hover cards
└── shared/
    └── widgets/
        ├── app_button.dart                  # Animated CTA & Header buttons
        ├── eye_animation_loader.dart        # Blinking eye scanner loader
        ├── rainbow_logo.dart                # Official "R with Eye" emblem & typography
        └── social_icon_row.dart             # Social media icon group
```

---

## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone <repo-url>
cd rainbow

# 2. Get dependencies
flutter pub get

# 3. Run on Chrome
flutter run -d chrome
```
