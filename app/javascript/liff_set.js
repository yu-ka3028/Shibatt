liff.init({ liffId: "2006024454-QgjEWevp" })
.then(() => {
  return liff.getProfile();
})
.then(profile => {
  sessionStorage.setItem('username', profile.displayName);
  sessionStorage.setItem('profileImageUrl', profile.pictureUrl);
})
.catch((err) => {
  console.error('LIFF Initialization failed ', err);
});
