// Copyright 2026 tsuru authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

module "my_app" {
  source = "../.."

  name        = "my-application"
  description = "My awesome application"
  platform    = "python"
  plan        = "c1m1"
  pool        = "production"
  team_owner  = "devops-team"
  tags        = ["api", "production"]

  # Process with autoscale
  processes = [
    {
      name                 = "web"
      custom_plan          = "c1m1"
      autoscale_target_cpu = 75
      autoscale_min_units  = 3
      autoscale_max_units  = 20
    },
    {
      name = "worker"
      # No autoscale - will use fixed units from app_units
    }
  ]

  # Fixed units for processes without autoscale
  app_units = [
    {
      process     = "worker"
      units_count = 5
    }
  ]

  cnames = [
    {
      hostname = "myapp.example.com"
      issuer   = "letsencrypt"
    }
  ]
}

output "app_name" {
  value = module.my_app.app_name
}

output "app_processes" {
  value = module.my_app.app_processes
}
