locals {
  processes_by_name = { for p in var.processes : p.name => p }

  autoscale_processes = {
    for name, inst in local.processes_by_name : name => inst
    if inst.autoscale_min_units != null && inst.autoscale_max_units != null && inst.autoscale_target_cpu != null
  }

  manual_unit_processes = {
    for name, inst in local.processes_by_name : name => inst
    if !(inst.autoscale_target_cpu != null || inst.autoscale_min_units != null || inst.autoscale_max_units != null)
  }
}

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
  for_each    = local.autoscale_processes
  app         = tsuru_app.app.name
  process     = each.key
  min_units   = each.value.autoscale_min_units
  max_units   = each.value.autoscale_max_units
  cpu_average = each.value.autoscale_target_cpu

  dynamic "scale_down" {
    for_each = each.value.scale_down != null ? [each.value.scale_down] : []

    content {
      percentage           = scale_down.value.percentage
      stabilization_window = scale_down.value.stabilization_window
      units                = scale_down.value.units
    }
  }

  dynamic "schedule" {
    for_each = each.value.schedule

    content {
      min_replicas = schedule.value.min_replicas
      start        = schedule.value.start
      end          = schedule.value.end
      timezone     = schedule.value.timezone
    }
  }

  dynamic "prometheus" {
    for_each = each.value.prometheus

    content {
      name           = prometheus.value.name
      query          = prometheus.value.query
      threshold      = prometheus.value.threshold
      custom_address = prometheus.value.custom_address
    }
  }
}

resource "tsuru_app_unit" "app_unit" {
  for_each = {
    for u in var.app_units : u.process => u
    if contains(keys(local.manual_unit_processes), u.process)
  }
  app         = tsuru_app.app.name
  process     = each.key
  units_count = each.value.units_count
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
