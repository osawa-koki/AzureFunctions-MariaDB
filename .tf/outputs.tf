
# 接続文字列を表示
output "connection_string" {
  value = azurerm_function_app.function_app.connection_string
  sensitive = true
}
