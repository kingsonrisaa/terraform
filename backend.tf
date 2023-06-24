terraform {
  cloud {
    organization = "<You name organization>"

    workspaces {
      name = "lab-local-execution"
    }
  }
}
