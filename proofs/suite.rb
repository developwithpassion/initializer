require_relative 'proofs_init'

Proof::Runner::Suite.run 'initializer/**/*.rb', 'demos/**/*.rb'
