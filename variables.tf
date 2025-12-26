variable "name" {
  description = "Tsuru app name"
  type        = string
}

variable "platform" {
  description = "Tsuru app platform"
  type        = string
}

variable "team_owner" {
  description = "Tsuru app team owner"
  type        = string
}

variable "description" {
  description = "Tsuru app description"
  type        = string
}

variable "image" {
  description = "Image to be used by the app"
  type        = string
  default     = ""
}

variable "deploy" {
  description = "Deploy the app after creation"
  type        = bool
  default     = false
}

variable "processes" {
  description = "Tsuru process configuration, required fields: name, autoscale_target_cpu, autoscale_min_units, autoscale_max_units, optional fields: custom_plan, annotations, labels, scale_down, schedule, prometheus"
  type = list(
    object({
      name                 = string
      custom_plan          = optional(string, null)
      autoscale_target_cpu = number
      autoscale_min_units  = number
      autoscale_max_units  = number
      annotations          = optional(map(string), {})
      labels               = optional(map(string), {})
      scale_down = optional(object({
        percentage           = optional(number, null)
        stabilization_window = optional(number, null)
        units                = optional(number, null)
      }), null)
      schedule = optional(list(object({
        min_replicas = number
        start        = string
        end          = string
        timezone     = optional(string, "UTC")
      })), [])
      prometheus = optional(list(object({
        name           = string
        query          = string
        threshold      = number
        custom_address = optional(string, null)
      })), [])
    })
  )
}

variable "plan" {
  description = "Tsuru app plan (see: tsuru plan list)"
  type        = string
  default     = "c0.1m0.1"
}

variable "routers" {
  description = "Tsuru app routers (see: tsuru router list)"
  type        = set(string)
  default     = []
}

variable "default_router" {
  description = "Tsuru app default router (see: tsuru router list)"
  type        = string
  default     = "none"
}

variable "pool" {
  description = "Tsuru pool (see: tsuru pool list)"
  type        = string
}

variable "tags" {
  description = "Tsuru tags"
  type        = set(string)
}

variable "restart_on_update" {
  description = "Whether to restart the app when its configuration or processes are updated"
  type        = bool
  default     = true
}

variable "environment_variables" {
  description = "non-sensitive app ENV variables"
  type        = map(string)
}

variable "private_environment_variables" {
  description = "Sensitive app ENV variables"
  type        = map(string)
  sensitive   = true
}

variable "binds" {
  description = "App binds"
  type = list(
    object({
      service_name     = string
      service_instance = string
    })
  )
  default = []
}

variable "labels" {
  description = "Labels metadata"
  type        = map(string)
  default     = {}
}

variable "annotations" {
  description = "Annotations metadata"
  type        = map(string)
  default     = {}
}

variable "custom_cpu_burst" {
  description = "CPU burst factory override"
  type        = number
  default     = null
}

variable "cnames" {
  description = "CNAMEs for the application. If issuer is provided, a certificate will be created"
  type = list(
    object({
      hostname = string
      issuer   = optional(string, null)
    })
  )
  default = []
}

variable "team_grants" {
  description = "List of teams to grant access to the application"
  type        = set(string)
  default     = []
}
