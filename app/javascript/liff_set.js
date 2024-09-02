liff.init({ liffId: "2006024454-QgjEWevp" })
.then(() => {
  return liff.getProfile();
})
.then(profile => {
  // サーバーに POST リクエストを送信
  fetch('/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({
      username: profile.displayName,
      profileImageUrl: profile.pictureUrl
    })
  });
})
.catch((err) => {
  console.error('LIFF Initialization failed ', err);
});
