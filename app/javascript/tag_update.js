document.addEventListener('DOMContentLoaded', (event) => {
  let userId = document.body.dataset.userId; // ユーザーIDを適切に設定
  fetch(`/users/${userId}/memos`)
    .then(response => response.json())
    .then(memos => {
      for(let i = 0; i < memos.length; i++) {
        let memoId = memos[i].id;
        let selectElement = document.getElementById(`tag_select_${memoId}`);

        if(selectElement) {
          // ページが読み込まれたときに現在のタグを選択状態にする
          let currentTag = document.getElementById(`tag_display_${memoId}`).textContent;
          selectElement.value = currentTag;

          selectElement.addEventListener('change', (event) => {
            let selectedTag = event.target.value;

            // Ajax通信を行う
            fetch(`/memos/${memoId}/update_tag`, {
              method: 'PATCH',
              headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
              },
              body: JSON.stringify({ tag: selectedTag })
            })
            .then(response => response.json())
            .then(data => {
              if (data.success) {
                // タグの更新が成功した場合、ページ上のタグ表示を更新する
                document.getElementById(`tag_display_${memoId}`).textContent = selectedTag;
              } else {
                // タグの更新が失敗した場合、エラーメッセージを表示する
                alert('タグの更新に失敗しました: ' + data.errors.join(', '));
              }
            });
          });
        }
      }
    });
});