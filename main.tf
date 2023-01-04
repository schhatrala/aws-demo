provider "aws" {
  region = "us-west-2"
}


resource "aws_acm_certificate" "awsCertManagerExpiredCertificates" {
  domain_name       = "*.accurics.com"
  validation_method = "EMAIL"

  tags = {
    Environment = "test_shreyas"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acmpca_certificate_authority" "awsCertManager30DayRenewal" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "example.com"
    }
  }

  revocation_configuration {
    crl_configuration {
      custom_cname       = "crl1.com"
      enabled            = true
      expiration_in_days = 29
      s3_bucket_name     = "sample-name-1"
    }
  }
}

resource "aws_acmpca_certificate_authority" "awsCertManager45DayRenewal" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "example.com"
    }
  }

  revocation_configuration {
    crl_configuration {
      custom_cname       = "crl2.com"
      enabled            = true
      expiration_in_days = 44
      s3_bucket_name     = "sample-name-2"
    }
  }
}

resource "aws_acmpca_certificate_authority" "awsCertManager7DayRenewal" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_4096"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name = "example.com"
    }
  }

  revocation_configuration {
    crl_configuration {
      custom_cname       = "crl3.com"
      enabled            = true
      expiration_in_days = 6
      s3_bucket_name     = "sample-name-3"
    }
  }
}
