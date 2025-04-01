data "template_file" "service_init" {
  template = file("${path.module}/templates/userdata.sh.tpl")
}
