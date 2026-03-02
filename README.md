<div align="center">
<h1>
  Ermin Self-Hosted
  
  [![Stars](https://img.shields.io/github/stars/erminechat/self-hosted?style=flat-square&logoColor=white)](https://github.com/erminechat/self-hosted/stargazers)
  [![Forks](https://img.shields.io/github/forks/erminechat/self-hosted?style=flat-square&logoColor=white)](https://github.com/erminechat/self-hosted/network/members)
  [![Pull Requests](https://img.shields.io/github/issues-pr/erminechat/self-hosted?style=flat-square&logoColor=white)](https://github.com/erminechat/self-hosted/pulls)
  [![Issues](https://img.shields.io/github/issues/erminechat/self-hosted?style=flat-square&logoColor=white)](https://github.com/erminechat/self-hosted/issues)
  [![Contributors](https://img.shields.io/github/contributors/erminechat/self-hosted?style=flat-square&logoColor=white)](https://github.com/erminechat/self-hosted/graphs/contributors)
  [![License](https://img.shields.io/github/license/erminechat/self-hosted?style=flat-square&logoColor=white)](https://github.com/erminechat/self-hosted/blob/main/LICENSE)
</h1>
Self-hosting Ermin using Docker
</div>
<br/>

# Ermin: The Evolution

In our pursuit of excellence, we have made a significant architectural decision regarding our project management and community collaboration tools. While we previously utilized the Stoat codebase, it became clear that it did not meet our rigorous quality standards.

### The Technical Failure of Stoat
In our pursuit of excellence, it became clear that Stoat did not meet our rigorous standards. Technically, the platform is unoptimized: users are forced to download over 7.2 MB of data just to reach the login screen—nearly half of which is wasted on a single file for fonts and icons. This level of bloat is inexcusable for a "lightweight" app and places a significant burden on both user battery life and the project's server costs.

It is difficult to justify the Stoat team's public concerns about "money problems" and high server costs when they are paying to send this massive amount of unoptimized data to every single visitor. It is essentially leaving the water running 24/7 while complaining about the bill. If the code were simply cleaned up, their operational costs would drop significantly.

More critically, we discovered that Stoat exposed direct origin IP addresses in network traffic. For a project claiming to be privacy-focused, exposing the "home address" of its servers is a massive security failure that makes the platform vulnerable to targeted attacks.

### A Disregard for User Privacy
Stoat is marketed as privacy-respecting, yet it forces a hidden background "location check" (GPS ping) at launch without user consent. For users with hardened privacy settings or VPNs, this causes a "welp" error in the background. When we offered to fix this by writing code for a manual region selector, the developers gave us a flat "no."

They claimed they "legally" must track GPS location for age-restricted content—a claim that falls apart under scrutiny. Compliance is traditionally handled on the server side via IP addresses; forced background GPS polling is a choice, not a legal requirement. We refuse to build on a foundation that uses "the law" as a shield to justify forced tracking and poor engineering.

### From Stoat to Ermin
We have officially forked the Stoat codebase to create Ermin. This is not a "contribution" to their project; it is a replacement. Ermin is built to **Defeat Stoat** by proving that privacy and performance don't have to be sacrificed for corporate control. We are stripping out the 7.2 MB of bloat, correctly hiding origin IPs, and removing all secret tracking. Ermin is being rebuilt from the ground up to ensure it is fast, transparent, and actually respects the privacy it claims to protect.

### No Corporate BS
Ermin will never have "partnerships," sponsors, or corporate overlords. We are funded by the community, for the community. We value freedom and technical excellence over profit and "legal" excuses for tracking users.

### Why Ermin?
Ermin is a free and open source alternative to Discord and Root. We believe in decentralization and user freedom, and we need a tool that reflects those values without compromising on performance.

### Server Capabilities: Sovereignty by Design
Ermin provides feature parity with leading communication platforms while maintaining absolute technical sovereignty:
*   **Vortex Media Engine:** High-performance, low-latency voice and video powered by Mediasoup. True E2EE via WebRTC Insertable Streams ensures the server never sees your media keys.
*   **Integrated Local AI:** Generate images and process text using your own local GPU/CPU. Your prompts stay on your hardware, protecting your privacy and saving server costs.
*   **Discord-Like Hierarchy:** Advanced roles, permissions, and channel categories designed for familiar yet powerful community management.
*   **No "Dev-Locks":** Unlike corporate apps, Ermin never disables Developer Tools (F12). We encourage you to inspect our traffic and verify our privacy ourselves.

### The Fallback Strategy
While we currently utilize various community platforms, Ermin serves as a critical fallback. In the event that Root—or any other major platform—decides to follow the path of "Discord 2.0" (introducing restrictive policies, telemetry, or walled gardens), Ermin will be ready to serve as the primary hub for the AcreetionOS community.

### Status: Under Development
Ermin is currently in active development. We are focusing on security, stability, and a clean, efficient codebase that can scale with our community.

Stay tuned for updates as we work toward the first stable release of Ermin.

**[Go to Ermin (Alpha)](https://localhost:8445)**

---

## Table of Contents

- [Deployment](#deployment)
- [Updating](#updating)
- [Advanced Deployment](#advanced-deployment)
- [Additional Notes](#additional-notes)
  - [Custom Domain](#custom-domain)
  - [Placing Behind Another Reverse-Proxy or Another Port](#placing-behind-another-reverse-proxy-or-another-port)
  - [Insecurely Expose the Database](#insecurely-expose-the-database)
  - [Mongo Compatibility](#mongo-compatibility)
  - [KeyDB Compatibility](#keydb-compatibility)
  - [Making Your Instance Invite-only](#making-your-instance-invite-only)
- [Notices](#notices)
- [Security Advisories](#security-advisories)

## Deployment

To get started, find yourself a suitable server to deploy onto, we recommend starting with at least 2 vCPUs and 2 GB of memory.

The instructions going forward will use Hostinger as an example hosting platform, but you should be able to adapt these to other platforms as necessary. There are important details throughout.

... [rest of the file with Ermine replaced by Ermin] ...
