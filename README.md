# Terraform Tsuru App Module

A comprehensive Terraform module for managing Tsuru applications with Infrastructure as Code (IaC).

## Why This Module?

This module addresses several key challenges in Tsuru application management:

### Key Features

- Complete Tsuru application lifecycle management
- Automatic scaling configuration
- Environment variables management (sensitive and non-sensitive)
- Custom CNAMEs and SSL certificates
- Service instance bindings
- Multiple routers support
- Process-level customization with metadata

## Usage

### Basic Example

```hcl
module "my_app" {
  source = "github.com/your-org/terraform-tsuru-app"

  name        = "my-application"
  description = "My awesome application"
  platform    = "python"
  plan        = "c0.5m1.0"
  pool        = "production"
  team_owner  = "my-team"
  tags        = ["api", "production"]

  processes = [
    {
      name                 = "web"
      custom_plan          = "c2.0m4.0"
      autoscale_target_cpu = 75
      autoscale_min_units  = 3
      autoscale_max_units  = 20
      labels = {
        "process" = "api"
      }
    },
    {
      name                 = "worker"
      autoscale_target_cpu = 80
      autoscale_min_units  = 2
      autoscale_max_units  = 10
    }
  ]

  environment_variables = {
    LOG_LEVEL = "info"
    APP_ENV   = "production"
  }

  # CNAMEs with optional SSL certificates
  cnames = [
    {
      hostname = "myapp.example.com"
      issuer   = "letsencrypt"  # Creates CNAME + SSL certificate
    },
    {
      hostname = "api.example.com"
      issuer   = "letsencrypt"  # Creates CNAME + SSL certificate
    },
    {
      hostname = "staging.example.com"
      # No issuer - only creates CNAME
    }
  ]

}
```

## Examples

Check the [`examples/`](examples/) directory for complete usage examples:

- **[simple](examples/simple/)** - Basic usage showing both autoscale and fixed units configuration

