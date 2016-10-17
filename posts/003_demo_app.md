# Goal

- デモアプリの作成
- デモアプリを作成して遊んでみる

# Wait a minute

この章では、Phoenixのいくつかの機能を紹介するためのデモアプリケーションを作成します。
一つ一つ手作業で作成するのが面倒くさいファイル類を自動的に生成するコマンドを使ってアプリケーションをすばやく生成し、
それを元にPhoenixでWebアプリケーションを作成していく概要を学びます。
自動生成は確かに楽なのですが、本章以降ではあえて逆のアプローチを取り、少しずつアプリケーションを作成しながら各段階を体験していきます。
コマンドによる自動生成は概要を掴むには最適なので、この章でのみ利用します。  

作成するデモアプリケーションは、ユーザと(短い)マイクロポストのみをサポートするマイクロブログです。
このデモアプリケーションは動作しますが、完成には程遠い代物です。
また、一部の手順で何を行っているのか分からないことがあるかもしれません。
(Railsを利用したことがある方には馴染みある内容かもしれません)
しかし安心してください。以降の章にて、同等の機能を1つ1つご自分で作成していただきます。
本章の目的はまず体験をしてもらうことにありますので、頭の中を空っぽにして手順通りに実行することに集中してください。
ほとんどを自動生成コマンドで行いますので、Phoenixフレームワークを体験してみる程度の心構えで結構です。  

まず、飛び込んでみることが大事です。行動あるのみです。たとえ失敗しても何かを学ぶことはできます。(死ななければ...)
それでは、不死鳥と遊んでみるとしましょう！！  

# Index

Demo Application  
|> Preparation  
|> Data models  
|> Create users resource  
|> Create microposts resource  
|> Associate with has_many  

## Preparation

冒頭にて調子のいいことを言っていましたが、その前にPhoenixのプロジェクトを作成しなければいけません。
mixのアーカイブへPhoenixをインストールしていれば、"mix phoenix.new"と"mix local.phoenix"のコマンドが使えます。
"mix phoenix.new"を使えば、新しいPhoenixプロジェクトを作成することができます。
"mix local.phoenix"を使えばアーカイブにあるPhoenixをアップデートすることができます。
新しくリリースされ、バージョンを上げる際に利用するとよいと思います。
折角なので、コマンドを見てみましょう。  

#### Example:

```cmd
> mix help | grep phoenix
mix local.phoenix     # Updates Phoenix locally
mix phoenix.new       # Creates a new Phoenix v1.2.0 application
```

それでは、新しくPhoenixのプロジェクトを作成してみましょう。
(依存関係のインストールも行うので結構長いです)  

プロジェクト名はdemo_appになります。
途中でyesとnoの選択肢がでてきますが、"yes"で問題ありません。

#### Example:

```cmd
> cd path/to/project
..

> mix phoenix.new demo_app
...

Fetch and install dependencies? [Yn]　y
...

> cd demo_app
...
```

Phoenixフレームワークは、資産管理にBrunch.ioを使用しています。
Brunch.ioの依存関係はNodeのパッケージマネージャを通してインストールされています。
そして先ほどの選択肢ですが、phoenix.newの終了時にそれらの依存関係をインストールするかどうかが出ています。
noを選択した場合、npmとそれら依存関係をインストールしませんので後々、自分でインストールする必要があります。
npmや依存関係を利用せず使うには、"mix phoenix.new"へ--no-brunchオプションを付けて実行すれば問題なく利用できます。
大体の場合は、yesで問題ありません。  

プロジェクトを作成したことで、色々なコマンドが使えるようになっています。
折角なので、Phoenixで用意されているコマンド一覧を見てみましょう。  

#### Example:

```cmd
> mix help | grep phoenix
mix local.phoenix        # Updates Phoenix locally
mix phoenix.digest       # Digests and compress static files
mix phoenix.gen.channel  # Generates a Phoenix channel
mix phoenix.gen.html     # Generates controller, model and views for an HTML based resource
mix phoenix.gen.json     # Generates a controller and model for a JSON based resource
mix phoenix.gen.model    # Generates an Ecto model
mix phoenix.gen.presence # Generates a Presence tracker
mix phoenix.gen.secret   # Generates a secret
mix phoenix.new          # Creates a new Phoenix v1.2.0 application
mix phoenix.routes       # Prints all routes
mix phoenix.server       # Starts applications and their servers
```

