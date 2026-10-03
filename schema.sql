-- =========================================================================
-- Enterprise Retail Master Data Management (MDM) & Analytics Schema
-- Designed for 3NF Normalization, Referential Integrity & Audit Governance
-- =========================================================================

CREATE TABLE IF NOT EXISTS vendor_master (
    vendor_id VARCHAR(20) PRIMARY KEY,
    vendor_name VARCHAR(100) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    tax_identifier VARCHAR(50) UNIQUE NOT NULL,
    country VARCHAR(50) DEFAULT 'India',
    status VARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'INACTIVE', 'SUSPENDED')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS product_category_master (
    category_id VARCHAR(20) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL UNIQUE,
    department VARCHAR(50) NOT NULL,
    tax_rate NUMERIC(4, 2) DEFAULT 18.00 CHECK (tax_rate >= 0)
);

CREATE TABLE IF NOT EXISTS product_master (
    product_sku VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id VARCHAR(20) NOT NULL REFERENCES product_category_master(category_id),
    vendor_id VARCHAR(20) NOT NULL REFERENCES vendor_master(vendor_id),
    unit_cost_price NUMERIC(10, 2) NOT NULL CHECK (unit_cost_price >= 0),
    unit_selling_price NUMERIC(10, 2) NOT NULL,
    currency VARCHAR(5) DEFAULT 'INR',
    is_active BOOLEAN DEFAULT TRUE,
    record_status VARCHAR(20) DEFAULT 'VALIDATED' CHECK (record_status IN ('VALIDATED', 'FLAGGED', 'STAGED')),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_pricing_margin CHECK (unit_selling_price >= unit_cost_price)
);

CREATE TABLE IF NOT EXISTS master_audit_log (
    log_id SERIAL PRIMARY KEY,
    entity_name VARCHAR(50) NOT NULL,
    record_key VARCHAR(50) NOT NULL,
    action_type VARCHAR(20) NOT NULL,
    discrepancy_note TEXT,
    logged_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_prod_vendor ON product_master(vendor_id);
CREATE INDEX IF NOT EXISTS idx_prod_cat ON product_master(category_id);
CREATE INDEX IF NOT EXISTS idx_prod_status ON product_master(record_status);
