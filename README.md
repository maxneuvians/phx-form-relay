# PhxFormRelay

The purpose of this app is to act as a relay/filter for web form submissions. It uses a honeypot system to trap automatic form fill ins. 

To install and start:

  1. Install dependencies with `mix deps.get`
  2. Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  3. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

### ToDo
- [X] Properly CC and BCC
- [X] Handle file submissions in a form
- [ ] Customize email title

### Version
1.0

License
----
MIT