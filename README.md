# AzureFunctions-MariaDB

Azure FunctionsとMariaDBの組み合わせ！  
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

```shell
cd .tf
terraform init
terraform plan
terraform apply
```

VSCodeの拡張機能であるAzure Tools(ms-vscode.vscode-node-azure-pack)を使用して、デプロイします。  
左のサイドバーから`Azure Functions`を選択し、`Deploy to Function App`を選択します。  
雲のマークです。  
