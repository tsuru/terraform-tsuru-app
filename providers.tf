terraform {
  required_providers {
    tsuru = {
      source  = "tsuru/tsuru"
      version = "~> 2.17.1"
    }

    acl = {
      source  = "tsuru/acl"
      version = "~> 0.2.0"
    }
  }
}
