# 🌱 Eco Impact Label

> A floating AR tag that appears above a household item, showing its environmental impact and a more sustainable alternative.

**Eco Impact Label** is an augmented reality prototype that turns everyday objects into moments of awareness. Point your device at a household item and a clean, floating label materializes above it — surfacing the item's environmental footprint and suggesting a greener swap, right where you'd make the decision.

🔗 **Live case study:** [mieuxmoi.framer.website/eco-impact-label](https://mieuxmoi.framer.website/eco-impact-label)

> ⚠️ **Prototype only.** This is a visual/interaction proof-of-concept. There is **no backend, database, or real logic behind it yet** — the impact data and sustainable alternatives shown are hardcoded/placeholder content used to demonstrate the AR experience and UX, not live calculations.

---

## ✨ Overview

Sustainability information usually lives far from the moment of choice — buried in packaging, apps, or articles you read long after a purchase. Eco Impact Label brings that context into physical space using AR, so the environmental story of an object is visible the instant you look at it.

The result is a lightweight, glanceable experience: no menus to dig through, just an impact summary and an actionable alternative floating in place above the item.


## 🎯 Features

- **Floating AR label** — an environmental-impact tag anchors above a detected household item and stays locked in 3D space as you move.
- **Impact at a glance** — surfaces the item's environmental footprint in a compact, readable format.
- **Sustainable alternative** — pairs each item with a greener swap so the takeaway is actionable, not just informational.
- **Spatial, in-context UX** — information appears exactly where the decision happens rather than in a separate screen.


## 🛠️ Built With

| Tool | Role |
|------|------|
| **SwiftUI** | App UI and the label's interface layer |
| **Reality Composer** | AR scene authoring, anchoring, and behaviors |
| **Blender** | 3D modeling and assets for the AR scene |


## 📱 Requirements

- **iOS device with ARKit support** (an A-series chip and rear camera)
- **Xcode** (recent version recommended)
- **iOS deployment target** compatible with your project settings
- A physical device — AR features can't be fully tested in the Simulator


## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/astridanayla/ecolabel-ar.git

# 2. Open the project in Xcode
cd ecolabel-ar
open EcoLabelAR.xcodeproj   # or the .xcworkspace, if present

# 3. Select your connected iOS device as the build target
#    (AR requires a physical device)

# 4. Build & run
#    ⌘R
```

Once installed, launch the app and point your device at a supported household item to see its eco impact label appear.


## 📂 Project Structure

```
ecolabel-ar/
├── EcoLabelAR.xcodeproj/        # Xcode project file
├── EcoLabelAR/                  # Main app source
│   ├── EcoLabelARApp.swift      # App entry point (SwiftUI @main)
│   ├── ContentView.swift        # Root view hosting the AR experience
│   ├── Experience.rcproject     # Reality Composer scene (AR anchors & behaviors)
│   ├── Assets.xcassets/         # App icons, colors, images
│   ├── Info.plist               # App configuration (camera permission, etc.)
│   └── Preview Content/         # SwiftUI preview assets
├── EcoLabelARTests/             # Unit tests
└── EcoLabelARUITests/           # UI tests
```


## 🧭 Roadmap

Ideas for extending the prototype:

- [ ] Expand the library of recognized household items
- [ ] Pull impact data from a live sustainability dataset
- [ ] Let users tap the label to see a deeper breakdown
- [ ] Save and compare items over time
- [ ] Support for object detection beyond predefined models

---

<p align="center">Handmade with ♥︎ in Jakarta · © 2026 Astrida Nayla</p>
