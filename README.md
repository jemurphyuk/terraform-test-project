# terraform-test-project

This terraform project is attempting to set up a simple two tier architechture (app and database)
in AWS web servers to run an application with public accesc with private access to this database

Current state
- Able to generate 2 instances from packer created AMIs
- Running application, however no access to "posts" webpage
- App currently in a module and would like to store DB in its own module also, not in main.tf
