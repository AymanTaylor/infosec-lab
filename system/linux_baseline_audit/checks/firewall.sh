echo ""
echo "=== Firewall Status ==="

if command -v ufw >/dev/null; then
    ufw status
elif command -v firewall-cmd >/dev/null; then
    firewall-cmd --state
else
    echo "No firewall detected ❌"
fi