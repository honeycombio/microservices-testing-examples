# Input variable definitions

variable "dataset" {
  description = "Name of the dataset the buildevents data are flowing to."
  type        = string
  default = "buildevents"
}

variable "time_range" {
  description = "Time range in seconds to use for the queries."
  type        = number
  default     = 604800 # 7 days in seconds
}

variable "ideal_build_duration" {
  description = "Ideal build duration in context."
  type        = number
  default     = 120000 # 2 mins in milliseconds
}

