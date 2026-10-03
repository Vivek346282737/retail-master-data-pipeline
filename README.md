# Enterprise Retail Master Data Management (MDM) & Governance Analytics Pipeline

[![Architecture: 3NF](https://img.shields.io/badge/Architecture-3NF%20Relational-blue.svg)](#relational-data-architecture)
[![Data Quality: 83.3%](https://img.shields.io/badge/Data%20Quality%20Index-83.3%25-brightgreen.svg)](#key-performance-indicators)
[![Python: Standard Library](https://img.shields.io/badge/Python-3.11%20ETL-yellow.svg)](#automated-cleansing-engine)
[![UI: Telemetry Portal](https://img.shields.io/badge/UI-Interactive%20Telemetry-cyan.svg)](#interactive-bi-telemetry-portal)

A production-grade Master Data Management (MDM) and governance analytics pipeline for multi-vendor retail catalog ingestion. Built to eliminate revenue leakage caused by duplicate SKU collisions, unstandardized catalog attributes, and pricing inversions (Cost Price > Selling Price).

---

## Executive Overview & Business Case

Multi-vendor supply chain feeds frequently introduce dirty and non-standardized records, leading to margin erosion and inventory synchronization errors. This project establishes an automated backend data cleansing engine, a 3NF relational data model, and an interactive executive telemetry portal to enforce governance policies before records reach production databases.

### Key Performance Indicators (KPIs)
* **Catalog GMV Value:** ₹29,499.00 across validated inventory assets.
* **Net Gross Margin:** ₹6,453.50 (22.88% aggregate catalog margin).
* **Data Quality Index (DQI):** 83.3% compliance (5 of 6 golden records approved).
* **Financial Risk Blocked:** ₹400.50 per-unit recurring loss halted on negative margin violations.
* **Deduplication Rate:** 14.3% redundant SKU collisions eliminated.

---

## Pipeline Architecture
