using System;
using System.IO;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration;

namespace my_namespace
{
  public static partial class Program
  {
    [FunctionName("HelloWorld")]
    public static IActionResult HelloWorld(
      [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)] HttpRequest req
    )
    {
      try
      {
        return new OkObjectResult("Hello World!");
      }
      catch (Exception ex)
      {
        return new BadRequestObjectResult(ex);
      }
    }
  }
}
