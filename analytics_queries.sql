-- =========================================================================
-- Business Analytics & KPI Extraction Queries (PostgreSQL / MySQL)
-- =========================================================================

-- 1. Vendor Reliability & Gross Margin Contribution
WITH VendorMetrics AS (
    SELECT 
        v.vendor_id,
        v.vendor_name,
        COUNT(p.product_sku) AS active_skus,
        AVG(p.unit_selling_price - p.unit_cost_price) AS avg_unit_margin,
        SUM(p.unit_selling_price) AS total_catalog_value
    FROM vendor_master v
    JOIN product_master p ON v.vendor_id = p.vendor_id
    WHERE p.record_status = 'VALIDATED'
    GROUP BY v.vendor_id, v.vendor_name
)
SELECT 
    vendor_id,
    vendor_name,
    active_skus,
    ROUND(avg_unit_margin, 2) AS avg_unit_margin,
    total_catalog_value,
    DENSE_RANK() OVER (ORDER BY total_catalog_value DESC) AS vendor_rank
FROM VendorMetrics;

-- 2. Category Margin Distribution & Audit Discrepancy Ratio
SELECT 
    c.category_name,
    COUNT(p.product_sku) AS total_products,
    COUNT(CASE WHEN p.record_status = 'FLAGGED' THEN 1 END) AS flagged_records,
    ROUND(
        (COUNT(CASE WHEN p.record_status = 'FLAGGED' THEN 1 END)::NUMERIC / NULLIF(COUNT(p.product_sku), 0)) * 100, 
        2
    ) AS error_rate_percentage,
    ROUND(AVG(p.unit_selling_price), 2) AS avg_category_price
FROM product_category_master c
LEFT JOIN product_master p ON c.category_id = p.category_id
GROUP BY c.category_name;
