# oop-core README

This application serves the management API for the Open Interop platform. Individual micro-services consume authentication details, temprs, and device configuration via this application.

The application is tenanted and multiple accounts can be setup and configured on a single instance.

The application will run in isolation and can be configured before setting up the micro-service architecture. However, certain elements will not work. For example, previewing temprs.

The application is API only. If you would like to run the interface see the [interface repository](https://github.com/open-interop/oop-core-interface).

## Installation

The application has been developed against Ruby 2.6.3 and PostgreSQL 10

- Clone the application `git clone git@github.com:open-interop/oop-core.git`
- In the app directory install dependencies `bundle install`
- Ensure your database details are setup in `config/database.yml`
- Create the database `bundle exec rails db:create`
- Run the database migrations `bundle exec rails db:migrate`

In order to communicate with the micro-service back-end we use RabbitMQ. Connection to this and the relevant queues is defined in the environment. In development you can define these in `.env` using the `dotenv-rails` gem.

### Configuration

The application is configured using environment variables.

| Variable                        | Example Value                           | Description                                                                        |
| ------------------------------- | --------------------------------------- | ---------------------------------------------------------------------------------- |
| OOP_CORE_TOKEN                  | `=ELhq4oxCiAHzVmLRqvds6nqgNaAp`         | For the microservices to authenticate with **oop-core**                                    |
| OOP_AMQP_ADDRESS                | `amqp://localhost`                      | The RabbitMQ location                                                                           |
| OOP_CORE_RESPONSE_Q             | `oop.core.transmissions`                | The name of the RabbitMQ transmissions queue for the micro-service layer to report back to core    |
| OOP_CORE_DEVICE_UPDATE_EXCHANGE | `oop.core.devices`                      | The name of the RabbitMQ exchange to update device authentication details in **oop-authenticator** |
| OOP_RENDERER_PATH               | `/Users/jack/Projects/OOO/oop-renderer` | Path to a copy of the renderer in order to handle Tempr previews                                     |

### Testing

The test suite uses rspec, you can run the suite using `bundle exec rspec`.

Coverage reports are output in a readable format here `coverage/index.html`.

## Contributing

We welcome help from the community, please read the [Contributing guide](https://github.com/open-interop/oop-guidelines/blob/master/CONTRIBUTING.md) and [Community guidelines](https://github.com/open-interop/oop-guidelines/blob/master/CODE_OF_CONDUCT.md).

## License

Copyright (C) 2020 The Software for Health Foundation Limited

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
