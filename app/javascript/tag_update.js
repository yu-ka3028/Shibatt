document.addEventListener('DOMContentLoaded', (event) => {
  document.querySelectorAll('select.tag-selector').forEach((select) => {
    console.log('Tag selection changed');
    select.addEventListener('change', (event) => {
      let selectedTag = select.value;
      let memoId = select.dataset.memoId; // セレクトボックスにdata-memo-id属性を追加しておく

      fetch(`/users/${userId}/memos/${memoId}/update_tag`, { // userIdは適切な値に置き換えてください
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ tag: selectedTag })
      })
      .then(response => response.json())
      .then(data => {
        if (data.success) {
          // 画面の更新処理をここに書く
          location.reload(); // 例えば、ページ全体をリロードする場合
        } else {
          console.error('Error:', data.errors);
        }
      });
    });
  });
});