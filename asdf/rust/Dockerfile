FROM rodfersou/asdf-builder as asdf-rust
ENV RUST_WITHOUT rust-docs
RUN asdf plugin-add rust https://github.com/asdf-community/asdf-rust.git \
 && asdf install rust latest                                             \
 && asdf global  rust latest


FROM rodfersou/asdf-base
COPY --from=asdf-rust /asdf/plugins/rust    /asdf/plugins/rust
COPY --from=asdf-rust /asdf/installs/rust   /asdf/installs/rust
COPY --from=asdf-rust /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
