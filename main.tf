resource "tsuru_app" "app" {
  name              = var.name
  plan              = var.plan
  platform          = var.platform
  team_owner        = var.team_owner
  description       = var.description
  pool              = var.pool
  tags              = var.tags
  default_router    = var.default_router
  restart_on_update = var.restart_on_update
  custom_cpu_burst  = var.custom_cpu_burst

  metadata {
    labels      = var.labels
    annotations = var.annotations
  }

  dynamic "process" {
    for_each = var.processes
    content {
      name = process.value.name
      plan = process.value.custom_plan
      metadata {
        annotations = process.value.annotations
        labels      = process.value.labels
      }
    }
  }
}

resource "tsuru_app_deploy" "app_deploy" {
  count = var.deploy == false ? 0 : 1
  app   = tsuru_app.app.name
  image = var.image
}

resource "tsuru_app_env" "app_env" {
  app                           = tsuru_app.app.name
  environment_variables         = var.environment_variables
  private_environment_variables = var.private_environment_variables
}

resource "tsuru_app_cname" "app_cname" {
  for_each = { for cname in var.cnames : cname.hostname => cname }
  app      = tsuru_app.app.name
  hostname = each.value.hostname
}

resource "tsuru_app_autoscale" "app_scale" {
  for_each    = { for inst in var.processes : inst.name => inst }
  app         = tsuru_app.app.name
  process     = each.key
  min_units   = each.value.autoscale_min_units
  max_units   = each.value.autoscale_max_units
  cpu_average = each.value.autoscale_target_cpu
}


resource "tsuru_app_router" "app_router" {
  for_each = var.routers
  app      = tsuru_app.app.name
  name     = each.value
}

resource "tsuru_service_instance_bind" "app_bind" {
  for_each          = { for inst in var.binds : "${inst.service_name}-${inst.service_instance}" => inst }
  service_name      = each.value.service_name
  service_instance  = each.value.service_instance
  app               = tsuru_app.app.name
  restart_on_update = true
}

resource "tsuru_certificate_issuer" "cert" {
  for_each = { for cname in var.cnames : cname.hostname => cname if cname.issuer != null }
  app      = tsuru_app.app.name
  cname    = each.value.hostname
  issuer   = each.value.issuer
}

resource "tsuru_app_grant" "team" {
  for_each = var.team_grants
  app      = tsuru_app.app.name
  team     = each.value
}
