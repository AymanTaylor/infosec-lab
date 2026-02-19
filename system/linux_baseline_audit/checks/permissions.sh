echo ""
echo "=== World Writable Files (Top 20) ==="

find / -xdev -type f -perm -0002 2>/dev/null | head -20