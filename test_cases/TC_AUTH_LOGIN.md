# TC_AUTH_LOGIN - User Login Validation

## Objective
Validate successful and failed login behavior for customer accounts.

## Preconditions
- Test account exists: `qa.user1@enterprise-retail.com`
- Account password: `S3cureP@ss!`
- Account status: active, email verified
- API gateway and auth-service are healthy

## Test Data
- Valid user ID: `usr_998112`
- Client IP: `198.51.100.17`

## Steps
1. Navigate to `/login` and submit valid email/password.
2. Confirm redirection to `/account/overview`.
3. Logout and submit same email with invalid password 5 times.
4. Attempt login again with valid password immediately after lockout threshold.

## Expected Results
- Step 1: HTTP `200` on `/api/v1/auth/login` and access token issued.
- Step 2: Session cookie set with `HttpOnly` and `Secure` flags.
- Step 3: HTTP `401` for first 4 attempts and HTTP `423` on 5th attempt (account locked).
- Step 4: HTTP `423` until lockout period expires; login denied.

## Post-Conditions
- Audit event recorded for each failed attempt.
- User account lockout entry written to Redis with TTL.
