function redirectToReflectionMemosNew() {
  liff.init({ liffId: "2006024454-QgjEWevp" })
    .then(() => {
      if (!liff.isLoggedIn()) {
        // ユーザーがログインしていない場合、ログイン画面にリダイレクト
        liff.login();
      } else {
        // ユーザーがログインしている場合、ユーザーIDを取得
        const userId = liff.getDecodedIDToken().sub;

        // ユーザーIDをURLのパラメータとしてRailsアプリケーションに送信
        location.href = `https://shibatt.herokuapp.com/reflection_memos/new?user_id=${userId}`;
      }
    })
    .catch((err) => {
      console.log("Error initializing LIFF: ", err);
    });
}

// "Week"が押されたときに上記の関数を呼び出す
document.getElementById('week-button').addEventListener('click', redirectToReflectionMemosNew);