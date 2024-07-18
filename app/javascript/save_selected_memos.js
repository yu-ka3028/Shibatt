window.saveSelectedMemos = function(checkbox) {
  var selectedMemos = JSON.parse(localStorage.getItem('selectedMemos')) || [];
  if (checkbox.checked) {
    selectedMemos.push(checkbox.value);
  } else {
    var index = selectedMemos.indexOf(checkbox.value);
    if (index > -1) {
      selectedMemos.splice(index, 1);
    }
  }
  localStorage.setItem('selectedMemos', JSON.stringify(selectedMemos));
}

// ボタンがクリックされたときにAjaxリクエストを送信
document.getElementById('submit-button').addEventListener('click', function() {
  var selectedMemos = JSON.parse(localStorage.getItem('selectedMemos')) || [];

  fetch('/reflection_memos', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
    },
    body: JSON.stringify({ memo_ids: selectedMemos })
  })
  .then(response => response.json())
  .then(data => {
    // 必要に応じてレスポンスを処理...
  });
});

function restoreCheckboxState() {
  var selectedMemos = JSON.parse(localStorage.getItem('selectedMemos')) || [];
  selectedMemos.forEach(function(memoId) {
    var checkbox = document.getElementById('memo_' + memoId);
    if (checkbox) {
      checkbox.checked = true;
    }
  });
}

window.onload = function() {
  restoreCheckboxState();
};

// ページネーションが完了した後にチェックボックスの状態を復元
document.addEventListener('paginationCompleted', function() {
  restoreCheckboxState();
});
