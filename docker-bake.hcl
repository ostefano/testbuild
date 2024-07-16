variable "PLATFORMS" {
  default = [
    # "linux/amd64",
    "linux/arm64",
  ]
}

group "default" {
  targets = [
    "testbuild",
  ]
}

target "testbuild" {
  context = "."
  dockerfile = "Dockerfile"
  tags = ["testbuild:latest"]
  args = {}
  platforms = "${PLATFORMS}"
}
