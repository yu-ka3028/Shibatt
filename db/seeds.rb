# 新規登録が完了したユーザー
user = User.last

# 複数のメモ内容と作成日時
memo_data = [
  { content: "RUNTEQ祭", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "暑い", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "オフ会", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "アプリプレゼン会", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "審査員", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "第５回RUNTEQ祭", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "グルテンパーティー", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "BBQ", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "Rails基礎", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "中間試験", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "沼・・・", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "RUNTEQ祭は文化祭だ〜", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "本拠地はX", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "10円玉", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "ボドゲ", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "マルチタスク", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "愚かッッ!!", created_at: DateTime.parse("2024-09-16 10:00:00") },
  { content: "Vimハラ", created_at: DateTime.parse("2024-09-16 10:00:00") },
#先週振り返り用のメモ
  { content: "12時間耐久1日でもきつい笑", created_at: DateTime.parse("2024-09-10 10:00:00") },
  { content: "納豆の期限、明日だ", created_at: DateTime.parse("2024-09-10 10:00:00") },
  { content: "酒が切れる...", created_at: DateTime.parse("2024-09-10 10:00:00") },
  { content: "RUNTEQ祭ギリ間に合うか?!", created_at: DateTime.parse("2024-09-10 10:00:00") },
  { content: "アイス食べたい", created_at: DateTime.parse("2024-09-10 10:00:00") },
  { content: "新しいゼルダ欲しい", created_at: DateTime.parse("2024-09-10 10:00:00") },
]

# 複数のメモの作成
memos = memo_data.map do |data|
  Memo.create!(
    user_id: user.id,
    content: data[:content],
    created_at: data[:created_at],
    progress: false
  )
end

# 複数の振り返りメモ内容と作成日時、紐づけるメモ
reflection_memo_data = [
  { 
    content: "提出前にエラーざんまい", 
    created_at: DateTime.parse("2024-09-17 10:00:00"), 
    memos: [
      { content: "プリコンパイルは、Googleフォントが原因", created_at: DateTime.parse("2024-09-15 09:00:00") },
      { content: "herokuクラッシュは、JSの部分が原因だった...", created_at: DateTime.parse("2024-09-12 09:30:00") },
      { content: "一人でずっとLINE...最近AIとしか喋っとらんぞ!!", created_at: DateTime.parse("2024-09-08 18:30:00") },
      { content: "Shibaからの返答癒される〜", created_at: DateTime.parse("2024-09-02 23:30:00") },
    ]
  },
  { 
    content: "RUNTEQ祭でサムネ作りが好きになった", 
    created_at: DateTime.parse("2024-09-15 10:00:00"), 
    memos: [
      { content: "校長可愛い...!!これがフリー素材?!笑", created_at: DateTime.parse("2024-09-13 09:00:00") },
      { content: "12時間耐久の文字は死にそうな感じに決めたッッ!!", created_at: DateTime.parse("2024-09-12 09:30:00") },
      { content: "ついでにアプリのOGP画像も作るか!!", created_at: DateTime.parse("2024-09-17 18:30:00") },
    ]
  },
  { 
    content: "読書記録：「エンジニア×スタートアップ」こそ、最高のキャリアである", 
    created_at: DateTime.parse("2024-05-18 23:00:00"), 
    memos: [
      { content: "2022年の12月6日に出版", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "Amazon書籍ランキングで堂々の1位を獲得", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "スタートアップ企業で働いた体験談", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "SI業界とWeb業界の違い", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "Web業界での働き方", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "スタートアップでのエンジニアの働き方", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "未経験からエンジニアとして活躍する方法", created_at: DateTime.parse("2024-05-18 22:00:00") },
    ]
  },
  { 
    content: "読書記録：苦しかったときの話をしようか", 
    created_at: DateTime.parse("2024-05-18 23:00:00"), 
    memos: [
      { content: "2019/04/12販売", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "ビジネスマン父から我が子のために書いた本", created_at: DateTime.parse("2024-05-18 22:00:00") },
      { content: "働くことの本質", created_at: DateTime.parse("2024-05-18 22:00:00") },
    ]
  },
]

# 複数の振り返りメモの作成とメモへの紐付け
reflection_memos = reflection_memo_data.map do |data|
  reflection_memo = ReflectionMemo.create!(
    user_id: user.id,
    content: data[:content],
    created_at: data[:created_at],
    progress: false
  )

  # メモの作成と紐付け
  data[:memos].each do |memo_data|
    memo = Memo.create!(
      user_id: user.id,
      content: memo_data[:content],
      created_at: memo_data[:created_at],
      progress: false
    )

    # ReflectionMemoとMemoの関連付け
    ReflectionMemoMemo.create!(
      reflection_memo_id: reflection_memo.id,
      memo_id: memo.id
    )
  end

  reflection_memo
end