using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using System.Text;
using System.Security.Cryptography;

namespace my_namespace
{
  public static partial class Program
  {
    [FunctionName("MyHttpTrigger")]
    public static async Task<IActionResult> MyHttpTrigger(
      [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req,
      ILogger log
    )
    {
      try
      {
        log.LogInformation("C# HTTP trigger function processed a request.");

        string name = req.Query["name"];

        string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
        dynamic data = JsonConvert.DeserializeObject(requestBody);
        name = name ?? data?.name;

        // 接続文字列をSHA256でハッシュ化した値を取得
        var hasher = SHA256.Create();
        var hashed_connection_string = BitConverter.ToString(hasher.ComputeHash(Encoding.UTF8.GetBytes(Config.my_connection_string))).Replace("-", "");

        string responseMessage = string.IsNullOrEmpty(name)
          ? $"EnvironmentVariable -> {Config.my_env} | Connection string -> {hashed_connection_string}"
          : $"Hello, {name}. This HTTP triggered function executed successfully.";

        return new OkObjectResult(responseMessage);
      } catch (Exception ex)
      {
        return new BadRequestObjectResult(ex);
      }
    }
  }
}