後々、コマンドの説明についても行いますので、ここでは確認のみにしておきます。
次は、データベースの作成をします。データベースを利用するには、Ectoと呼ばれるパッケージを使います。
Ectoは、Elixirの公式プロジェクトの一つで、データベースと対話するためのドメイン固有言語です。
また、コンソールからデータベースを操作ができるようにいくつかの機能に対応したコマンドが用意されています。
コマンド一覧を確認してみます。  

#### Example:

```cmd
> mix ecto
Ecto v2.0.3
A database wrapper and language integrated query for Elixir.

Available tasks:

mix ecto.create        # Creates the repository storage
mix ecto.drop          # Drops the repository storage
mix ecto.dump          # Dumps the repository database structure
mix ecto.gen.migration # Generates a new migration for the repo
mix ecto.gen.repo      # Generates a new repository
mix ecto.load          # Loads previously dumped database structure
mix ecto.migrate       # Runs the repository migrations
mix ecto.migrations    # Displays the repository migration status
mix ecto.rollback      # Rolls back the repository migrations
```

コマンドから操作できることを簡単に説明すると、データベースの作成や削除、マイグレーションやロールバックなどに対応しています。
その中のデータベース作成用のコマンドを利用します。(コンパイルが同時に流れるので少し時間がかかると思います)  

```elixir
> mix ecto.create
...
```

ようやくですがPhoenixのローカルWebサーバを起動し、Webページを確認してみましょう。
Phoenixでサーバを起動するためには、"mix phoenix.server"を使います。
毎回使いますので、覚えておくと良いと思います。

#### Example:

```cmd
> mix phoenix.server
...

or

> iex -S mix phoenix.server
...
```

#### Note: "Ctrl+C"でサーバを終了することができます。

起動後、下記のアドレスへアクセスしてください。  

#### URL: http://localhost:4000

Phoenixのページが表示されいますね。
ようこそ！Phoenixフレームワークへ！！  

これでアプリケーションを作成するための下準備が完了しました。
Gitの方で管理するためコミットしてしまいましょう。  

#### Example:

```cmd
> git init
...

> git add .
...

> git commit -am "initial commit"
...

> git remote add origin git@github.com:[user_name]/demo_app.git
...

> git push -u origin master
...
```

## Data models

一般的には、アプリケーションを作成する前に、アプリケーションで使用される構造を表すデータモデルを最初に作成しておくものです。
本章のアプリケーションでは、ユーザと(短い)マイクロポストをサポートするマイクロブログを作成します。
そこで、まずアプリケーションのユーザで使用するモデルを作成し、次にマイクロポストで使用するモデルを作成します。
余り楽しい内容ではないですが、事前に準備をしておくことは大切なことです。(後から後悔しないためにも...)
今回、作成するデータモデルについて把握しましょう。  

### User data model

一口にユーザといっても多岐に渡ると思います。
ユーザというデータモデルを表す方法は色々とありますが、ここでは下記のように表現しようと思います。
モデル名はUser、テーブル名はusers、カラムとしてid、name、email、inserted_at、updated_atを持たせます。
ID番号(id)は重複のない一意のキーでinteger型です。名前(name)とメールアドレス(email)はstring型です。
挿入日時(inserted_at)と更新日時(updated_at)は"timestamp without time zone"型です。
ユーザのデータモデルの概要は下記のとおりです。  

#### Example:

```txt
+----------------------------------------+
|                 users                  |
+------------+---------------------------+
|id          |integer                    |
+------------+---------------------------+
|name        |string                     |
+------------+---------------------------+
|email       |string                     |
+------------+---------------------------+
|inserted_at |timestamp without time zone|
+------------+---------------------------+
|updated_at  |timestamp without time zone|
+------------+---------------------------+
```

ユーザ(users)は、データベースのテーブルに相当します。
また、id、name、email、inserted_at、updated_atは、テーブルのカラムに相当します。
実際のテーブルは下記のようになると思います。

#### Example:

```txt
                                      Table "public.users"
   Column    |            Type             |                     Modifiers
-------------+-----------------------------+----------------------------------------------------
 id          | integer                     | not null default nextval('users_id_seq'::regclass)
 name        | character varying(255)      |
 email       | character varying(255)      |
 inserted_at | timestamp without time zone | not null
 updated_at  | timestamp without time zone | not null
Indexes:
    "users_pkey" PRIMARY KEY, btree (id)
```

このユーザモデルとWebインターフェース(データモデルをWebで取り扱えるようにしたもの)を合わせたものをユーザリソースと呼びます。  

