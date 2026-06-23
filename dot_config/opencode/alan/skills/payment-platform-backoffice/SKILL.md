---
name: payment-platform-backoffice
description: Domain knowledge for frontend/packages/payment-platform-backoffice and backend/components/payment_gateway. Use when working on PSP transaction lookup, PSP account balances, or any payment platform backoffice feature in Marmot. Covers routing, HTTP client conventions, auth, permissions, and known local dev pitfalls.
---

# Payment Platform Backoffice

Marmot backoffice module for the Payment Platform (Revolut, future PSPs).

## Key locations

| What | Where |
|---|---|
| Frontend module | `frontend/packages/payment-platform-backoffice/` |
| Backend component | `backend/components/payment_gateway/` |
| Transaction endpoint | `backend/components/payment_gateway/public/transactions/controllers.py` |
| Account balances endpoint | `backend/components/payment_gateway/internal/controllers/psp_account_balances.py` |
| Frontend screens | `frontend/packages/payment-platform-backoffice/internal/screens/` |
| Frontend API hooks | `frontend/packages/payment-platform-backoffice/internal/api/` |
| Permissions constant | `frontend/shared/common-marmot/consts.ts` (`PERMISSIONS.view_psp_transactions`, `PERMISSIONS.view_psp_account_balances`) |
| Marmot route registration | `frontend/apps/fr-marmot/Root.tsx` line ~1680 (`paymentPlatformBackofficeRoutes`) |
| URL on Marmot | `/marmot/global/payment-platform-backoffice/transaction` |

## HTTP client convention (CRITICAL)

**Two distinct SDK zones in this module:**

| Blueprint prefix | SDK to use | Example |
|---|---|---|
| `/api/payment_gateway/...` | `useCamelCaseApi` from `common-api-sdk` | `psp_account_balances` endpoint |
| `/admin_api/payment_gateway/...` | `useCamelCaseApi` from `intl-admin-api-sdk` | `transactions` endpoint |

`common-api-sdk` prepends `/api` to every call — it can only reach `/api/...` routes.
`intl-admin-api-sdk` prepends `${adminApiHost}/admin_api` — it reaches `/admin_api/...` routes.

**Never use `common-api-sdk` for `admin_api` endpoints** — you'll get 404s with the URL becoming `/api/admin_api/...`.

Both SDKs: `.get<T>(path, { params: {...} })` for query params.

The `transactions` endpoint URL from the frontend hook:
```ts
import { useCamelCaseApi } from "intl-admin-api-sdk";
// path: "/payment_gateway/transactions" (no /admin_api prefix — SDK adds it)
```

## Backend endpoint

```
GET /admin_api/payment_gateway/transactions?reference=X&workspace_key=Y
```

- `workspace_key` hardcoded to `eu_revolut_insurance` (Revolut-only for now)
- Returns 404 if no `PaymentRequest` found in DB OR if Revolut has no matching transaction
- Returns 400 for non-Revolut workspaces
- Permission: `view_psp_transactions` (role: `alan_pay_operator`)

`RevolutTransaction` pydantic model fields returned (camelCased on frontend):
`id`, `state`, `type`, `createdAt`, `updatedAt`, `reasonCode`, `reference`, `completedAt`

Note: `reference` on the Revolut object is the bank statement narrative — NOT Alan's internal payment reference. The internal reference is `request_id` on the pydantic model, but the response schema exposes it under the key `reference`.

## Permissions

Frontend pattern (same as `PspAccountBalancesPage`):
```ts
const { data: canView } = supportApi.useCurrentUserHasPermissionQuery(PERMISSIONS.view_psp_transactions);
if (!canView) return (
  <Alert color="orange" title="Access restricted">
    You need the <code>view_psp_transactions</code> permission to look up PSP transactions.
  </Alert>
);
```

To grant `alan_pay_operator` role on Kay Aurora (local dev):
```bash
PGPASSWORD="$(AWS_PROFILE=eng-pierre.romon aws rds generate-db-auth-token \
  --hostname kay-fr-api-shared.cluster-custom-cpgw0knzf0mv.eu-central-1.rds.amazonaws.com \
  --port 5432 --username engineer --region eu-central-1)" \
PGSSLROOTCERT=backend/.postgresql/eu-central-1-bundle.pem \
psql "host=kay-fr-api-shared.cluster-custom-cpgw0knzf0mv.eu-central-1.rds.amazonaws.com port=5432 dbname=fr_api user=engineer sslmode=verify-ca" \
  -c "UPDATE alan_employee SET roles = roles || '{alan_pay_operator}' WHERE alan_email = 'pierre.romon@alan.eu';"
```

