// DOMが読み込まれたら処理が走る
document.addEventListener('DOMContentLoaded', () => {
  // csrf-tokenを取得
  const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
  console.log("CSRF token: ", token); // デバッグ

  // LIFF_IDを使ってLIFFの初期化
  liff
  .init({
    liffId: "2006024454-QgjEWevp",
    // 他のブラウザで開いたときは初期化と一緒にログインもさせるオプション
    withLoginOnExternalBrowser: true
  })
  .then(() => {
    console.log("LIFF initialized"); // デバッグ
    // 初期化後の処理の設定
    liff
    .ready.then(() => {
      // 初期化によって取得できるidtokenの定義
      const idToken = liff.getIDToken()
      console.log("ID token: ", idToken); // デバッグ

      // bodyにパラメーターの設定
      const body =`idToken=${idToken}`
      // リクエスト内容の定義
      const request = new Request('/user', {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=utf-8',
          'X-CSRF-Token': token
        },
        method: 'POST',
        body: body
      });

      console.log("Request: ", request); // デバッグ

      // リクエストを送る
      fetch(request)
      // jsonでレスポンスからデータを取得して/after_loginに遷移する
      .then(response => {
        console.log("Response: ", response); // デバッグ
        return response.json();
      })
      .then(data => {
        console.log("Data: ", data); // デバッグ
        data_id = data
      })
      .then(() => {
        console.log("Redirecting to /after_login"); // デバッグ
        window.location = '/after_login'
      })
    })
  })
  .catch(error => {
    console.error("Error initializing LIFF: ", error); // エラーハンドリング
  });
});
