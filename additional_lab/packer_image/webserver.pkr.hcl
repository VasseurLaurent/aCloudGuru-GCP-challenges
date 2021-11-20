source "googlecompute" "debian" {
  project_id          = "a-simple-project-330101"
  source_image_family = "debian-11"
  ssh_username        = "packer"
  zone                = "asia-south1-a"
  image_name          = "custom-webserver"
  image_description   = "Custom image created with Packer"
  instance_name       = "packer"
  machine_type        = "f1-micro"

}

build {
  sources = ["sources.googlecompute.debian"]

  provisioner "ansible" {
    playbook_file = "./playbook.yml"
  }
}