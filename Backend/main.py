import requests
import socket
import time

# APIのURLを指定
url = "https://script.google.com/macros/s/AKfycbze8lAO9ZbSAvLgR3HEN1fjaampmWEZ_x6h5FTGD8LmTrGbpDj7Dj0XCYqscFtjFC2I/exec"  

host = "172.16.8.33"  #Processingで立ち上げたサーバのIPアドレス
port = 10001       #Processingで設定したポート番号

if __name__ == '__main__':
    socket_client = socket.socket(socket.AF_INET, socket.SOCK_STREAM) #オブジェクトの作成
    socket_client.connect((host, port)) #サーバに接続
    response = requests.get(url)

    while True:
        # GETリクエストを送信
        response = requests.get(url)

        # ステータスコードを表示
        print(f"ステータスコード: {response.status_code}")

        # レスポンスの内容を表示
        try:
            response_json = response.json()
            print(response_json["num"])
            response_string = ', '.join(map(str, response_json["num"]))
            socket_client.send(response_string.encode('utf-8')) #データを送信
        except requests.exceptions.JSONDecodeError:
            print("レスポンスがJSON形式ではありません")
            print(response.text)
        time.sleep(0.1)
