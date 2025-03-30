# Prayerloop – PostgreSQL Setup and Database Scripts

Welcome to **Prayerloop**! This repository, **prayerloop-psql**, provides the PostgreSQL database setup and query scripts that support the overall Prayerloop project. In the sections below, you will find details on how this repository fits into Prayerloop’s architecture, how to set up the database, and references to the other repositories in the ecosystem.

---

## Project Overview

The Prayerloop platform consists of three main repositories:

1. **[prayerloop-psql (this repo)](https://github.com/zdelcoco/prayerloop-psql)**  
   Manages database schema creation scripts, initialization SQL, and utility shell scripts for PostgreSQL. All required schema definitions and queries for Prayerloop’s persistent data storage are contained here.

2. **[prayerloop-backend](https://github.com/zdelcoco/prayerloop-backend)**  
   Written in Go (Golang), this API application provides REST endpoints, business logic, and integrations with the PostgreSQL database (via the scripts in prayerloop-psql). It authenticates users, handles prayer requests, and coordinates data access.

3. **[prayerloop-mobile](https://github.com/zdelcoco/prayerloop-mobile)**  
   A React Native mobile app where users interact with Prayerloop on iOS and Android devices. The app communicates with prayerloop-backend’s API.

---

## Repository Contents

This repository includes:

- **`.sql` Scripts**:  
  - Schema creation and migrations.  
  - Tables, relationships, indexes, and constraints for Prayerloop.
- **`.sh` Shell Scripts**:  
  - Automated setup, teardown, or utility scripts to interact with the PostgreSQL instance.  
  - May include environment variable configuration and script-based migrations.

You will not find application code here; instead, you’ll see references and instructions to help set up and maintain the Prayerloop database.

---

## Prerequisites

- **PostgreSQL** (version 12+ recommended)  
  Make sure PostgreSQL is installed and running on your machine or in your environment of choice.
- Basic familiarity with:
  - **SQL** (executing `.sql` files, running queries)
  - **Shell Scripting** (if you plan to use or modify the `.sh` scripts)

---

## Setup Instructions

1. **Clone the repository**:

   ```bash
   git clone https://github.com/zdelcoco/prayerloop-psql.git
   cd prayerloop-psql 
   ```

2. **Configure Database**:  
   - Create a PostgreSQL user and database if you haven’t already. For example:

     ```sql
     CREATE DATABASE prayerloop;
     CREATE USER prayerloop_user WITH ENCRYPTED PASSWORD 'some_password';
     GRANT ALL PRIVILEGES ON DATABASE prayerloop TO prayerloop_user;
     ```

   - Adjust these commands to match your preferred naming or security policies.

3. **Run SQL Scripts**:  
   - Identify the SQL scripts in this repository (e.g., `schema.sql`, `init.sql`, or any migration scripts).  
   - Execute the scripts in the required order. For example:

     ```bash
     psql -U prayerloop_user -d prayerloop -f schema.sql
     psql -U prayerloop_user -d prayerloop -f seed_data.sql
     ```

   - Check the `.sh` files if there is an included script to automate this process. For instance:

     ```bash
     ./setup_database.sh
     ```

     > Make sure to mark scripts as executable if needed.

4. **Integrate with Backend**:  
   - Once your database is ready, configure the **[prayerloop-backend](https://github.com/zdelcoco/prayerloop-backend)** application to point to the newly created database. Typically, this is done via environment variables such as:

     ``` bash
     DB_HOST=localhost
     DB_PORT=5432
     DB_USER=prayerloop_user
     DB_PASSWORD=some_password
     DB_NAME=prayerloop
     ```

   - Refer to the prayerloop-backend documentation for specifics.

---

## Usage

After setup:

- **Start using** the [prayerloop-backend](https://github.com/zdelcoco/prayerloop-backend) Go application. It will run queries and migrations defined in this repository, building out the data required by your environment.
- **Perform maintenance**: Should you need to evolve the schema (create new tables, alter columns, etc.), update or create new `.sql` files and re-run them as needed.
- **Monitor** your PostgreSQL instance (such as logs, performance, etc.) to ensure the Prayerloop service runs smoothly for your user base.

---

## Other Repositories

- [**prayerloop-backend**](https://github.com/zdelcoco/prayerloop-backend)  
  Written in Go, provides the API layer interacting with this PostgreSQL database.

- [**prayerloop-mobile**](https://github.com/zdelcoco/prayerloop-mobile)  
  A React Native mobile app allowing users to log in, view and add prayers, and interact with others.

---

## Contributing

Contributions to prayerloop-psql are welcome! Feel free to open issues or submit pull requests for:

- Updated schema definitions  
- New migrations  
- Additional setup or teardown scripts  
- Performance optimizations  

Please open an issue first to discuss major changes.

---

## License

This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).

---

## Contact

For questions or support:

- Submit an issue in [this repository](https://github.com/zdelcoco/prayerloop-psql/issues).
- Or check out our discussions across the [prayerloop-backend](https://github.com/zdelcoco/prayerloop-backend/issues) and [prayerloop-mobile](https://github.com/zdelcoco/prayerloop-mobile/issues) repos.
