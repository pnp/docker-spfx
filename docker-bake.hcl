target "default" {
  target = "default"
  tags = [
    "docker.io/m365pnp/spfx:latest",
    "docker.io/m365pnp/spfx:online"
  ]
  platforms = [
    "linux/amd64",
    "linux/arm64/v8"
  ]
}


target "test" {
  targets = [
    "test-webpart"
  ]
  output = ["type=cacheonly"]
  platforms = [
    "linux/amd64",
    "linux/arm64/v8"
  ]
}
