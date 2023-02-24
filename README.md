# AzureFunctions-MariaDB

🦝🦝🦝 Azure FunctionsとMariaDBの組み合わせ！  
Terraformを用いてAzure上に`Azure Functions`と`Maria DB`を構築して、簡単なRESTful APIを作成します。  

![成果物](./docs/img/fruit.gif)  

## 実行方法

### 開発編

最初に、MariaDBのDockerコンテナを起動します。  

```shell
docker-compose up db -d
```

続いて、`local.settings.json.example`を`local.settings.json`にリネームします。  

最後に`func`ディレクトリ内のC#プロジェクトを実行します。  
Visual Studioで開いて、`F5`キーを押すと実行できます。  

コンソール画面から実行するには、以下のコマンドを実行します。  

```shell
dotnet run --project func
```

### 本番編

Azure上にリソースを作成します。  
`Terraform`を使っています。  

`terraform.tfvars.example`を`terraform.tfvars`にリネームし、各設定値を入力します。  

Terraform変数の設定が完了したら、以下のコマンドを実行します。  

```shell
cd .tf
terraform init
terraform plan
terraform apply
```

これで、Azure上にリソースが作成されます。  
リソースを構築したら、クライアントからDBに接続し、`./init.sql/create_table.sql`を実行します。  

接続文字列は`Server=☆project_name☆.mariadb.database.azure.com;Database=☆project_name(「-」は「_」に変換)☆;Uid=☆mariadb_admin_username☆@☆project_name☆;Pwd=☆mariadb_admin_password☆`です。  

VSCodeの拡張機能であるAzure Tools(ms-vscode.vscode-node-azure-pack)を使用して、デプロイします。  
左のサイドバーから`Azure Functions`を選択し、`Deploy to Function App`を選択します。  
雲のマークです。  

## 実装内容

RESTful APIを実装しました。  

| エンドポイント | HTTPメソッド | 機能 |
| --- | --- | --- |
| /user | GET | 全てのユーザデータを取得 |
| /user | POST | ユーザデータを追加 |
| /user | PUT | 指定したIDのユーザデータを更新 |
| /user | DELETE | 指定したIDのユーザデータを削除 |

`id`と`name`の2つのフィールドを持つユーザデータを扱います。  
