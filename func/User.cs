using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using MySql.Data.MySqlClient;
using System.Collections.Generic;

namespace my_namespace
{
  public static partial class Program
  {
    [FunctionName("User")]
    public static IActionResult UserGet(
      [HttpTrigger(AuthorizationLevel.Function, "get", Route = null)] HttpRequest req,
      ILogger log
    )
    {
      try
      {
        MySqlConnection conn = new(Config.my_connection_string);
        conn.Open();

        Dictionary<int, string> response = new();

        string sql = "SELECT id, name FROM users";
        MySqlCommand cmd = new(sql, conn);
        MySqlDataReader reader = cmd.ExecuteReader();
        while (reader.Read())
        {
          response[int.Parse(reader["id"].ToString())] = reader["name"].ToString();
        }

        return new OkObjectResult(response);
      }
      catch (Exception ex)
      {
        return new BadRequestObjectResult(ex);
      }
    }
  }
}
