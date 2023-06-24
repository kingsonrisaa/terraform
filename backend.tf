terraform {
  cloud {
    organization = "it-passion-forever-01"

    workspaces {
      name = "lab-local-execution"
    }
  }
}
