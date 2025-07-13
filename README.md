<p align="center">
  <img src="assets/pulseflash_logo.png" alt="PulseNerd Logo" width="180" />
</p>

## ✅ PulseNerdApp-iOS

**Project Goal:** Companion app for WhatPulse (local Client API), focusing on **real-time stats in landscape mode** for power users, such as gamers and streamers.

---

### 💡 Core Idea

PulseNerd is the **sister app** of PulseView. It’s designed for **live session tracking**, such as Clicks per Second (CPS) and network throughput. It uses the **local WhatPulse Client API** (Port 3490, JSON), runs only within the local network, and is technically **completely separate** from the regular WhatPulse API.

---

### 📱 Platform Support

| Platform   | Support Status                                             |
| ---------- | ---------------------------------------------------------- |
| iPhone     | ✅ Fully supported                                         |
| iPad       | ✅ Fully supported                                         |
| Apple TV   | 🔢 Planned (visual "geek window" for couch/streaming use)  |
| Android    | 🔢 Planned (separate repository: `pulsenerd-android`)      |
| Mac, Watch | ❌ Not planned                                              |
| Vision Pro | ❌ Not planned                                              |

---

### 🧠 Feature Overview

#### 🌟 Core Features

* Live line charts for:
  * 🖱️ Clicks per second
  * 🔽 Download speed (Mbps)
  * 🔼 Upload speed (Mbps)

* Session-based tracking:
  * Duration, peaks, averages, totals
  * Live values updated every 1–3 seconds
  * Data is **not reset by Pulse** – consistent session analytics

* Shareable session summary

#### 📊 Additional Views

* 🧠 **Geek View** – Real-time stat overview with animated cards
* 📶 **Network View** – Live download/upload charts with session summary
* 🖱 **CPS View** – Session-based click analysis (live CPS, peak, average)
* 🫀 **PulseView** – Central action screen with big animated Pulse Button + Pelle’s bark
* ⚙️ **Settings View** – IP/Port input, test connection, legal info, and more
* 📱 **Our Apps** – Discover other apps from Nebuliton

---

### 🛠️ Technical Foundations

* SwiftUI (iOS 17+ / iOS 26 compatible)
* Timer-based polling from `http://<ip>:3490/`
* Native sound playback (`barkingpelle.mp3`) when pulsing
* Modular architecture
* Adaptive layout (iPad optimized)
* Custom dark design, minimal distractions
* Planned: `tvOS` support with dedicated read-only stat screen

---

### 🎨 Design & Branding

* App name: **PulseNerd**
* Icon: ⚡️ Red lightning bolt in PulseView-style
* Visuals: Animated, glowing pulse elements, dark-mode ready
* No iCloud, no login, no external API – **offline & local only**

---

### 🚀 Release Roadmap

| Phase           | Description                                              |
| --------------- | -------------------------------------------------------- |
| ✅ Planning      | (Completed)                                              |
| ✅ Development   | All major views built and tested                         |
| ✅ iPad Support  | Adaptive layout implemented                              |
| ✅ RC 1          | Release Candidate ready                                  |
| 🚀 Beta         | TestFlight distribution phase begins                     |
| 🎉 Release      | App Store submission (after final feedback)              |

---

© 2025 Nebuliton – proudly built in 1.5 days 🧠⚡️🐶
