#!/bin/bash

echo "Memory usage by process (sorted in descending order):"
echo "--------------------------------------------"
ps aux --sort=-%mem | awk 'NR==1 || NR<=11 {print $0}'
