# Shibatt
![Shibatt](app/assets/images/OGP_Shibatt.png)

---
### ■サービスURL
https://www.memo-shibatt.com/
- LINEを使用したサービスのため、<br>**公式LINEチャンネル"Shibatt"「友達登録」を推奨**しております
- ユーザー名とパスワードで簡単にログインも可能です

### ■サービス概要
- メモを作成し、さらにアウトプットするためのサービスです
- インプットした内容や、アイデア・感情など自分の言葉で素早くメモを残せます
- さらに、書きっぱなしにせず、振り返りメモを作成を促し、FBで応援します

### ■ このサービスへの思い・作りたい理由
- 今までメモやTIL、SNSなど自分の言葉でアウトプットしてきたが、書きっぱなしになっていた
- 何かと慌ただしい日々でもインプットにとどまらず振り返り、自分と向き合う時間を確保したい
- また、就活・転職、体調不良などいざ振り返ろうと思ったとき、まとめてやるのは結構ハードではないか
- 学習内容、自己分析、セルフメンタルケアに使えるアプトプットツールを作りたい　

### ■ ユーザー層について
- スマホで思いつきメモを気軽に残し、活用したい人<br>
  - 日常の思いつきを、日常使用するツールで書き留められるようLINE友達登録を推奨
  - スマホでの使用を想定しており、レスポンシブ対応
- アウトプットを効率良く、継続したい人<br>
  - 先週作成したメモをまとめて振り返る機能で忙しい日々でも効率的にアウトプット
  - 振り返りメモ作成により、フィードバックを受け取れる機能や達成率の表示でモチベーション向上

### ■サービスの利用イメージ

| トップ画面 | 新規ユーザー登録 | ログイン |
| --- | --- | --- |
| [![Image from Gyazo](https://i.gyazo.com/8f26434d81f5116145074e3b07091f22.png)](https://gyazo.com/8f26434d81f5116145074e3b07091f22)| [![Image from Gyazo](https://i.gyazo.com/f71d6edb8f1c481396cf3f4fed78bac4.png)](https://gyazo.com/f71d6edb8f1c481396cf3f4fed78bac4) | [![Image from Gyazo](https://i.gyazo.com/2ecf7cd4d8e51cc9c6be6dca9f2bc917.png)](https://gyazo.com/2ecf7cd4d8e51cc9c6be6dca9f2bc917) |

| メモ作成 | | |
| --- | --- | ---- |
| (1)LINEからメモ作成 | (2)アプリからメモ一覧 | メモ一覧 |
| [![Image from Gyazo](https://i.gyazo.com/87a2897cc45afdad0f0e2e0f77ef1029.gif)](https://gyazo.com/87a2897cc45afdad0f0e2e0f77ef1029) | [![Image from Gyazo](https://i.gyazo.com/fbbf8c8f4eca2631c3aa66ddf9e0a079.gif)](https://gyazo.com/fbbf8c8f4eca2631c3aa66ddf9e0a079) | [![Image from Gyazo](https://i.gyazo.com/65380b69204a49f84c9894e00c98233b.png)](https://gyazo.com/65380b69204a49f84c9894e00c98233b) |

| 振り返りメモ |  |  |
| --- | --- | --- |
| 振り返りメモ作成 | (1)LINEに<br>フィードバックが届く | (2)フィードバックを<br>アプリで確認 |
| [![Image from Gyazo](https://i.gyazo.com/52013eb0b2a618f1ebcae70989afd515.png)](https://gyazo.com/52013eb0b2a618f1ebcae70989afd515) | [![Image from Gyazo](https://i.gyazo.com/dcd3da2599c3ed1667889c8999dd00ce.png)](https://gyazo.com/dcd3da2599c3ed1667889c8999dd00ce) | [![Image from Gyazo](https://i.gyazo.com/4265346853551e701c2ca519bc206056.png)](https://gyazo.com/4265346853551e701c2ca519bc206056) | 
----

### ■ ユーザーの獲得について
- X共有機能による宣伝
  ：振り返りメモ作成後に届くフィードバック時に「Xで共有」ボタンを表示

### ■ サービスの差別化ポイント・推しポイント
- **ジャンル・タグ機能によるメモ管理**<br>
  デジタルではスマホのメモ機能、NotionやX（Twitter）、アナログではノートなど自分の思考や感情を残すサービスが存在するが、当サービスではジャンル・タグ機能により、分類ごとに整理して振り返る機能が推しポイント

- **問いかけ形式の通知により受動的に振り返りが可能**<br>
  メモのステータスと作成日時、ジャンル・タグの情報を取得し、未完了・一定期間以上経過したメモをAI要約・問いかけ形式のテキストで返して通知する機能が差別化ポイント

### 技術スタック

| category | 技術 |
| --- | --- |
| Frontend | Rails 7.1.3.2 (Hotwire/Turbo), TailwindCSS, DaisyUI |
| Backend | Rails 7.1.3.2 (Ruby 3.2.2 ) |
| Infrastructure | heroku |
| Database | Mysql2,jawsDB |
| Environment setup | Docker |
| CI/CD | GitHub Actions |
| Design | Figma,dbdiagram |
| Authentication | sorcery |
| Web API | LINE Messaging API、OpenAI API |

#　画面遷移図

[![Image from Gyazo](https://i.gyazo.com/dd4457c7d1a8d8cc4448017d84ccb296.png)](https://gyazo.com/dd4457c7d1a8d8cc4448017d84ccb296)

# ER図
![image](https://i.gyazo.com/3edb65f5e89ed490d9294bc442c1e746.png)

