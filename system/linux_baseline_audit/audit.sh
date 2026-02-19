#!/bin/bash

REPORT="reports/report.txt"

mkdir -p reports
echo "Linux Baseline Security Audit" > $REPORT
echo "Generated on: $(date)" >> $REPORT
echo "-----------------------------------" >> $REPORT

for script in checks/*.sh; do
    bash "$script" >> $REPORT
done

echo "Audit complete. Report saved to $REPORT"