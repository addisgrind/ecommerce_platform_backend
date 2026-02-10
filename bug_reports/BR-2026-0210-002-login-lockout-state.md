# BR-2026-0210-002 - Login Lockout Persists After Lockout TTL Expiration

## Reported By
QA Regression Suite

## Environment
- Cluster: `prod-us-east-2`
- Service: `auth-service`
- API endpoint: `POST /api/v1/auth/login`

## Severity
SEV-3

## Steps to Reproduce
1. Trigger account lockout with 5 invalid password attempts.
2. Wait for configured lockout TTL (`15 minutes`).
3. Retry login using correct password.

## Expected Result
User can authenticate successfully after TTL expires.

## Actual Result
User continues receiving HTTP `423 Locked` until cache eviction or service restart.

## Evidence
- User ID: `usr_998112`
- IP: `198.51.100.17`
- Trace ID: `ee14f78acdca43bc`
- Observed in logs: lockout key exists with negative TTL and stale value.

## Impact
Legitimate users are blocked after lockout window, increasing support ticket volume.

## Mitigation
Manual cache delete for affected user lock keys in Redis.

## Current Status
Fix drafted to normalize TTL refresh logic in lockout state manager.
