# meta-axon

The purpose of this layer is to create a set of examples to guide
[meta-erlang](https://meta-erlang.github.io/) users how to set and use
Erlang and Elixir (or any other BEAM based language) with Yocto Project.

## Building meta-axon

1. Clone the repo from the instance or upload the code and invoke build command. For example:

    ```bash
    git clone https://github.com/joaohf/meta-axon.git
    cd meta-axon
    ```

1. Customize the meta-erlang-graviton2-ami.yaml as needed and invoke build:

    ```bash
    kas build kas/machines/meta-erlang-graviton2-ami.yaml
    ```

1. Or build a ready to use image with Erlang, Elixir and livebook:

    ```bash
    kas build kas/machines/meta-erlang-graviton2-livebook.yaml
    ```

Interim layer maintainer: João Henrique Freitas <joaohf@gmail.com>
