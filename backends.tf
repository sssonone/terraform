terraform {
  cloud {
    organization = "reyansh"

    workspaces {
      name = "test_tf_workspace"
    }
  }
}