### Micropost data model

今回、もう一つデータモデルが存在しますね。そう、マイクロポストです。
モデル名はMicropost、テーブル名はmicroposts、カラムとしてid、content、user_id、inserted_at、updated_atを持たせます。
ID番号(id)、挿入日時(inserted_at)、更新日時(updated_at)はユーザと同じです。
contentはstring型です。そして、マイクロポストをユーザと関連付けるためのユーザID番号(user_id)がinteger型で存在します。(外部キーになる)
マイクロポストのデータモデルの概要は下記のとおりです。  

#### Example:

```txt
+----------------------------------------+
|               microposts               |
+------------+---------------------------+
|id          |integer                    |
+------------+---------------------------+
|content     |string                     |
+------------+---------------------------+
|user_id     |integer                    |
+------------+---------------------------+
|inserted_at |timestamp without time zone|
+------------+---------------------------+
|updated_at  |timestamp without time zone|
+------------+---------------------------+
```

マイクロポストのテーブルは下記のようになると思います。

#### Example:

```txt
                                      Table "public.microposts"
   Column    |            Type             |                        Modifiers
-------------+-----------------------------+---------------------------------------------------------
 id          | integer                     | not null default nextval('microposts_id_seq'::regclass)
 content     | character varying(255)      |
 user_id     | integer                     |
 inserted_at | timestamp without time zone | not null
 updated_at  | timestamp without time zone | not null
Indexes:
    "microposts_pkey" PRIMARY KEY, btree (id)
    "microposts_user_id_index" btree (user_id)
Foreign-key constraints:
    "microposts_user_id_fkey" FOREIGN KEY (user_id) REFERENCES users(id)
```

## Create users resource

前の項目で設計したユーザ用のデータモデルを、そのモデルを表示するためのWebインターフェースに従って実装します。
このデータモデルとWebインターフェースが組み合わさってUsersリソースとなり、
ユーザというものをHTTPプロトコル経由で自由に作成/読み出し/更新/削除できるモジュールとみなすことができるようになります。
そこそこの数のファイルが生成されます。興味があれば目を通してもよいですが、生成されたコードを今読む必要は特にありません。

それでは、待ちに待ったコードの生成を行っていきましょう。
Phoenixフレームワークのコマンド一覧は前の項目で確認しましたね。
その中にある"mix phoenix.gen.html"を使えば、モデル、コントローラ、ビューなどを一気に生成することができます。  

#### Example:

```cmd
mix phoenix.gen.html    # Generates controller, model and views for an HTML-based resource
```

上記のコマンドに必要な引数を渡すことで生成されます。
コマンドの引数には、リソース名を単数形にしたもの(この場合はUser)と複数形のテーブル名(この場合はusers)を使用し、
必要に応じたデータモデルの属性をオプションとしてパラメータに追加します。

#### Example:

```cmd
> mix phoenix.gen.html User users name:string email:string
* creating web/controllers/user_controller.ex
* creating web/templates/user/edit.html.eex
* creating web/templates/user/form.html.eex
* creating web/templates/user/index.html.eex
* creating web/templates/user/new.html.eex
* creating web/templates/user/show.html.eex
* creating web/views/user_view.ex
* creating test/controllers/user_controller_test.exs
* creating web/models/user.ex
* creating test/models/user_test.exs
* creating priv/repo/migrations/20160810122155_create_user.exs

Add the resource to your browser scope in web/router.ex:

    resources "/users", UserController

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

name:stringとemail:stringをオプションとして追加しています。
Userモデルの内容がデータモデルで設計した表のとおりになるようにします。
idパラメータはEctoによって自動的に主キーとしてデータベースに追加されています。
また、inserted_at、updated_atパラメータについてもマイグレーションファイルへ生成の段階で記述されていますので、自動的に追加されています。
そのため、自分で追加する必要はありません。  

ここから先にアプリケーションの開発を進めるためには、先にやることが二つあります。
一つはルーティングの追加、もう一つはマイグレーションの実行です。
どちらも特に難しいことはありません。前者から一つずつ行っていきます。  

まずは、ルーティングの追加を行います。
下記のファイルを開き、ルーティングを追加してください。

#### File: web/router.ex

```elixir
defmodule DemoApp.Router do
  ...

  scope "/", DemoApp do
    ...
    resources "/users", UserController
  end

  ...
