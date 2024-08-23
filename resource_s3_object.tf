resource "aws_s3_object" "lic1" {
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = var.licenses[0]
  source   = var.licenses[0]
  etag     = filemd5(var.licenses[0])
}
resource "aws_s3_object" "lic2" {
  bucket   = aws_s3_bucket.s3_bucket.bucket
  key      = var.licenses[1]
  source   = var.licenses[1]
  etag     = filemd5(var.licenses[1])
}
resource "aws_s3_object" "conf1" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "fgtvm.conf"
  content = templatefile("fgtvm.tftpl", {
    type            = "${var.license_type}"
    license_file    = "${var.licenses[0]}"
    format          = "${var.license_format}"
    port1_ip        = "${var.fgtport1ip[0]}"
    port1_mask      = "${cidrnetmask(var.publiccidraz1)}"
    port2_ip        = "${var.fgtport2ip[0]}"
    port2_mask      = "${cidrnetmask(var.privatecidraz1)}"
    port3_ip        = "${var.fgtport3ip[0]}"
    port3_mask      = "${cidrnetmask(var.hasynccidraz1)}"
    adminsport      = "${var.adminsport}"
    passive_peerip  = "${var.fgt2port3ip[0]}"
    mgmt_gateway_ip = cidrhost(var.hasynccidraz1, 1)
    gateway         = cidrhost(var.privatecidraz1, 1)
    defaultgwy      = cidrhost(var.publiccidraz1, 1)
})
}

resource "aws_s3_object" "conf2" {
  bucket = aws_s3_bucket.s3_bucket.bucket
  key    = "fgtvm2.conf"
  content = templatefile("fgtvm2.tftpl", {
    type            = "${var.license_type}"
    license_file    = "${var.licenses[1]}"
    format          = "${var.license_format}"
    adminsport      = "${var.adminsport}"
    port1_ip        = "${var.fgt2port1ip[0]}"
    port1_mask      = "${cidrnetmask(var.publiccidraz2)}"
    port2_ip        = "${var.fgt2port2ip[0]}"
    port2_mask      = "${cidrnetmask(var.privatecidraz2)}"
    port3_ip        = "${var.fgt2port3ip[0]}"
    port3_mask      = "${cidrnetmask(var.hasynccidraz2)}"
    active_peerip   = "${var.fgtport3ip[0]}"
    mgmt_gateway_ip = cidrhost(var.hasynccidraz2, 1)
    gateway         = cidrhost(var.privatecidraz2, 1)
    defaultgwy      = cidrhost(var.publiccidraz2, 1)
  })
}