Each example includes a detailed README with instructions and important notes about deployment requirements.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Development

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [terraform-docs](https://terraform-docs.io/) (for documentation generation)

### Makefile Commands

```bash
make help         # Show available commands
make fmt          # Format Terraform files
make docs         # Generate documentation
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Maintainers

This module is maintained by:

- **[@elojas2](https://github.com/elojas2)** - Eloyse Fernanda
- **[@fbtravi](https://github.com/fbtravi)** - Felipe Travi
- **[@wpjunior](https://github.com/wpjunior)** - Wilson Júnior

Feel free to reach out to the maintainers for questions, suggestions, or if you're interested in becoming a maintainer yourself.

---

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_tsuru"></a> [tsuru](#requirement\_tsuru) | ~> 2.17.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_tsuru"></a> [tsuru](#provider\_tsuru) | ~> 2.17.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [tsuru_app.app](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app) | resource |
| [tsuru_app_autoscale.app_scale](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_autoscale) | resource |
| [tsuru_app_cname.app_cname](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_cname) | resource |
| [tsuru_app_deploy.app_deploy](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_deploy) | resource |
| [tsuru_app_env.app_env](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_env) | resource |
| [tsuru_app_grant.team](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_grant) | resource |
| [tsuru_app_router.app_router](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_router) | resource |
| [tsuru_app_unit.app_unit](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/app_unit) | resource |
| [tsuru_certificate_issuer.cert](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/certificate_issuer) | resource |
| [tsuru_service_instance_bind.app_bind](https://registry.terraform.io/providers/tsuru/tsuru/latest/docs/resources/service_instance_bind) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_annotations"></a> [annotations](#input\_annotations) | Annotations metadata | `map(string)` | `{}` | no |
| <a name="input_app_units"></a> [app\_units](#input\_app\_units) | Configures fixed units (tsuru\_app\_unit) per process. Can only be used when the process does not have autoscale configured (autoscale\_* not set). | <pre>list(<br/>    object({<br/>      process     = string<br/>      units_count = number<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_binds"></a> [binds](#input\_binds) | App binds | <pre>list(<br/>    object({<br/>      service_name     = string<br/>      service_instance = string<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_cnames"></a> [cnames](#input\_cnames) | CNAMEs for the application. If issuer is provided, a certificate will be created | <pre>list(<br/>    object({<br/>      hostname = string<br/>      issuer   = optional(string, null)<br/>    })<br/>  )</pre> | `[]` | no |
| <a name="input_custom_cpu_burst"></a> [custom\_cpu\_burst](#input\_custom\_cpu\_burst) | CPU burst factory override | `number` | `null` | no |
| <a name="input_default_router"></a> [default\_router](#input\_default\_router) | Tsuru app default router (see: tsuru router list) | `string` | `"none"` | no |
| <a name="input_deploy"></a> [deploy](#input\_deploy) | Deploy the app after creation | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | Tsuru app description | `string` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | non-sensitive app ENV variables | `map(string)` | n/a | yes |
| <a name="input_image"></a> [image](#input\_image) | Image to be used by the app | `string` | `""` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels metadata | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | Tsuru app name | `string` | n/a | yes |
| <a name="input_plan"></a> [plan](#input\_plan) | Tsuru app plan (see: tsuru plan list) | `string` | `"c0.1m0.1"` | no |
| <a name="input_platform"></a> [platform](#input\_platform) | Tsuru app platform | `string` | n/a | yes |
| <a name="input_pool"></a> [pool](#input\_pool) | Tsuru pool (see: tsuru pool list) | `string` | n/a | yes |
| <a name="input_private_environment_variables"></a> [private\_environment\_variables](#input\_private\_environment\_variables) | Sensitive app ENV variables | `map(string)` | n/a | yes |
| <a name="input_processes"></a> [processes](#input\_processes) | Tsuru process configuration. Fields: name (required). Autoscale is optional: to enable it, set autoscale\_target\_cpu/autoscale\_min\_units/autoscale\_max\_units. Optional fields: custom\_plan, annotations, labels, scale\_down, schedule, prometheus | <pre>list(<br/>    object({<br/>      name                 = string<br/>      custom_plan          = optional(string, null)<br/>      autoscale_target_cpu = optional(number, null)<br/>      autoscale_min_units  = optional(number, null)<br/>      autoscale_max_units  = optional(number, null)<br/>      annotations          = optional(map(string), {})<br/>      labels               = optional(map(string), {})<br/>      scale_down = optional(object({<br/>        percentage           = optional(number, null)<br/>        stabilization_window = optional(number, null)<br/>        units                = optional(number, null)<br/>      }), null)<br/>      schedule = optional(list(object({<br/>        min_replicas = number<br/>        start        = string<br/>        end          = string<br/>        timezone     = optional(string, "UTC")<br/>      })), [])<br/>      prometheus = optional(list(object({<br/>        name           = string<br/>        query          = string<br/>        threshold      = number<br/>        custom_address = optional(string, null)<br/>      })), [])<br/>    })<br/>  )</pre> | n/a | yes |
| <a name="input_restart_on_update"></a> [restart\_on\_update](#input\_restart\_on\_update) | Whether to restart the app when its configuration or processes are updated | `bool` | `true` | no |
| <a name="input_routers"></a> [routers](#input\_routers) | Tsuru app routers (see: tsuru router list) | `set(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tsuru tags | `set(string)` | n/a | yes |
| <a name="input_team_grants"></a> [team\_grants](#input\_team\_grants) | List of teams to grant access to the application | `set(string)` | `[]` | no |
| <a name="input_team_owner"></a> [team\_owner](#input\_team\_owner) | Tsuru app team owner | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_cluster"></a> [app\_cluster](#output\_app\_cluster) | The name of the cluster where the app is deployed |
| <a name="output_app_cnames"></a> [app\_cnames](#output\_app\_cnames) | List of CNAMEs configured for the application |
| <a name="output_app_description"></a> [app\_description](#output\_app\_description) | Application description |
| <a name="output_app_environment_variables"></a> [app\_environment\_variables](#output\_app\_environment\_variables) | Application environment variables (non-sensitive) |
| <a name="output_app_name"></a> [app\_name](#output\_app\_name) | Application name |
| <a name="output_app_platform"></a> [app\_platform](#output\_app\_platform) | Application platform |
| <a name="output_app_pool"></a> [app\_pool](#output\_app\_pool) | Application pool |
| <a name="output_app_processes"></a> [app\_processes](#output\_app\_processes) | Application processes with autoscaling configuration |
| <a name="output_app_routers"></a> [app\_routers](#output\_app\_routers) | List of additional routers configured for the application |
| <a name="output_app_tags"></a> [app\_tags](#output\_app\_tags) | Application tags |
| <a name="output_app_team_owner"></a> [app\_team\_owner](#output\_app\_team\_owner) | Application team owner |
<!-- END_TF_DOCS -->