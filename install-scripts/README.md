# Install scripts

Scripts and Docker Compose files for installing and running the Dashboard Deelmobiliteit stack.

Full installation instructions (DNS, databases, API gateway, frontend, etc.) are in the docs: [How to install?](../src/content/docs/start/how_to_install.md).

## Run all services

After a successful install, start (or restart) the full stack from this directory:

```bash
./run.sh
```

This brings up all core services in the background (`docker compose ... up -d`), using:

| Compose file | What it runs |
| --- | --- |
| `docker-compose.db.yaml` | PostgreSQL (TimescaleDB), Redis, Tile38 |
| `docker-compose.api-services.yaml` | dashboard-api, admin-api, od-api, policy-api, … |
| `docker-compose.data-services.yaml` | data-importer, zone-stats-aggregator, microhubs-controller |
| `docker-compose.gateway.yaml` | FusionAuth, Kong |

Docker Compose reads environment variables from `.env` in this directory (created during install).

### Check status

```bash
docker ps
```

### Stop services

```bash
docker compose -f docker-compose.db.yaml \
  -f docker-compose.api-services.yaml \
  -f docker-compose.data-services.yaml \
  -f docker-compose.gateway.yaml \
  down
```

### Restart a single container

```bash
docker ps                          # find the container name
docker stop <container-name>
docker start <container-name>
```

A full machine reboot also restarts containers that have `restart: always`.

### Cron jobs (aggregated data)

Scheduled aggregators are installed separately (`install_cronjobs.sh`). To run them once manually:

```bash
./run_all_cronjobs.sh
```

## Develop against local repositories

By default, most services run published images from GHCR. To use your own checkouts and see local code changes, either build a `:local` image or mount the repo into the container (live reload).

### Expected directory layout

Compose paths assume sibling repos next to `dashboarddeelmobiliteit-docs`:

```text
dev/
  dashboarddeelmobiliteit-docs/
    install-scripts/          ← you are here
  dashboarddeelmobiliteit-api-admin/
  dashboard-api/              ← used for dashboard-api:local
  dashboarddeelmobiliteit-app/
  …
```

Clone (or symlink) the services you want to develop into that parent directory.

### Admin API (live reload)

`docker-compose.local.yaml` builds `admin-api` from `../../dashboarddeelmobiliteit-api-admin`, mounts the source, and runs uvicorn with `--reload`. File changes in that repo are picked up without rebuilding.

From this directory:

```bash
docker compose -f docker-compose.db.yaml \
  -f docker-compose.api-services.yaml \
  -f docker-compose.data-services.yaml \
  -f docker-compose.gateway.yaml \
  -f docker-compose.local.yaml \
  up -d --build
```

Or recreate only that service after changing the override:

```bash
docker compose -f docker-compose.db.yaml \
  -f docker-compose.api-services.yaml \
  -f docker-compose.data-services.yaml \
  -f docker-compose.gateway.yaml \
  -f docker-compose.local.yaml \
  up -d --build admin-api
```

### Dashboard API (`:local` image)

`docker-compose.api-services.yaml` already uses `dashboarddeelmobiliteit-api:local`. Build it from your local API repo, then restart the container:

```bash
cd ../../dashboard-api   # or wherever your clone lives
docker build -t dashboarddeelmobiliteit-api:local .
cd ../dashboarddeelmobiliteit-docs/install-scripts
docker compose -f docker-compose.db.yaml \
  -f docker-compose.api-services.yaml \
  -f docker-compose.data-services.yaml \
  -f docker-compose.gateway.yaml \
  up -d --force-recreate dashboard-api
```

Rebuild and recreate again whenever you want your latest commits in the running container (no volume mount / reload for this service by default).

### Other backend services

For services that still point at GHCR (e.g. `od-api`, `policy-api`, data services), add an override in `docker-compose.local.yaml` the same way as `admin-api`: set `image: …:local`, `build.context` to your local path, and optionally a bind mount + reload command if the app supports it. Then include `-f docker-compose.local.yaml` when you `up`.

Without a bind mount: `docker build -t <image>:local .` in the repo, retag/override the compose `image`, and `up -d --force-recreate <service>`.

### Frontend

The frontend is not a Docker Compose service here. After editing your local app (install puts it under `dashboarddeelmobiliteit-app-main/`, or use your own clone), rebuild and deploy:

```bash
./deploy_new_frontend.sh
```

That script builds from `dashboarddeelmobiliteit-app-main/` and copies the result to `/srv/www/frontend/`. Point the script (or symlink that directory) at your own checkout if you develop outside the unzipped install folder.
