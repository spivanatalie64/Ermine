# Architectural Decision: Switching from LiveKit to Mediasoup

## Status
Proposed / In-Progress

## Context
Ermine initially utilized **LiveKit** for its "Voice Chats v2" feature. LiveKit is a powerful Selective Forwarding Unit (SFU) that simplifies WebRTC management. However, as the project evolves, we've identified critical requirements for security, performance, and user privacy that LiveKit's default architecture does not satisfy out-of-the-box.

## Decision
We are transitioning the Ermine voice and video infrastructure from **LiveKit** to **Mediasoup**.

## Rationale

### 1. Security & End-to-End Encryption (E2EE)
*   **The Problem**: Standard SFUs (including LiveKit in its default configuration) terminate the encryption at the server. This means the server has access to the raw media data.
*   **The Solution**: Mediasoup is a lower-level media engine that allows us to implement **Insertable Streams** (WebRTC SFI). This enables true E2EE where the Ermine server only forwards encrypted "blobs" and never possesses the decryption keys. This makes the server "blind" to private conversations.

### 2. High Performance
*   **The Problem**: As a Go-based service, LiveKit introduces higher resource overhead per participant compared to lower-level implementations.
*   **The Solution**: Mediasoup is written in **C++** and provides a Rust wrapper (`mediasoup-rs`). It is designed for extreme performance and low latency, which is critical for a smooth video/audio experience.

### 3. Granular Control & Sovereignty
*   **The Problem**: LiveKit provides an "all-in-one" solution that can be difficult to strip down or customize for niche privacy requirements.
*   **The Solution**: Mediasoup is a library, not a server. This allows us to build a bespoke signaling and media orchestration layer (which we've named **Vortex**) that aligns perfectly with Ermine's decentralized-first and privacy-focused philosophy.

## Implementation Plan
1.  **Backend**: Develop a new Mediasoup-based worker in Rust (`crates/services/vortex`).
2.  **Frontend**: Create a new `ermine-vortex` package for the new web app using `mediasoup-client` and the Insertable Streams API.
3.  **Deployment**: Update `compose.yml` to replace the `livekit-server` with the new `vortex` service.

## Consequences
*   **Increased Complexity**: Implementing Mediasoup requires more "manual" WebRTC handling (signaling, ICE, DTLS) compared to LiveKit's high-level SDK.
*   **Improved Trust**: Users self-hosting Ermine can now guarantee that even their own server cannot spy on their media if E2EE is enabled.
