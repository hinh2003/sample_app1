All source code in the [Ruby on Rails Tutorial](https://www.railstutorial.org/)
is available jointly under the MIT License and the Beerware License. See
[LICENSE.md](LICENSE.md) for details.
## Getting started
To get started with the app, clone the repo and then install the needed gems:
## 🛠️ **Setup Guide**

### **Prerequisites**
Ensure you have the following installed on your machine:
- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

---
### Step 1: Clone the repository
```bash
git clone https://github.com/sample_app1.git
cd sample_app1
```
$ bundle install --without production
### Step 2:Create application.yml
```bash
cp config/application.yml.example config/application.yml
```
Next, migrate the database:
### Step 3:Build and run the containers
```bash
docker-compose build
docker-compose up
```
$ rails db:migrate
### Step 4:Set up the database
```bash
docker-compose exec web rails db:create
docker-compose exec web rails db:migrate
```
Finally, run the test suite to verify that everything is working correctly:
### Step 5: Access the application
```
$ rails test
http://localhost:3000
```
If the test suite passes, you'll be ready to run the app in a local server:
## 📂 Project Structure
```angular2html
├── config/
│   ├── application.yml.example  # Example environment variables file
│   └── database.yml             # SQLite configuration
├── db/
│   ├── migrate/                 # Database migrations
│   └── development.sqlite3      # SQLite database
├── Dockerfile                   # Docker configuration for the Rails app
├── docker-compose.yml           # Docker Compose configuration
├── Gemfile                      # Rails dependencies
└── .dockerignore                # Files excluded from the Docker image
```
$ rails server
## 🐳 Docker Commands Cheat Sheet
### Build the Docker image
```bash
docker-compose build
```
### Start the containers
```bash
docker-compose up
```
### Stop the containers
```bash
docker-compose down
```
### docker-compose exec web rails console
```bash
docker-compose down
```
### Run database migrations
```bash
docker-compose exec web rails db:migrate
```
Run tests
```bash
docker-compose exec web rails test
```
## 🧹 Cleaning Up
### To remove Docker containers, images, and volumes:
```bash
docker-compose down --volumes --remove-orphans
