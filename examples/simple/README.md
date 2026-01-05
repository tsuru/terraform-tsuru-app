# Simple Example

This example demonstrates basic usage of the Tsuru App module with:

- One process with autoscale (`web`)
- One process with fixed units (`worker`)
- Environment variables (public and private)
- CNAME with automatic SSL certificate

## Usage

1. Update the variables in `main.tf` to match your environment
2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Review the plan:

   ```bash
   terraform plan
   ```

4. Apply the configuration:

   ```bash
   terraform apply
   ```

## Key Features

- **Autoscale**: The `web` process automatically scales between 3-20 units based on CPU usage (75%)
- **Fixed Units**: The `worker` process runs with exactly 5 units
- **SSL Certificate**: Automatically provisions Let's Encrypt certificate for `myapp.example.com`

## Notes

- Processes can either use autoscale (by setting `autoscale_*` fields) or fixed units (via `app_units`)
- You cannot mix autoscale and fixed units for the same process
- If no autoscale fields are set for a process, it's eligible for fixed units configuration

## Important: Deploy First

⚠️ **Both autoscale and fixed units require an initial deployment before they can be configured.**

If you try to apply this configuration on a new app without deploying first, you'll encounter errors:

- **Autoscale error**: `We can not set a autoscale without a first deploy`
- **Units error**: `unable to add units: no versions available for app`

**Solution**: Set `deploy = true` and provide an `image` in your configuration for the first apply, or deploy the application manually before configuring autoscale/units.
