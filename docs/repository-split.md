# Repository Split

This project uses a public/private split so reusable bootstrap work can help the
industry without publishing one operator's local network, host inventory, or
agent trust model.

## Public repository

The public GitHub repository contains reusable bootstrap code, templates,
non-secret policy tests, and documentation that uses example values. It should
never contain real hostnames, private IP assignments, usernames, kubeconfigs,
certificates, bearer tokens, password-manager exports, or operational reports
from a live home or company network.

Use documentation-safe placeholders such as:

- `example.internal` for private DNS examples.
- `192.0.2.0/24`, `198.51.100.0/24`, and `203.0.113.0/24` for example IPs.
- `workstation.example`, `cluster-node.example`, and `operator` for host/user
  examples.

## Private platform repository

A self-hosted private Git repository should hold the site implementation:

- Real machine and service names.
- Real RFC1918 addresses and DNS records.
- GitOps application definitions.
- Internal CA and trust-distribution runbooks.
- Operational reports, acceptance evidence, and rollback notes.
- Agent-specific permissions, source policies, and local runbooks.

The private repository can consume this public repo as upstream guidance while
keeping local truth close to the machines and people who operate it.

## Dedicated agent repository

Dedicated local agents deserve their own repository or top-level project because
their context evolves differently from infrastructure bootstrap code. Keep agent
instructions, tool boundaries, runbooks, memory seeds, and permission reviews in
the private agent repository. Publish only generic patterns back here.

## Release Checklist

Before pushing to the public repository:

1. Run the privacy scan: `bash tests/public-privacy.sh`.
2. Run normal verification: `make dry` and `make verify`.
3. Confirm `git log origin/main..HEAD` contains no private operational history.
4. Confirm examples use documentation IP ranges and placeholder domains.
5. Push public work to GitHub.
6. Push local implementation work to the private Git server.
