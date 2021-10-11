# 🌲 Forest IaC

This repository contains machine-readable specifications for the auxillilary services that [Forest](https://github.com/ChainSafe/forest) project running smoothly. The services include daily uploads of network snapshots, and automated testing of Forest's capabilities.

# 🔧 Desired properties

 - Require minimal setup. Ideally any server with [docker](https://www.docker.com/) installed should be sufficient.
 - Automatic and error-proof re-deployment when new infrastructure code is available.
 - Runs without human intervention. The services should stay running unless explicitly stopped.
 - Fault tolerant.
 - Use a consistent strategy for uploading/storing logs and reporting errors.
 - Is idempotent. Multiple instances can run without adver