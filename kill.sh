echo "Killing processes"
ps -afe | grep q | grep qprocesses | awk '{print $2}' | xargs kill &>/dev/null
echo "Processes killed"

echo "Killing feed-handler"
ps -afe | grep python3 | grep capture_stream.py | awk '{print $2}' | xargs kill &>/dev/null
echo "Killed feed-handler"