document.addEventListener('DOMContentLoaded', async (event) => {
  try {
    await liff.init({ liffId: "2006024454-QgjEWevp" });
    const profile = await liff.getProfile();

    const response = await fetch('/user_sessions/create_from_liff', {
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
    });

    if (!response.ok) {
      throw new Error('Network response was not ok');
    }

    const data = await response.json();
    console.log('Success:', data);
  } catch (error) {
    console.error('Error:', error);
  }
});