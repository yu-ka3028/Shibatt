liff.init({ liffId: "2006024454-QgjEWevp" })
.then(() => {
  return liff.getProfile();
})
.then(profile => {
  // サーバーに POST リクエストを送信
  fetch('/user_sessions/create_from_liff', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({
      user_session: {
        username: profile.displayName,
        profileImageUrl: profile.pictureUrl,
        line_user_id: profile.userId
      }
    })
  })
  .then(response => {
    if (!response.ok) {
      throw new Error('Network response was not ok');
    }
    return response.json();
  })
  .then(data => {
    console.log('Success:', data);
  })
  .catch((error) => {
    console.error('Error:', error);
  });
})
.catch((err) => {
  console.error('LIFF Initialization failed ', err);
});
