# Local AI Gateway Template

This template documents a conservative pattern for exposing a loopback-only
Ollama runtime to one trusted internal consumer without publishing a raw Ollama
listener to the LAN.

The pattern is intentionally boring:

- Keep Ollama bound to `127.0.0.1:11434`.
- Put an authenticated HTTPS gateway on a dedicated address and port.
- Allow only the API routes a consumer actually needs.
- Require bearer authentication over TLS.
- Verify the real source address before creating firewall rules.
- Log metadata only; never log prompts, responses, embeddings, headers, or
  bearer values.
- Give each consumer its own credential and review route/source policy
  separately.

The example files are:

- [ollama-gateway.example.json](../config/ai/ollama-gateway.example.json)
- [Caddyfile.example](../config/ai/Caddyfile.example)

## Public Safety Boundary

This repository deliberately contains templates, not live deployment state.
Real DNS names, private addresses, certificate paths, and tokens belong in a
private site repository. The public examples use documentation-only addresses
from `192.0.2.0/24`.

## Acceptance Checks

Before considering a live deployment ready, collect evidence that:

- Unauthenticated requests return `401`.
- Authenticated requests from the wrong source return `403`.
- Only the intended route set reaches the upstream runtime.
- Management and model mutation routes stay blocked unless explicitly reviewed.
- Gateway logs contain status, route class, duration, and source metadata only.
- A consumer can complete a bounded inference request through the gateway.
- Stopping the gateway leaves the loopback runtime private.