On acceptance: `https://api-acceptance.alan.com/admin/alanemployee/` (Flask Admin).

## Local dev pitfalls

### 1. Kay DB vs Revolut credentials mismatch (EXPECTED)
Kay shared DB (`--use-kay=shared_on_aurora`) uses `alan-revolut-acceptance` Revolut credentials. Payment references in Kay came from the acceptance environment. Testing end-to-end locally always returns 404 from Revolut — the local sandbox has no matching transactions. **Test on acceptance instead.**

### 2. `flask shell --use-kay` connects to local DB, not Aurora
Running `flask shell` via `alan run` with `--use-kay=shared_on_aurora` actually connects to the local devbox DB. To query Kay Aurora directly, use psql with IAM auth (command above).

### 3. Devbox shim race condition (`date: illegal option -- d`)
`init-setup-binary-links.py` recreates `~/.alan/bin/devbox` (bypassing the shim at `~/.local/bin/devbox`) on every direnv reload, causing BSD `date` to be used instead of GNU `date`. Fix: `rm ~/.alan/bin/devbox`.

### 4. AWS credentials wiped by failed rotation
`./bin/rotate-aws-keys` or `alan aws rotate` can empty `~/.aws/credentials` if rotation fails midway. Fix: run `./bin/bootstrap-aws-granted` with Warp running — it hits `https://tools.alan.com/security/devbox/bootstrap` using the Warp session to re-seed credentials without a valid IAM key.

### 5. Flask server (Kay) vs local psql use different DBs
The Flask server with `--use-kay=shared_on_aurora` connects to Aurora (`kay-fr-api-shared.cluster-custom-cpgw0knzf0mv.eu-central-1.rds.amazonaws.com`, db `fr_api`). Plain `psql alan_backend` hits the local devbox DB — different data.

### 6. JWT tokens are valid across Flask server restarts
The dev Flask server uses a static `SECRET_KEY`. Browser tokens don't expire on restart. A persistent 403 is almost always a permissions issue, not a stale token.

### 7. Kay auth requires your personal AWS profile
`aws-ai` (the AI-agent AWS wrapper) does NOT have `rds-db:connect` permission. Use `AWS_PROFILE=eng-pierre.romon aws rds generate-db-auth-token` directly for Kay Aurora access.

## Acceptance environment

- Frontend: `https://acceptance.alan.com/marmot/global/payment-platform-backoffice/transaction`
- Backend admin API host: `https://marmot-api-acceptance.alan.com` (served by `apps.fr_api` — same as `api-acceptance.alan.com`)
- Flask Admin: `https://api-acceptance.alan.com/admin/alanemployee/`

## Query hook pattern

```ts
// usePspTransactionQuery.ts
import { useQuery } from "@tanstack/react-query";
import { useCamelCaseApi } from "intl-admin-api-sdk";

import type { PspTransaction } from "../types";

export const usePspTransactionQuery = (reference: string | null) => {
  const api = useCamelCaseApi();
  return useQuery<PspTransaction>({
    queryKey: ["psp-transaction", reference],
    queryFn: () =>
      api.get<PspTransaction>(
        `/payment_gateway/transactions?reference=${encodeURIComponent(reference!)}&workspace_key=eu_revolut_insurance`,
      ),
    enabled: reference !== null,
  });
};
```

## RevolutTransactionState color mapping (UI)

```ts
const STATE_COLOR: Record<string, string> = {
  completed: "green",
  pending: "yellow",
  created: "gray",
  declined: "red",
  failed: "red",
  reverted: "orange",
};
```

## tsconfig.json project references
When adding a new `workspace:*` dep to `package.json`, the `tsconfig.json` in the package must also include the corresponding project reference — CI check `workspaces-to-typescript-project-references` enforces symmetry. Run `alan run --scope frontend -- yarn` after editing `package.json` to auto-update `tsconfig.json`.
