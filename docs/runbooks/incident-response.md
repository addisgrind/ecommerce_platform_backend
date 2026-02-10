# Incident Response Runbook

## Scope
Operational response for authentication, checkout, and search service incidents in production.

## Immediate Triage Checklist
1. Confirm active alerts in PagerDuty (`ecommerce-backend-primary`).
2. Capture current error rate, p95 latency, and saturation from Grafana dashboards.
3. Identify blast radius by endpoint and region.
4. Correlate request IDs with recent deployments and feature flags.

## Log Collection
- Application logs: `/var/log/ecommerce/application.log`
- Nginx logs: `/var/log/nginx/access.log`, `/var/log/nginx/error.log`
- Database logs: `/var/log/postgresql/postgresql.log`

## Containment Actions
- Shift 20% traffic to healthy region if error rate > 5% for 10 minutes.
- Disable non-critical asynchronous consumers to reduce DB contention.
- Roll back most recent release if issue started within deployment window.

## Escalation Matrix
- SEV-1: Incident Commander + Platform Director + Security within 10 minutes.
- SEV-2: Incident Commander + Service Owner within 15 minutes.
- SEV-3: Service Owner during business hours.

## Resolution and Follow-up
- Record timeline with UTC timestamps.
- Attach logs, metrics screenshots, and customer impact estimate.
- File post-incident review within 24 hours.
