import csv
from datetime import datetime

class MasterDataCleaner:
    def __init__(self, filepath: str):
        self.filepath = filepath
        self.rows = []
        self.audit_log = []
        self.cleaned_rows = []

    def run_pipeline(self):
        # 'utf-8-sig' automatically handles Windows PowerShell UTF-8 BOM
        with open(self.filepath, mode='r', encoding='utf-8-sig') as f:
            reader = csv.DictReader(f)
            self.rows = list(reader)

        print(f"[*] Ingested {len(self.rows)} raw records for MDM audit.")
        seen_skus = set()

        for row in self.rows:
            sku = row['product_sku'].strip().upper()
            name = row['product_name'].strip().title()
            cat = row['category_id'].strip().upper()
            vend = row['vendor_id'].strip().upper()

            # Deduplication
            if sku in seen_skus:
                self.audit_log.append({
                    'entity': 'product_master',
                    'key': sku,
                    'issue': 'DUPLICATE_SKU_DROPPED',
                    'timestamp': datetime.utcnow().isoformat()
                })
                continue
            seen_skus.add(sku)

            # Price conversions & Imputation
            try:
                sell_price = float(row['unit_selling_price'])
            except (ValueError, TypeError):
                sell_price = 0.0

            try:
                cost_price = float(row['unit_cost_price'])
            except (ValueError, TypeError):
                cost_price = round(sell_price * 0.70, 2)

            margin_amount = round(sell_price - cost_price, 2)
            margin_pct = round((margin_amount / sell_price * 100), 2) if sell_price > 0 else 0.0

            # Negative Margin Anomaly Check
            if sell_price < cost_price:
                status = 'FLAGGED'
                self.audit_log.append({
                    'entity': 'product_master',
                    'key': sku,
                    'issue': f"NEGATIVE_MARGIN: Cost={cost_price} > Sell={sell_price}",
                    'timestamp': datetime.utcnow().isoformat()
                })
            else:
                status = 'VALIDATED'

            self.cleaned_rows.append({
                'product_sku': sku,
                'product_name': name,
                'category_id': cat,
                'vendor_id': vend,
                'unit_cost_price': cost_price,
                'unit_selling_price': sell_price,
                'margin_amount': margin_amount,
                'margin_percentage': margin_pct,
                'record_status': status,
                'last_updated': datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S")
            })

        return self

    def export_results(self, output_csv="golden_product_master.csv", audit_csv="data_discrepancy_audit.csv"):
        if self.cleaned_rows:
            with open(output_csv, mode='w', newline='', encoding='utf-8') as f:
                writer = csv.DictWriter(f, fieldnames=list(self.cleaned_rows[0].keys()))
                writer.writeheader()
                writer.writerows(self.cleaned_rows)
            print(f"[+] Exported {len(self.cleaned_rows)} golden master records to {output_csv}")

        if self.audit_log:
            with open(audit_csv, mode='w', newline='', encoding='utf-8') as f:
                writer = csv.DictWriter(f, fieldnames=['entity', 'key', 'issue', 'timestamp'])
                writer.writeheader()
                writer.writerows(self.audit_log)
            print(f"[+] Discrepancies logged to {audit_csv}")

if __name__ == "__main__":
    cleaner = MasterDataCleaner("raw_vendor_catalog.csv")
    cleaner.run_pipeline().export_results()