end
```

#### Note: resourcesを使ってルーティングを作成すると、RESTfulなルーティングを追加してくれます。

続いて、マイグレーションを行います。
下記のようにEctoのコマンドを使用してデータベースへのマイグレーションを行います。
(RailsにおけるActive Recordのような存在です)  

### Example:

```cmd
> mix ecto.migrate
Compiling 9 files (.ex)
Generated demo_app app

21:22:27.980 [info]  == Running DemoApp.Repo.Migrations.CreateUser.change/0 forward

21:22:27.981 [info]  create table users

21:22:28.048 [info]  == Migrated in 0.0s

```

このコマンドは、マイグレーションファイルに基づいてデータベースを更新し、usersデータモデルを作成するためのものです。  

ここまでの手順が完了すると、ローカルWebサーバからユーザのページを見ることができます。
まだ何もプログラムしていないのに表示できるわけない？大丈夫です。
自動生成を使っていますので、これで表示できるようになります。
確認するために、サーバを起動してWebページを見てみましょう。  

#### Example:

```cmd
> mix phoenix.server
...
```

以下のアドレスにアクセスして下さい。  

#### URL: http://localhost:4000/users

(まだ何もデータがありませんが...)ユーザの一覧ページが表示されていますね。
この時点で、ユーザ管理用のページが多数追加されています。(一覧/作成/表示/更新/削除)
例えば、さきほどの/usersであればユーザの一覧が表示されます。/users/newとすれば新規ユーザ作成ページが表示されます。
試してみたい人は各ページにアクセスして遊んでみてください。
また、ルーティングの確認をする場合、下記のコマンドを使うことで確認することができます。
各ページにおけるページとURLの関係を確認するのにも使うことができます。  

#### Example:

```elixir
> mix phoenix.routes
...
user_path  GET     /users           DemoApp.UserController :index
user_path  GET     /users/:id/edit  DemoApp.UserController :edit
user_path  GET     /users/new       DemoApp.UserController :new
user_path  GET     /users/:id       DemoApp.UserController :show
user_path  POST    /users           DemoApp.UserController :create
user_path  PATCH   /users/:id       DemoApp.UserController :update
           PUT     /users/:id       DemoApp.UserController :update
user_path  DELETE  /users/:id       DemoApp.UserController :delete
```

## Create microposts resource

Usersリソースを作成して大体理解できたと思います。
今度は、Micropostsリソースで同じことをやっていきましょう。  

2つのリソース、MicropostsリソースとUsersリソースは色々な面で似通っています。
もし、Phoenixの基本を身体に叩き込みたいのであれば、2つを比較しながら繰り返し学ぶのが一番です。
UsersリソースとMicropostsリソースの構造の類似点を理解することは、その近道になります。  

Usersリソースの場合と同様に、Micropostsリソースでも自動生成のコマンドを使いコードを生成してみましょう。  

#### Example:

```cmd
> mix phoenix.gen.html Micropost microposts content:string user_id:references:users
* creating web/controllers/micropost_controller.ex
* creating web/templates/micropost/edit.html.eex
* creating web/templates/micropost/form.html.eex
* creating web/templates/micropost/index.html.eex
* creating web/templates/micropost/new.html.eex
* creating web/templates/micropost/show.html.eex
* creating web/views/micropost_view.ex
* creating test/controllers/micropost_controller_test.exs
* creating web/models/micropost.ex
* creating test/models/micropost_test.exs
* creating priv/repo/migrations/20160810153658_create_micropost.exs

Add the resource to your browser scope in web/router.ex:

    resources "/microposts", MicropostController

Remember to update your repository by running migrations:

    $ mix ecto.migrate
```

Usersリソースのときと同様に、まずはルーティングを追加をします。  

#### File: web/router.ex

```elixir
defmodule DemoApp.Router do
  ...

  scope "/", DemoApp do
    ...
    resources "/microposts", MicropostController
  end

  ...
end
```

Micropostsのルーティングルールが追加されていることを、"mix phoenix.routes"を使って確認してみましょう。  

#### Example:

```cmd
> mix phoenix.routes
...
micropost_path  GET     /microposts           DemoApp.MicropostController :index
micropost_path  GET     /microposts/:id/edit  DemoApp.MicropostController :edit
micropost_path  GET     /microposts/new       DemoApp.MicropostController :new
micropost_path  GET     /microposts/:id       DemoApp.MicropostController :show
micropost_path  POST    /microposts           DemoApp.MicropostController :create
micropost_path  PATCH   /microposts/:id       DemoApp.MicropostController :update
                PUT     /microposts/:id       DemoApp.MicropostController :update
