resource "aws_s3_bucket" "bucket" {
  bucket = var.bucketname

}

# creating an ownership for your bucket, this ensures everything in the bucket is owned by the owner/me
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# this step is to make the bucket public Note if the below is true means its private but if its false is public therefore we are making it public
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# creating an access control list to makee sure thee bucket is ready for the website; in this casee we will use of the public code in the terraform registry site
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.bucket.id
  acl    = "public-read"
}

# we need to create our object so that we can put our website in the S3 with the object resource
resource "aws_s3_object" "index" {     #For the index file
  bucket = aws_s3_bucket.bucket.id  #reference: the bucket we are putting our website
  key    = "index.html" # The name of the file
  source = "index.html" # we create the source to know where the file is 
  acl = "public-read" # create acl control list to make it public
  content_type = "text/html" # Content type 

}

resource "aws_s3_object" "error" {    #For error file 
  bucket = aws_s3_bucket.bucket.id  #reference: the bucket we are putting our website
  key    = "error.html" # The name of the file
  source = "error.html" # we create the source to know where the file is 
  acl = "public-read" # create acl control list to make it public
  content_type = "text/html" # Content type 

}


resource "aws_s3_object" "Monkey_D_Luffy" {    # for the picture
  bucket = aws_s3_bucket.bucket.id  #reference: the bucket we are putting our website
  key    = "Monkey_D_Luffy.png" # The name of the file
  source = "Monkey_D_Luffy.png" # we create the source to know where the file is 
  acl = "public-read" # create acl control list to make it public
  
}

# Code to set up our website
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [aws_s3_bucket_acl.example]

}

