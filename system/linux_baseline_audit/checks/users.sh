echo ""
echo "=== User Audit ==="

echo "Accounts with UID 0:"
awk -F: '($3 == 0) {print $1}' /etc/passwd

echo ""
echo "Users with empty passwords:"
awk -F: '($2 == "") {print $1}' /etc/shadow 2>/dev/null

echo ""
echo "Users with interactive shells:"
grep -E "/bin/bash|/bin/sh" /etc/passwd | cut -d: -f1