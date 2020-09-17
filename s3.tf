resource "aws_s3_bucket" "image-bucket" {
  bucket = "webserver-images-test-123"
  acl    = "public-read"

  provisioner "local-exec" {
    command     = "git clone https://github.com/VRajesh001/myimage webserver-image"
    interpreter = ["PowerShell", "-Command"]
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "Remove-Item  webserver-image -Recurse -Force"
    interpreter = ["PowerShell", "-Command"]
  }
}

resource "aws_s3_bucket_object" "image-upload" {
  depends_on = [
    aws_s3_bucket.image-bucket
  ]
  bucket = aws_s3_bucket.image-bucket.bucket
  key    = "myphoto.jpeg"
  source = "webserver-image/MyImage.jpg"
  acl    = "public-read"
}