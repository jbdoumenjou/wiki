
## casting different types

```postgresql
SELECT NOW()::DATE, CAST(NOW() AS DATE), CAST(NOW() AS TIME);
```

## Date intervals

```postgresql
select now(), now() - interval '2 days', (now() - interval '2 days')::DATE, (now() - interval '2 days')::DATE;
```

# Row-level locking in PostgreSQL: do you need `FOR UPDATE`?

## TL;DR
An ordinary `UPDATE` **already** takes a row-level lock (`FOR UPDATE`) on every row it touches and holds the lock until the transaction ends.  
Use a separate `SELECT … FOR UPDATE` only when you must **look at the row first, then decide what to do**, while preventing concurrent changes.

---

## Simple update (no extra lock needed)

```sql
BEGIN;
UPDATE accounts
SET    balance = balance - 100
WHERE  id = 42;
COMMIT;
```

## Read-modify-write pattern (use explicit lock)

```sql
BEGIN;

-- 1️⃣ Lock the row so nobody else can change or delete it
SELECT balance
FROM   accounts
WHERE  id = 42
FOR UPDATE;

-- 2️⃣ Run business logic in the application…

-- 3️⃣ Apply the update only if the logic says so
UPDATE accounts
SET    balance = balance - 100
WHERE  id = 42;

COMMIT;
```

### Common scenarios for SELECT … FOR UPDATE

| Use case                                                         | Why it helps                                                                              |
|------------------------------------------------------------------|-------------------------------------------------------------------------------------------|
| Check-then-update rules (e.g. “only deduct if balance ≥ amount”) | Guarantees no conflicting update sneaks in between your check and update.                 |
| Lock ordering across tables                                      | Grab locks in a consistent order to avoid deadlocks.                                      |
| Queue/worker tables                                              | Use FOR UPDATE SKIP LOCKED so workers safely pick the next job row.                       |
| Long processing before the update                                | Lock rows up front, run computations, then update—ensuring data hasn’t changed meanwhile. |

## 3. Variants you might need

| Clause                    | Locks                                                   | Typical use                                 |
|---------------------------|---------------------------------------------------------|---------------------------------------------|
| FOR UPDATE                | Prevents other updates or deletes                       | Classic read-modify-write                   |
| FOR NO KEY UPDATE         | Lighter: blocks updates to row data, allows key updates | Foreign-key maintenance                     |
| FOR SHARE / FOR KEY SHARE | Prevents deletes, allows concurrent updates             | Keeping referential integrity while reading |
| SKIP LOCKED               | Skip already-locked rows                                | Job queues / parallel workers               |
| NOWAIT                    | Error instead of waiting for a lock                     | Low-latency needs                           |

## Pros & Cons of locking early


| Pros                                              | Cons                                                                     |
|---------------------------------------------------|--------------------------------------------------------------------------|
| Prevents lost updates & race conditions cleanly.  | Locks persist until transaction end; long transactions can block others. |
| Deterministic lock ordering (avoid deadlocks).    | Extra network round-trip (select + update).                              |
| Fine-grained control (NOWAIT, SKIP LOCKED, etc.). | Easy to forget to COMMIT, causing contention.                            |

## Best-practice checklist

- Just changing rows? → plain UPDATE in a transaction is enough.
- Need to read-decide-write? → wrap in a transaction and use SELECT … FOR UPDATE (or a variant).
- Keep transactions short to minimize blocking.
- Consider variants (FOR NO KEY UPDATE, SKIP LOCKED, NOWAIT) for performance or concurrency tweaks.

## References

- PostgreSQL docs – Explicit locking: https://www.postgresql.org/docs/current/explicit-locking.html
- PostgreSQL docs – SELECT … FOR UPDATE and friends: https://www.postgresql.org/docs/current/sql-select.html#SQL-FOR-UPDATE-SHARE

# PostgreSQL Stored Procedures – Cheat-Sheet

## What **is** a stored procedure?

