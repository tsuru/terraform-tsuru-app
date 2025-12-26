output "app_name" {
  value = tsuru_app.app.name
}

output "app_description" {
  value = tsuru_app.app.description
}

output "app_environment_variables" {
  value = tsuru_app_env.app_env.environment_variables
}

output "app_processes" {
  value = [for inst in tsuru_app_autoscale.app_scale : {
    name       = inst.process
    min_units  = inst.min_units
    max_units  = inst.max_units
    target_cpu = inst.cpu_average
  }]
}

output "app_routers" {
  value = [for router in tsuru_app_router.app_router : router.name]
}

output "app_cluster" {
  description = "The name of the cluster where the app is deployed"
  value       = tsuru_app.app.cluster
}

output "app_cnames" {
  description = "List of CNAMEs configured for the application"
  value       = [for cname in tsuru_app_cname.app-extra-cname : cname.hostname]
}

output "app_platform" {
  description = "Application platform"
  value       = tsuru_app.app.platform
}

output "app_pool" {
  description = "Application pool"
  value       = tsuru_app.app.pool
}

output "app_team_owner" {
  description = "Application team owner"
  value       = tsuru_app.app.team_owner
}

output "app_tags" {
  description = "Application tags"
  value       = tsuru_app.app.tags
}
