output "ssh_reader" {
  value = "ssh ${data.google_client_openid_userinfo.me.email}@${google_compute_instance.machine-reader.network_interface.0.access_config.0.nat_ip}"
}

output "ssh_writer" {
  value = "ssh ${data.google_client_openid_userinfo.me.email}@${google_compute_instance.machine-writer.network_interface.0.access_config.0.nat_ip}"
}
