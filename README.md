# 🌱 Eco Impact Label

> A floating AR tag that appears above a household item, showing its environmental impact and a more sustainable alternative.

**Eco Impact Label** is an augmented reality prototype that turns everyday objects into moments of awareness. Point your device at a household item and a clean, floating label materializes above it — surfacing the item's environmental footprint and suggesting a greener swap, right where you'd make the decision.

🔗 **Live case study:** [mieuxmoi.framer.website/eco-impact-label](https://mieuxmoi.framer.website/eco-impact-label)

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

> ℹ️ Adjust the specifics above to match your project's actual minimum versions.

## 🚀 Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/<your-username>/<repo-name>.git

# 2. Open the project in Xcode
cd <repo-name>
open EcoImpactLabel.xcodeproj   # or the .xcworkspace, if present

# 3. Select your connected iOS device as the build target
#    (AR requires a physical device)

# 4. Build & run
#    ⌘R
```

Once installed, launch the app and point your device at a supported household item to see its eco impact label appear.

## 📂 Project Structure

```
EcoImpactLabel/
├── App/                 # SwiftUI app entry point & views
├── AR/                  # Reality Composer scenes & AR logic
├── Models/              # 3D assets exported from Blender
├── Resources/           # Assets, icons, sample data
└── README.md
```

> ℹ️ This is a suggested layout — update it to reflect the actual folders in your repo.

## 🧭 Roadmap

Ideas for extending the prototype:

- [ ] Expand the library of recognized household items
- [ ] Pull impact data from a live sustainability dataset
- [ ] Let users tap the label to see a deeper breakdown
- [ ] Save and compare items over time
- [ ] Support for object detection beyond predefined models

## 👤 Author

**Astrida Nayla**

- 📧 [design.astrida@gmail.com](mailto:design.astrida@gmail.com)
- 💼 [LinkedIn](https://www.linkedin.com/in/astrida-nayla/)
- ✍️ [Medium](https://astridanayla.medium.com/)
- 🌐 [Portfolio](https://mieuxmoi.framer.website/)

---

<p align="center">Handmade with ♥︎ in Jakarta · © 2026 Astrida Nayla</p>
