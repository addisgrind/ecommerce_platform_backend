# BR-2026-0210-001 - Checkout Request Returns 502 During Payment Authorization

## Reported By
On-call SRE Team

## Environment
- Cluster: `prod-eu-west-1`
- Service: `order-service` + `payment-service`
- API endpoint: `POST /api/v1/checkout`

## Severity
SEV-2

## Steps to Reproduce
1. Login as `qa.buyer@enterprise-retail.com`.
2. Add products totaling > USD 200 to cart.
3. Submit checkout with saved card `VISA **** 4242`.
4. Observe API response for checkout endpoint.

## Expected Result
Checkout request returns HTTP `201` and order enters `CONFIRMED` state.

## Actual Result
Checkout request intermittently returns HTTP `502` after ~5 seconds.

## Evidence
- Request ID: `7b2f8f66d9fa4f4a`
- User ID: `usr_104882`
- Client IP: `203.0.113.42`
- Error snippet: `upstream timed out while reading response header from upstream`

## Impact
~8.3% of checkout attempts failed between 07:15 and 07:35 UTC; estimated revenue impact USD 18,400.

## Mitigation
- Increased payment gateway timeout from 5s to 8s on one canary instance.
- Activated circuit breaker fallback to retry authorization once.

## Current Status
Investigating root cause in payment gateway client and DB deadlock side effects.
