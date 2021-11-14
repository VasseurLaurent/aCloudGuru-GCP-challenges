data "google_client_openid_userinfo" "me" {
}

data "google_project" "project" {
}

data "template_file" "script" {
  template = "${file("script.sh.tpl")}"
  vars = {
    project = data.google_project.project.project_id
    region  = local.region
    machine = local.machine_name
    user    = data.google_client_openid_userinfo.me.email
  }
}