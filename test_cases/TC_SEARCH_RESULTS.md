# TC_SEARCH_RESULTS - Product Search Relevance and Performance

## Objective
Validate search endpoint relevance, sorting behavior, and response latency.

## Preconditions
- Search index updated with latest product catalog
- User session active
- Catalog service and search-service healthy

## Test Data
- User ID: `usr_452701`
- Query: `wireless mechanical keyboard`
- Client IP: `192.0.2.81`

## Steps
1. Execute search from homepage search bar with query above.
2. Apply filter `In Stock` and sort by `Best Match`.
3. Navigate to page 2 and page 3 of results.
4. Repeat query with typo: `wirless mech keyboard`.

## Expected Results
- Step 1: Response code HTTP `200` and at least 50 matching products.
- Step 2: Out-of-stock items excluded; sponsored results clearly tagged.
- Step 3: Pagination metadata contains accurate `totalHits`, `page`, and `pageSize`.
- Step 4: Did-you-mean suggestion is returned and relevance remains acceptable.
- P95 response time for search API stays below `600ms`.

## Post-Conditions
- Query analytics event published to `search.analytics.events` topic.
