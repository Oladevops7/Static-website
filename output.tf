output "websiteendpoint" {
    value = aws_s3_bucket.bucket.website_endpoint # create to display url of the image we provisioned
  
}