output "ssh" {
  value = "ssh ${data.google_client_openid_userinfo.me.email}@${google_compute_instance.machine.network_interface.0.access_config.0.nat_ip}"
}
