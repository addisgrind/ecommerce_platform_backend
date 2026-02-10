# TC_CHECKOUT_FLOW - Checkout and Payment Authorization

## Objective
Verify order placement from cart through payment authorization and order confirmation.

## Preconditions
- User logged in as `qa.buyer@enterprise-retail.com`
- Cart has 3 items totaling USD 249.97
- Shipping address and billing profile saved
- Payment gateway test merchant key active

## Test Data
- User ID: `usr_104882`
- Cart ID: `crt_441992`
- Order ID pattern: `ord_*`

## Steps
1. Open cart and click **Proceed to Checkout**.
2. Select shipping method `STANDARD_3_DAY`.
3. Confirm payment method `VISA **** 4242` and submit order.
4. Refresh order detail page within 5 seconds.

## Expected Results
- Step 1: Checkout page loads and tax is calculated.
- Step 2: Shipping fee reflected in order summary.
- Step 3: `POST /api/v1/checkout` returns HTTP `201` with generated order ID.
- Step 4: Order status transitions from `PROCESSING_PAYMENT` to `CONFIRMED` within SLA (<= 4 seconds).

## Post-Conditions
- Payment transaction recorded with provider reference.
- Inventory reservation released only on payment failure.
