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


# CI tests the npm path only; pnpm/yarn stages run via scripts/test-local.sh.
target "test" {
  target = "test-webpart"
  output = ["type=cacheonly"]
  platforms = [
    "linux/amd64",
    "linux/arm64/v8"
  ]
}
