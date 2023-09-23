## Personal blog

This blog is built with the wonderful Rust framework `Zola` and the `Tale-zola`theme.

Feel free to inspire yourself from it!

### Mermaid

If you want to use `mermaid` diagrams, you can by adding this in your markdown:
```md
{% mermaid() %}
 <!-- Mermaid Code -->
{% end %}
```
By default, and to prevent loading a script for nothing, mermaid is __not__ loaded. You
have to set it manually in the file header with:
```toml
[extra]
mermaid = true
```

## TODO

- [ ] Update the deployer system.
- [X] Support `mermaid.js`
- [ ] Support `katex`

