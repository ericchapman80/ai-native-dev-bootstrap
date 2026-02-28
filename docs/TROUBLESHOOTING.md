# Troubleshooting

## Homebrew install issues
- Ensure Command Line Tools installed: `xcode-select -p`
- Try `brew doctor`

## pyenv build failures
- Ensure deps: `brew install openssl readline sqlite3 xz zlib tcl-tk`
- Re-run install: `pyenv install <version>`

## `docker compose` missing with Colima
Use `docker-compose` (hyphen). Compose v2 plugin may not be packaged in your brew environment.

## Ollama doesn't respond
- Check process: `pgrep -x ollama`
- Start server: `ollama serve`
- Stop: `pkill ollama`
