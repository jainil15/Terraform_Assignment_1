
# Creating key pair for ssh access
resource "aws_key_pair" "mykeypair" {
  key_name   = "${var.env}-mykeypair"
  public_key = file("./mykeypair.pem.pub") # Getting public key from private key
}
