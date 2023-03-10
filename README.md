# AzureFunctions-MariaDB

ð¦ð¦ð¦ Azure Functionsã¨MariaDBã®çµã¿åããï¼  
Terraformãç¨ãã¦Azureä¸ã«`Azure Functions`ã¨`Maria DB`ãæ§ç¯ãã¦ãç°¡åãªRESTful APIãä½æãã¾ãã  

![ææç©](./docs/img/fruit.gif)  

## å®è¡æ¹æ³

### éçºç·¨

æåã«ãMariaDBã®Dockerã³ã³ãããèµ·åãã¾ãã  

```shell
docker-compose up db -d
```

ç¶ãã¦ã`local.settings.json.example`ã`local.settings.json`ã«ãªãã¼ã ãã¾ãã  

æå¾ã«`func`ãã£ã¬ã¯ããªåã®C#ãã­ã¸ã§ã¯ããå®è¡ãã¾ãã  
Visual Studioã§éãã¦ã`F5`ã­ã¼ãæ¼ãã¨å®è¡ã§ãã¾ãã  

ã³ã³ã½ã¼ã«ç»é¢ããå®è¡ããã«ã¯ãä»¥ä¸ã®ã³ãã³ããå®è¡ãã¾ãã  

```shell
dotnet run --project func
```

### æ¬çªç·¨

Azureä¸ã«ãªã½ã¼ã¹ãä½æãã¾ãã  
`Terraform`ãä½¿ã£ã¦ãã¾ãã  

`terraform.tfvars.example`ã`terraform.tfvars`ã«ãªãã¼ã ããåè¨­å®å¤ãå¥åãã¾ãã  

Terraformå¤æ°ã®è¨­å®ãå®äºããããä»¥ä¸ã®ã³ãã³ããå®è¡ãã¾ãã  

```shell
cd .tf
terraform init
terraform plan
terraform apply
```

ããã§ãAzureä¸ã«ãªã½ã¼ã¹ãä½æããã¾ãã  
ãªã½ã¼ã¹ãæ§ç¯ããããã¯ã©ã¤ã¢ã³ãããDBã«æ¥ç¶ãã`./init.sql/create_table.sql`ãå®è¡ãã¾ãã  

æ¥ç¶æå­åã¯`Server=âproject_nameâ.mariadb.database.azure.com;Database=âproject_name(ã-ãã¯ã_ãã«å¤æ)â;Uid=âmariadb_admin_usernameâ@âproject_nameâ;Pwd=âmariadb_admin_passwordâ`ã§ãã  

VSCodeã®æ¡å¼µæ©è½ã§ããAzure Tools(ms-vscode.vscode-node-azure-pack)ãä½¿ç¨ãã¦ãããã­ã¤ãã¾ãã  
å·¦ã®ãµã¤ããã¼ãã`Azure Functions`ãé¸æãã`Deploy to Function App`ãé¸æãã¾ãã  
é²ã®ãã¼ã¯ã§ãã  

## å®è£åå®¹

RESTful APIãå®è£ãã¾ããã  

| ã¨ã³ããã¤ã³ã | HTTPã¡ã½ãã | æ©è½ |
| --- | --- | --- |
| /user | GET | å¨ã¦ã®ã¦ã¼ã¶ãã¼ã¿ãåå¾ |
| /user | POST | ã¦ã¼ã¶ãã¼ã¿ãè¿½å  |
| /user | PUT | æå®ããIDã®ã¦ã¼ã¶ãã¼ã¿ãæ´æ° |
| /user | DELETE | æå®ããIDã®ã¦ã¼ã¶ãã¼ã¿ãåé¤ |

`id`ã¨`name`ã®2ã¤ã®ãã£ã¼ã«ããæã¤ã¦ã¼ã¶ãã¼ã¿ãæ±ãã¾ãã  

## GitHub Actionsã§ããã­ã¤

[å¬å¼ãµã¤ã](https://learn.microsoft.com/ja-jp/azure/azure-functions/functions-how-to-github-actions?tabs=dotnet)ãåç§ã  

é¢æ°ã¢ããªã®ç»é¢ããçºè¡ãã­ãã¡ã¤ã«ãåå¾ãã¾ãã  

![çºè¡ãã­ãã¡ã¤ã«](./docs/img/get-publish-profile.png)  

ãããGitHubã®ãªãã¸ããªã®`Settings` - `Secrets`ã«ç»é²ãã¾ãã  
ååã¯`AZURE_FUNCTIONAPP_PUBLISH_PROFILE`ã§ãã  

ãã¨ã¯ã`main`ãã©ã³ãã«ããã·ã¥ããã ãã§ãã  
èªåã§ããã­ã¤ããã¾ãã  
