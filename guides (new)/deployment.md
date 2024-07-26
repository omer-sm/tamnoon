# Deployment

This guide will go over the process of deploying Tamnoon apps in various ways.

## HTTPS

To deploy your app, you will most likely need to configure it to run over HTTPS. Fortunately, this is simple. In your supervision tree, add the following options to Tamnoon:

```
  def start(_type, _args) do
    children = [
      {Tamnoon, [[other options..., protocol_opts: [keyfile: PATH TO YOUR KEYFILE, certfile: PATH TO YOUR CERTFILE, otp_app: YOUR OTP APP]]]}
    ]
    ...
  end
```

_Note: the `:otp_app` is required only if you use relative paths for the keyfile / certfile._

Run the app using `mix run --no-halt` as usual, and your app should now be served over HTTPS.

## Using Releases

To deploy your Tamnoon app on a server, you will most likely want to package it into a _release_. A release is a self contained package including everything needed to run your app. For more information see [`Mix.Release`](https://hexdocs.pm/mix/Mix.Tasks.Release.html).

In order to assemble your release, you will need to go into your `mix.exs` file and add the following inside `def project` (replace NAME with your desired name for the release):

```
  def project do
    [
      ...
      releases: [
        NAME: [
          steps: [:assemble, &Tamnoon.make_release/1]
        ]
      ]
    ]
  end
```

Once that is done, run `mix release NAME` with the name you provided in the previous step. Mix will assemble your release, and eventually you should get an output similar to the following:

```console
Release created at _build/dev/rel/NAME

    # To start your system
    _build/dev/rel/NAME/bin/NAME start

Once the release is running:
...
```

Now, once you go to the specified directory and run the `start` command, the server should start as normal. You can now package that directory and transfer it to any machine you would like to!

