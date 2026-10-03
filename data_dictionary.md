# Enterprise Master Data Dictionary & Data Governance Standards

## 1. Schema Specifications: `product_master`

| Column Name | Data Type | Constraint | MDM Rule / Description |
| :--- | :--- | :--- | :--- |
| `product_sku` | VARCHAR(30) | PRIMARY KEY | Unique company-wide SKU code. Formatted uppercase (`SKU-DEPT-ID`). |
| `product_name` | VARCHAR(150) | NOT NULL | Standardized display title. Cleaned using Title Casing. |
| `category_id` | VARCHAR(20) | FOREIGN KEY | References `product_category_master.category_id`. |
| `vendor_id` | VARCHAR(20) | FOREIGN KEY | References approved registered suppliers in `vendor_master`. |
| `unit_cost_price` | NUMERIC(10,2) | >= 0.00 | Base purchase cost negotiated with the supplier. |
| `unit_selling_price`| NUMERIC(10,2) | >= Cost Price | Market retail price. Enforced via `chk_pricing_margin`. |
| `record_status` | VARCHAR(20) | CHECK IN | Status indicator: `VALIDATED`, `FLAGGED`, or `STAGED`. |
| `last_updated` | TIMESTAMP | DEFAULT NOW | Audit timestamp tracking update latency. |
