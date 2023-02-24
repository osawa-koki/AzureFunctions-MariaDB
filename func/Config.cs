using System;
using Microsoft.Extensions.Configuration;

namespace my_namespace
{
  public static class Config
  {
    internal static readonly string my_env = Environment.GetEnvironmentVariable("MY_ENV", EnvironmentVariableTarget.Process);
    private static readonly IConfigurationRoot config = new ConfigurationBuilder().AddEnvironmentVariables().Build();
    internal static readonly string my_connection_string = config.GetConnectionString("MY_CONNECTION_STRING");
  }
}
