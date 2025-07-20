source ~/crypto_tick/platform.profile

echo "Starting Q processes"
q $TP_SCRIPT -l -p $TP_PORT &
q $RDB_SCRIPT -l -p $RDB_PORT &

sleep 1
echo "Connecting tp to rdb"
q control.q &

sleep 1
echo "Starting feed-handler"
python3 capture_stream.py > /dev/null 2>&1 &

echo "Done."
exit
