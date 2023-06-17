resource "local_file" "my-pet" {
  filename = "/opt/pet-name"
  content = "My pet is called finnegan!!"
}
