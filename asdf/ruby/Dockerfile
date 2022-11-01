FROM rodfersou/asdf-builder AS asdf-ruby
COPY default-gems /root/.default-gems
RUN asdf plugin-add ruby     \
 && asdf install ruby latest \
 && asdf global  ruby latest


FROM rodfersou/asdf-base
COPY --from=asdf-ruby /asdf/plugins/ruby  /asdf/plugins/ruby
COPY --from=asdf-ruby /asdf/installs/ruby /asdf/installs/ruby
COPY --from=asdf-ruby /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
