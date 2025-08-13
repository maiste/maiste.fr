---
- name: "Dune - OCaml Build System"
  starting_year: 2024
  links:
    - "https://github.com/ocaml/dune"
  summary: |
        Dune is the _Build system_ for OCaml. It is capable of building OCaml
        code to various targets: native code, OCaml Bytecode, JS and WASM. It
        is a really versatile tool. I'm mainly working on the _Package
        Management_ feature. The goal is to be able to use _Dune_ without
        needing _opam_, the OCaml package manager.
- name: "Dune Developer Preview - Dune nightly builds"
  starting_year: 2024
  links:
    - "https://github.com/ocaml-dune/binary-distribution"
  summary: |
        To be able to test the capacity of Dune, we needed a mechanism to build
        nightly version of Dune as standalone executable. This project provides
        a website with standalone executable with the testing features
        available. It is also in charge of building the executables themselves.
- name: "Equinoxe"
  starting_year: 2022
  ending_year: 2024
  links:
    - "https://github.com/maiste/equinoxe"
  summary: |
        _Equinoxe_ was an OCaml library to interact with Equinix API. It was used in
        the context of my work on _Irmin_ to easily deploy test pipelines and get the
        results without having to manually do the setup. While still at Tarides, I
        improved and added more functionalities with the idea of creating a Mirage OS
        deployer on Equinix. However, when I left, I wasn't able to work on it again.
        This library is now deprecated and not used anymore. In the end, it was a
        useful and interesting project to learn to write cleaner APIs.
- name: "OCurrent"
  starting_year: 2022
  ending_year: 2023
  links: 
    - "https://github.com/ocurrent/ocurrent"
  summary: |
        _OCurrent_ is a library that provides blocks to build workflow pipelines
        with automatic caching. I maintained OCurrent in the context of
        _OCaml-CI_, a continuous integration written in OCaml. I improve some
        parts of the `ocurrent-docker` plugin to support the _Docker BuildX
        engine_.
- name: "OCaml-CI"
  starting_year: 2022
  ending_year: 2023
  links:
    - "https://github.com/ocurrent/ocaml-ci"
    - "https://ocaml.ci.dev/"
  summary: |
        _OCaml-CI_ is a continuous integration dedicated to the OCaml ecosystem. It
        provides a zero configuration pipeline using the recommended tools for building
        OCaml (e.g. _Dune_). It was started before the _GitHub Actions_ service was
        released and should have provided an equivalent to _GitLab Pipelines_. Even
        after, it was maintained and improved to provide an in-production test for the
        _OCurrent_ library and, also, give numerous platforms to test your code on. My
        primary focus was to maintain the services and fix the bugs. My second focus
        was to develop and improve the web interface.
- name: "Irmin"
  starting_year: 2021
  ending_year: 2024
  links:
    - "https://github.com/mirage/irmin"
  summary: |
        _Irmin_ is a distributed database that follows the same principles as Git. It
        allows you to expose a Git-like APIs and store the data in whatever backend you
        want (e.g. Git, Redis, disk, etc). I was working at Tarides on _Irmin_ for the
        [Tezos](https://tezos.com/) blockchain. It was used as the storage system for
        their blockchain nodes. I was in charge of taking care of the tests and helping
        to develop the replay functionality, a system that allows a series of block
        applications in the chain. The latter was used in _Tezos _ to debug errors in
        the chain.
- name: "Tezos"
  starting_year: 2021
  ending_year: 2021
  links:
    - "https://gitlab.com/tezos/tezos"
    - "https://codeberg.org/maiste/tezos-oxymeter"
  summary: |
        I did my intership at [Nomadic Labs](https://www.nomadic-labs.com/)
        working on the Tezos Blockchain. I have helped improving the test
        framework for tezos, Tezt (it was an internal project but was later
        extracting as a standalone project) by adding support to SSH to run
        some tests. My internship was about quantifying the energy consumption
        of the blockchain. To do so, I wrote a library named
        [tezos-oxymeter](https://codeberg.org/maiste/tezos-oxymeter) to
        instrument the code and get information about the energy consumption.
- name: "Wireshark"
  starting_year: 2019
  ending_year: 2019
  links:
    - "https://gitlab.com/wireshark/wireshark"
  summary: |
        I have worked with another intern on porting the Babel routing protocol using
        RFC 6126 bis. It was part of an internship supervised by [the
        creator](https://www.irif.fr/~jch/) of the protocol. The goal was to update the
        C code to support additions to the specs. I have done the same in _TCPDump_.
- name: "TCPDump"
  starting_year: 2019
  ending_year: 2019
  links:
    - "https://github.com/the-tcpdump-group/tcpdump"
  summary: |
        I have worked with another intern on porting the Babel routing protocol
        using RFC 6126 bis. It was part of an internship supervised by [the
        creator](https://www.irif.fr/~jch/) of the protocol. The goal was to
        update the C code to support additions to the specs. I have done the
        same in _Wireshark_

---

This part describes the Open Source projects I have been working on during my
professional career or during my personal time. I have been working on other
projects, but, as they are under a non-disclosure agreement, I can't talk
about them. However, as a person loving Open Source, most of my contributions
are available to the public.

Most of my public projects can be found on my [GitHub
Profile](https://github.com/maiste) page or my [Codeberg
Profile](https://codeberg.org/maiste).
