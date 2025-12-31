# Core 🏦

Core is a robust, high-performance banking ledger service written in **Go**. It simulates a backend banking system with support for creating accounts, tracking balance changes, and executing money transfers securely.

The project emphasizes **Data Consistency**, **ACID Transactions**, and **Concurrency Handling** (Deadlock prevention) using pure SQL and Go standard patterns.

![Go Version](https://img.shields.io/badge/Go-1.23+-00ADD8?style=flat&logo=go)
![Database](https://img.shields.io/badge/PostgreSQL-16-336791?style=flat&logo=postgresql)
![Docker](https://img.shields.io/badge/Docker-Enabled-2496ED?style=flat&logo=docker)
![CI/CD](https://img.shields.io/badge/Build-Passing-brightgreen)

---

## 🏗 Architecture & Features

This project follows a **Clean Architecture** approach, separating concerns between the API layer, Logic/Store layer, and Database interactions.

* **RESTful API:** Built with [Gin](https://github.com/gin-gonic/gin) for high performance and minimal boilerplate.
* **Database:** PostgreSQL as the relational database engine.
* **Type-Safe SQL:** Using [sqlc](https://github.com/sqlc-dev/sqlc) to generate Go code from SQL queries, ensuring type safety and catching query errors at compile time.
* **ACID Transactions:** Money transfers are executed within database transactions (`BEGIN`, `ROLLBACK`, `COMMIT`) to ensure data integrity.
* **Deadlock Prevention:** Implemented consistent locking ordering (updating accounts by ID order) to handle high-concurrency transfer requests without database locks.
* **Dockerized:** Fully containerized environment for both the application and the database.
* **Testing:** Comprehensive unit tests covering CRUD operations and concurrent transaction scenarios (TDD approach).

### Database Schema

```mermaid
erDiagram
    ACCOUNTS {
        bigserial id PK
        varchar owner
        bigint balance
        varchar currency
        timestamptz created_at
    }
    ENTRIES {
        bigserial id PK
        bigint account_id FK
        bigint amount
        timestamptz created_at
    }
    TRANSFERS {
        bigserial id PK
        bigint from_account_id FK
        bigint to_account_id FK
        bigint amount
        timestamptz created_at
    }
    ACCOUNTS ||--o{ ENTRIES : "has"
    ACCOUNTS ||--o{ TRANSFERS : "sends"
    ACCOUNTS ||--o{ TRANSFERS : "receives"