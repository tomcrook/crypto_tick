import websocket
import datetime
import json
import pykx as kx


def on_message(ws, message):
    coin = json.loads(message)
    tp('.u.upd', 'crypto', 
        [kx.SymbolAtom(coin['s']), 
        kx.TimestampAtom(datetime.datetime.fromtimestamp(int(coin['E']) / 1000)), 
        kx.FloatAtom(float(coin['p'])), 
        kx.FloatAtom(float(coin['i']))
        ])
    print(f"Publishing messages to tp.")

def on_error(ws, error):
    print(error)

def on_close(close_msg, x, y):
    print("### closed ###" + close_msg)

def streamKline(currency, interval):
    websocket.enableTrace(False)
    socket = f'wss://fstream.binance.com/ws/btcusdt@markPrice@1s'
    ws = websocket.WebSocketApp(socket,
                                on_message=on_message,
                                on_error=on_error,
                                on_close=on_close)

    ws.run_forever()

tp = kx.SyncQConnection(port=5010, wait=False)
streamKline('btcusdt', '1s')