using System;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Logging;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;

namespace my_namespace
{
  public static partial class Program
  {
    [FunctionName("UserGet")]
    public static IActionResult UserGet(
      [HttpTrigger(AuthorizationLevel.Function, "get", Route = "user")] HttpRequest req,
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

    [FunctionName("UserPost")]
    public static IActionResult UserPost(
      [HttpTrigger(AuthorizationLevel.Function, "post", Route = "user")] HttpRequest req,
      ILogger log
    )
    {
      try
      {
        // JSONボディからデータを取得
        string requestBody = new StreamReader(req.Body).ReadToEnd();
        dynamic data = JsonConvert.DeserializeObject(requestBody);
        string name = data?.name;

        if (name == null)
        {
          return new BadRequestObjectResult("name is required");
        }

        MySqlConnection conn = new(Config.my_connection_string);
        conn.Open();

        string sql = "INSERT INTO users(name) VALUES(@user);";
        MySqlCommand cmd = new(sql, conn);
        cmd.Parameters.AddWithValue("@user", name);

        // 作成したデータを取得
        cmd.ExecuteNonQuery();
        int id = (int)cmd.LastInsertedId;

        return new OkObjectResult(new {
          id = id,
          name = name,
        });
      }
      catch (Exception ex)
      {
        return new BadRequestObjectResult(ex);
      }
    }

    [FunctionName("UserPut")]
    public static IActionResult UserPut(
      [HttpTrigger(AuthorizationLevel.Function, "put", Route = "user")] HttpRequest req,
      ILogger log
    )
    {
      try
      {
        // JSONボディからデータを取得
        string requestBody = new StreamReader(req.Body).ReadToEnd();
        dynamic data = JsonConvert.DeserializeObject(requestBody);
        int? id = data?.id;
        string name = data?.name;

        if (id == null)
        {
          return new BadRequestObjectResult("id is required");
        }

        if (name == null)
        {
          return new BadRequestObjectResult("name is required");
        }

        MySqlConnection conn = new(Config.my_connection_string);
        conn.Open();

        string sql = "UPDATE users SET name = @name WHERE id = @id;";
        MySqlCommand cmd = new(sql, conn);
        cmd.Parameters.AddWithValue("@id", id);
        cmd.Parameters.AddWithValue("@name", name);

        // 作成したデータを取得
        cmd.ExecuteNonQuery();

        return new OkObjectResult(new
        {
          id = id,
          name = name,
        });
      }
      catch (Exception ex)
      {
        return new BadRequestObjectResult(ex);
      }
    }
  }
}
