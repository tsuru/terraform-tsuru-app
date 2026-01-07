// Copyright 2026 tsuru authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

terraform {
  required_providers {
    tsuru = {
      source  = "tsuru/tsuru"
      version = "~> 2.17.1"
    }
  }
}