* Introduced in PostgreSQL 11, created with **`CREATE PROCEDURE`** and invoked by **`CALL …`**
* Key differences from functions:
    * **No `RETURNS` clause** – return data with `OUT` / `INOUT` parameters or cursors instead.
    * **Full transaction control**: `COMMIT`, `ROLLBACK`, savepoints are allowed inside the body (functions cannot).
    * Can’t be used inside a `SELECT`, `WHERE`, etc.—only executed via `CALL`.

---

## Capabilities

| Feature                  | Notes                                                               |
|--------------------------|---------------------------------------------------------------------|
| **Transaction control**  | Split long jobs into smaller committed chunks, release locks early. |
| **Multiple result sets** | Return via `OUT` parameters or refcursors.                          |
| **Language options**     | `PL/pgSQL` default; also `PL/Python`, `PL/Perl`, `PL/v8`, etc.      |
| **Security**             | `SECURITY DEFINER` lets you expose a safe API while hiding tables.  |

### Minimal skeleton

```sql
CREATE PROCEDURE pay_salary(emp_id int, amount numeric)
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE employees
  SET    balance = balance + amount
  WHERE  id = emp_id;

  COMMIT;      -- optional mid-transaction commit
EXCEPTION
  WHEN others THEN
    ROLLBACK;
    RAISE;
END;
$$;
```

## When to use procedures (👍)

| Scenario                                                  | Why a procedure fits                                                       |
|-----------------------------------------------------------|----------------------------------------------------------------------------|
| Batch / ETL jobs that process millions of rows            | Periodic COMMIT avoids giant transactions.                                 |
| Maintenance utilities (partition rotation, index rebuild) | Need to drop/recreate objects with transaction breaks.                     |
| Idempotent deployment scripts                             | One CALL run by CI pipeline keeps logic close to data.                     |
| Drivers expecting SQL-standard CALL                       | JDBC/ODBC [CallableStatement](https://jdbc.postgresql.org/documentation/callproc/) works out-of-the-box.(jdbc.postgresql.org) |

## What to avoid (👎)

- Embedding portable business logic—procedures are Postgres-specific.
- Expecting to call them in a query context—use functions instead.
- Open-ended transactions inside procedures—block other sessions.
- Excessive dynamic SQL—hard to test and may invite SQL-injection.
- Giant monolithic scripts—harder to debug, upgrade, and review.

## Good practices

- Version-control procedure source in migrations.
- Keep each procedure cohesive; delegate pure calculations to functions.
- Add COMMENT ON PROCEDURE … for docs and auto-generated catalogs.
- Declare parameter modes (IN, OUT, INOUT) explicitly.
- Use EXCEPTION … WHEN blocks to log and re-raise errors.
- With SECURITY DEFINER, always SET search_path inside the body.
- Benchmark—network round-trip savings don’t override MVCC costs.

## Pros & Cons at a glance

| ✅ Pros                                       | ❌ Cons                                         |
|----------------------------------------------|------------------------------------------------|
| Mid-procedure COMMIT / ROLLBACK.             | Cannot be embedded in SQL queries.             |
| Fewer client round-trips, faster batch work. | Harder to debug; limited IDE tooling.          |
| Central, reusable DB-side API (hide tables). | Ties logic to PostgreSQL dialect/version.      |
| Fine-grained privilege control (EXECUTE).    | Deployment coordination & rollback complexity. |

| Need                                | Choose                                                |
|-------------------------------------|-------------------------------------------------------|
| Transaction control inside routine? | Procedure                                             |
| Return value/table to a query?      | Function                                              |
| Both?                               | Orchestrate in a procedure, compute in pure functions |

## References

- PostgreSQL official docs – [CREATE PROCEDURE](https://www.postgresql.org/docs/current/sql-createprocedure.html).
- Doc – [Differences between functions & procedures](https://www.postgresql.org/docs/current/xproc.html).
- Doc – [Transaction control inside procedures](https://www.postgresql.org/docs/current/plpgsql-transactions.html).
    