# FAQ

## Why phases?
So you can safely run only what you want (and rerun phases as needed).

## Why Colima instead of Docker Desktop?
Colima is lightweight and works well on Apple Silicon. Compose is handled via `docker-compose` (hyphen) by default.

## How do I stop resource usage?
- Stop containers: `colima stop`
- Stop Ollama: `pkill ollama`

## Can this bypass corporate MDM/Jamf?
No. This project does not bypass management/security controls.
