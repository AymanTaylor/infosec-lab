echo ""
echo "=== SSH Configuration ==="

if grep -q "^PermitRootLogin no" /etc/ssh/sshd_config; then
    echo "Root login disabled ✔"
else
    echo "Root login NOT disabled ❌"
fi

if grep -q "^PasswordAuthentication no" /etc/ssh/sshd_config; then
    echo "Password authentication disabled ✔"
else
    echo "Password authentication enabled ❌"
fi