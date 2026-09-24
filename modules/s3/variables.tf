variable "prefix" {
  description = "Prefix for S3 resource names"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}