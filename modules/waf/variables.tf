variable "prefix" {
  description = "Prefix for WAF resource names"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}