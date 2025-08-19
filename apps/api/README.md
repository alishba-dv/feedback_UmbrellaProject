# Feedback Umbrella Project

**TODO: Add description**


Elixir umbrella project with Phoenix APIs and Ecto for feedback collection, storage and management and Swagger UI.
Umbrella Project concept is used for implementation of this project and there are following child apps inside project
Here is the directory structure for reference:::



feedback_umbrella/

├── apps/

│   ├── api/

│   ├── data/

├── config/

└── mix.exs


->API (which holds APIs for backend and controller, and router files etc)
->Data (which holds ecto queries for database to be used by API app in controller also ocntexts which have business logic implemented for dealing with databse and perform data manipulation )
🚀 Features:
📝  Submit a feedback
📊  View all feedbacks with ot without filter &&& Filtering by email and date range && Sorting by first Name of user while fetching feedbacks(ASC/DESC)
🔒  login/Sign up with hashed password for security purposes
🔍  View all users signed up on website

🚀 Future Improvements / TODO

Real-time updates (Phoenix PubSub)

Export reports (CSV/PDF)

Soft delete / archive feedback

Admin dashboard
🛠 Tech Stack:

<img width="20" height="20" alt="image" src="https://github.com/user-attachments/assets/fdbfd28b-b847-4cb6-af8f-6d41cd618abd" />
 Swagger User Interface (UI) implementation for responsive design for frontend/backend developers for easy and efficient testing of basic APIs of user login/signup CRUD fucntionalities

Phoenix for building APIs

Ecto for handling Database with Postgres
```
# 1 Clone the repo
git clone https://github.com/yourusername/feedback_umbrella.git
cd feedback_umbrella

# 2️Fetch dependencies for all apps
mix deps.get

# 3 Setup the database (PostgreSQL)
mix ecto.create        # create DB
mix ecto.migrate       # run migrations
mix run priv/repo/seeds.exs   # optional: seed DB

# 4 Start Phoenix server for API app
cd apps/api
mix phx.server

# The API will run at: http://localhost:4000
# Swagger docs available at: http://localhost:4000/api/docs

# 5️ Example cURL requests
# Fetch all feedbacks
curl -X GET "http://localhost:4000/api/feedbacks" -H "accept: application/json"

# Fetch feedbacks filtered by email
curl -X GET "http://localhost:4000/api/feedbacks?email=tester@gmail.com" -H "accept: application/json"

# Fetch feedbacks by date range
curl -X GET "http://localhost:4000/api/feedbacks?from=2025-08-01&to=2025-08-20" -H "accept: application/json"

# Fetch feedbacks ordered ascending by first name
curl -X GET "http://localhost:4000/api/feedbacks?order=asc" -H "accept: application/json"

# To get all above APIs at one page and use by Swagger UI

http://localhost:4000/api/docs


# This page of Swagger UI will show to user on above URL:


Here is homepage to get an idea about implementation of APIs in swagger 

```

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://hexdocs.pm/phoenix/overview.html
* Docs: https://hexdocs.pm/phoenix
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
# Inquora
