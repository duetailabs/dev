terraform {
  backend "gcs" {
    bucket = "YOUR_PROJECT_ID"
    prefix = "tfstate"
  }
}