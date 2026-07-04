import SwiftUI
import RealityKit
import ARKit
import EcoLabel
import Combine

struct ARViewContainer: UIViewRepresentable {

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)

        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal, .vertical]
        arView.session.run(config)

        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleTap(_:))
        )
        arView.addGestureRecognizer(tapGesture)

        context.coordinator.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject {

        weak var arView: ARView?

        private var anchor: AnchorEntity?
        private var modelContainer: Entity?
        private var billboardTarget: Entity?
        private var updateSubscription: Cancellable?

        private var spinningEntity: Entity?

        // MARK: - Tap

        @objc func handleTap(_ sender: UITapGestureRecognizer) {
            guard let arView = arView else { return }

            let location = sender.location(in: arView)
            let result = performRaycast(at: location, in: arView)

            var position = result?.worldTransform.translation ?? fallbackPosition(in: arView)
            position = offsetPosition(position, in: arView)

            placeAnchor(from: result, at: position, in: arView)
            loadModel()
        }

        // MARK: - Raycasting

        private func performRaycast(at point: CGPoint, in arView: ARView) -> ARRaycastResult? {
            let real = arView.raycast(from: point, allowing: .existingPlaneGeometry, alignment: .horizontal)
            let estimated = arView.raycast(from: point, allowing: .estimatedPlane, alignment: .horizontal)
            return real.first ?? estimated.first
        }

        private func fallbackPosition(in arView: ARView) -> SIMD3<Float> {
            let camera = arView.cameraTransform
            let forward = -camera.matrix.columns.2.xyz
            return camera.translation + forward * 0.5
        }

        // MARK: - Offset

        private func offsetPosition(
            _ position: SIMD3<Float>,
            in arView: ARView,
            distance: Float = 0.1
        ) -> SIMD3<Float> {

            let cameraMatrix = arView.cameraTransform.matrix

            let right = SIMD3(
                cameraMatrix.columns.0.x,
                cameraMatrix.columns.0.y,
                cameraMatrix.columns.0.z
            )

            return position + right * distance
        }

        // MARK: - Anchor

        private func placeAnchor(from result: ARRaycastResult?,
                                 at position: SIMD3<Float>,
                                 in arView: ARView) {

            cleanup(in: arView)

            if let planeAnchor = result?.anchor as? ARPlaneAnchor {
                placeOnPlane(planeAnchor, worldPosition: position, in: arView)
            } else {
                placeInWorld(position, in: arView)
            }
        }

        private func placeOnPlane(_ planeAnchor: ARPlaneAnchor,
                                 worldPosition: SIMD3<Float>,
                                 in arView: ARView) {

            let anchorEntity = AnchorEntity(anchor: planeAnchor)

            let anchorTransform = Transform(matrix: planeAnchor.transform)
            let localPosition = worldPosition - anchorTransform.translation

            let container = Entity()
            container.position = localPosition

            anchorEntity.addChild(container)
            arView.scene.addAnchor(anchorEntity)

            self.anchor = anchorEntity
            self.modelContainer = container
        }

        private func placeInWorld(_ position: SIMD3<Float>, in arView: ARView) {
            let anchorEntity = AnchorEntity(world: position)
            arView.scene.addAnchor(anchorEntity)

            self.anchor = anchorEntity
            self.modelContainer = anchorEntity
        }

        private func cleanup(in arView: ARView) {
            if let anchor = anchor {
                arView.scene.removeAnchor(anchor)
            }
            updateSubscription?.cancel()
            spinningEntity = nil
        }

        // MARK: - Model

        private func loadModel() {
            guard let container = modelContainer else { return }

            Task { @MainActor in
                do {
                    let loadingEntity = try await Entity(named: "Scene Loading", in: ecoLabelBundle)
                    let cardEntity = try await Entity(named: "Scene Card", in: ecoLabelBundle)
                    
                    loadingEntity.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])
                    cardEntity.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])

                    let loadingGroup = Entity()

                    // 🔥 WRAPPER (rotation pivot)
                    let spinnerWrapper = Entity()

                    // ✅ CENTER PIVOT (CRITICAL FIX)
                    let bounds = loadingEntity.visualBounds(relativeTo: nil)
                    let center = bounds.center
                    loadingEntity.position = -center

                    spinnerWrapper.addChild(loadingEntity)

                    // layout positioning
                    spinnerWrapper.position = [0, 0.3, -1]
                    cardEntity.position     = [0, -0.02, 0]

                    loadingGroup.addChild(spinnerWrapper)
                    loadingGroup.addChild(cardEntity)

                    loadingGroup.scale = SIMD3<Float>(repeating: 0.05)
                    loadingGroup.generateCollisionShapes(recursive: true)

                    self.spinningEntity = spinnerWrapper

                    let rotator = createBillboardContainer()
                    rotator.addChild(loadingGroup)
                    container.addChild(rotator)

                    self.billboardTarget = rotator
                    startBillboard()

                    try await Task.sleep(nanoseconds: 1_500_000_000)

                    loadingGroup.removeFromParent()
                    self.spinningEntity = nil

                    let finalEntity = try await Entity(named: "Scene", in: ecoLabelBundle)

                    finalEntity.scale = SIMD3<Float>(repeating: 0.05)
                    finalEntity.generateCollisionShapes(recursive: true)
                    finalEntity.orientation = simd_quatf(angle: .pi, axis: [0, 1, 0])

                    rotator.addChild(finalEntity)

                } catch {
                    print("❌ Failed:", error)
                }
            }
        }

        private func createBillboardContainer() -> Entity {
            let entity = Entity()
            return entity
        }

        // MARK: - Billboard + Spin

        private func startBillboard() {
            guard let arView = arView else { return }

            updateSubscription = arView.scene.subscribe(
                to: SceneEvents.Update.self
            ) { [weak self] _ in
                self?.updateFrame()
            }
        }

        private func updateFrame() {
            updateBillboard()
            updateSpin()
        }

        private func updateBillboard() {
            guard let arView = arView,
                  let model = billboardTarget,
                  let parent = model.parent else { return }

            let cameraWorld = arView.cameraTransform.translation
            let cameraLocal = parent.convert(position: cameraWorld, from: nil)

            let modelPos = model.position

            var direction = cameraLocal - modelPos
            direction.y = 0

            if simd_length_squared(direction) > 0.0001 {
                let target = modelPos + simd_normalize(direction)
                model.look(at: target, from: modelPos, relativeTo: parent)
            }
        }

        private func updateSpin() {
            guard let spinner = spinningEntity else { return }

            // ✅ Z-axis rotation (correct for loading spinner)
            let delta = simd_quatf(angle: 0.1, axis: SIMD3<Float>(0, 0, 1))
            spinner.transform.rotation = simd_normalize(delta * spinner.transform.rotation)
        }
    }
}

// MARK: - Helpers

extension simd_float4x4 {
    var translation: SIMD3<Float> {
        SIMD3(columns.3.x, columns.3.y, columns.3.z)
    }
}

extension simd_float4 {
    var xyz: SIMD3<Float> {
        SIMD3(x, y, z)
    }
}

// MARK: - View

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .ignoresSafeArea()
    }
}
