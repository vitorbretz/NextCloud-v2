# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "fs-0afe8e31bceaec0cb"
resource "aws_efs_file_system" "nextcloud_efs" {
  availability_zone_name          = null
  creation_token                  = "console-42b89f13-c1e2-4058-ad18-4a223aeeb31f"
  encrypted                       = true
  kms_key_id                      = "arn:aws:kms:us-east-1:906116143348:key/b37d3eb9-664e-45c4-b851-e9960bd74902"
  performance_mode                = "generalPurpose"
  provisioned_throughput_in_mibps = 0
  region                          = "us-east-1"
  tags = {
    Name = "efs-nextcloud-virginia"
  }
  tags_all = {
    Name = "efs-nextcloud-virginia"
  }
  throughput_mode = "bursting"
  protection {
    replication_overwrite = "ENABLED"
  }
}