micropost_path  DELETE  /microposts/:id       DemoApp.MicropostController :delete
```

新しいデータモデルでデータベースを更新するために、マイグレーションを実行します。  

#### Example:

```cmd
> mix ecto.migrate
Compiling 11 files (.ex)
Generated demo_app app

00:37:25.709 [info]  == Running DemoApp.Repo.Migrations.CreateMicropost.change/0 forward

00:37:25.710 [info]  create table microposts

00:37:25.757 [info]  create index microposts_user_id_index

00:37:25.772 [info]  == Migrated in 0.0s
```

これでMicropostsを作成する準備ができました。
ローカルWebサーバを起動して、マイクロポストのWebページを確認にしてみます。  

#### Example:

```cmd
> mix phoenix.server
...
```

#### URL: http://localhost:4000/microposts

今のままでは、マイクロポストがマイクロではありませんね。
何らかの方法を使い文字数制限を与えてみたいと思います。
Ecto.Changesetには、いくつか検証(validation)用の機能が用意されています。
validate_length/3を使えば、簡単に入力制限を追加することができます。
某SNSサイトのように140文字の制限を与えてみましょう。  

#### File: web/models/micropost.ex

```elixir
defmodule DemoApp.Micropost do
  ...
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content])
    |> validate_required([:content])
    |> validate_length(:content, max: 140)
  end
end
```

こんなに簡単なので、これで本当に動作するか疑問に思った人がいるかもしれません。
ちゃんと動作します。実際に141文字以上の新しいマイクロポストを投稿してみればわります。
実際に行ってみると、マイクロポストの内容が長すぎるというエラーメッセージがPhoenixによって表示されます。  

## Associate with has_many

異なるデータモデル同士の関連付けは、非常に頼もしい機能です。
ここでは、1人のユーザに対し複数のマイクロポストがあるとしましょう。
UserモデルとMicropostモデルをそれぞれ下記のように更新することでこの関連付けを表現できます。
(Micropostモデルについては、自動生成の機能を使い既に外部キーを生成しています)  

#### File: web/models/user.ex

```elixir
defmodule DemoApp.User do
  ...

  schema "users" do
    ...
    has_many :microposts, DemoApp.Micropost

    ...
  end

  ...
end
```

#### File: web/models/micropost.ex

```elixir
defmodule DemoApp.Micropost do
  ...

  schema "microposts" do
    ...
    belongs_to :user, DemoApp.User

    ...
  end

  ...
end
```

この関連付けを図にしたものが下記になります。
micropostsテーブルには、user_idカラムで外部キーを生成してあります。
それによって、Ectoがマイクロポストとユーザを関連付けることができるようになっています。

#### Example:

```txt
+---------------------+       +----------------+
|      microposts     |       |      users     |
+---+--------+--------+       +---+-----+------+
|id |content |user_id |       |id |name |email |
+---+--------+--------+       +---+-----+------+
|1  |post1   |1       |<--+---|1  |hoge |1     |
+------------+--------+   |   +---------+------+
|2  |post2   |1       |<--+ +-|2  |foo  |1     |
+------------+--------+     | +---------+------+
|3  |post3   |2       |<----+
+------------+--------+
```

最後にここまでの内容をGitへコミットしましょう。

#### Example:

```cmd
> git status
...

> git add -A
...

> git commit -am "Finish demo app"
...

> git push -u origin master
...
```

# Speaking to oneself

お疲れ様でした。今回はここまでになります。
Phoenixフレームワークの事始めとしてはどうでしたでしょうか？
Railsを使ったことがある方々は、どこかで見たことがあるような内容だったと思います。
初めてフレームワーク触れた方々は、分からない部分はあれど、あまり難しく感じなかったのではないでしょうか？
(もし分からなければ、私の説明が悪いです)
今回作成したアプリケーションをもっと本格的に実装していくのが本チュートリアルの内容になります。  
最後までお付き合い頂ければ幸いです。  

# Bibliography

[Ruby on Rails Tutorial](http://railstutorial.jp/chapters/toy_app?version=4.2#cha-a_toy_app)  
[Phoenix Framework - Guides - Mix Tasks](http://www.phoenixframework.org/v0.13.1/docs/mix-tasks)  
[Phoenix Framework - Guides - Ecto Models](http://www.phoenixframework.org/v0.13.1/docs/ecto-models)  

