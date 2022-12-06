# Rebar3 rustler plugin

A basic set of [rebar3](https://www.rebar3.org) templates to aid creating [rustler](https://github.com/rusterlium/rustler)-based Erlang NIFs (Native Implemented Functions), allowing us to call Rust from Erlang.
This plugin uses [rebar3_cargo](https://github.com/rusterlium/rebar3_cargo) to compile Rust crates in the crates directory and copy all binary outputs to `priv/crates/<cratename>/<binary>`.

2 templates are provided:

* `rustler_lib` for generating a complete Rustler-based Erlang NIF library
* `rustler_nif` for generating new Rustler-based NIF in an existing Erlang app

The generated NIF library:
```
├── rebar.config
└── src
    ├── my_nif.app.src
    └── my_nif.erl
├── priv
├── native
│   └── my_nif
│       ├── Cargo.toml
│       └── src
│           └── lib.rs
```

## Usage

Use the plugin by adding the following to `~/.config/rebar3/rebar.config`

    {plugins, [rebar3_rustler]}.


Running `rebar3 new` should now show extra templates available:

	$ rebar3 new
	...
    rustler_lib (plugin): Complete Erlang NIF library written in Rust using rustler
    rustler_nif (plugin): A basic Erlang NIF written in Rust using rustler
	...
### Creating a new Erlang NIF library

	$ rebar3 new rustler_lib my_nif # change my_nif to whatever you want to call your lib
	$ cd my_nif
	$ make

Compiling the app will fetch dependencies for both Erlang and Rust:

	===> Fetching rebar3_cargo v0.1.0
    ===> Fetching cargo v0.1.2
    ===> Fetching jsx v2.11.0
    ...
        Compiling regex v1.7.0
        Compiling rustler_sys v2.2.0
        Compiling rustler_codegen v0.26.0
        Compiling my_nif v0.1.0 (/Users/bruce/git/my_nif/native/my_nif)
        Finished dev [unoptimized + debuginfo] target(s) in 6.08s
    ===>   Copying libmy_nif...
    ===> Analyzing applications...
    ===> Compiling my_nif

To check if we can call Rust from the Erlang shell:

	1> my_nif:add(2, 2).
    4

### Creating a NIF in an existing Erlang app

    $ cd my_app                                         
    $ rebar3 new rustler_nif my_nif app_name=my_app     # change my_app to your existing app name

Then follow the instructions in `native/my_nif/README.md`

### Testing

Running Erlang eunit tests will also evoke `cargo test` in the Rust crate, thanks to the [rebar3_cargo](https://github.com/rusterlium/rebar3_cargo) plugin.

	$ rebar3 eunit    # unit tests

### Options 

Pass options as usual to the [rebar3_cargo](https://github.com/rusterlium/rebar3_cargo) plugin.

    {cargo_opts, [
        {src_dir, "native/my_nif"}
    ]}.

    {provider_hooks, [
        {pre, [
            {compile, {cargo, build}}
        ]},
        {post, [
            {clean, {cargo, clean}},
            {eunit, {cargo, test}}
        ]}
    ]}.

## License

Copyright 2022 Bruce Yinhe

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


# Acknowledgment
This plugin is based on
[rebar3_cargo](https://github.com/rusterlium/rebar3_cargo)