FROM rodfersou/asdf-builder AS asdf-java
RUN asdf plugin-add java                                     \
 && asdf install    java latest:adoptopenjdk-11              \
 && asdf global     java $(asdf latest java adoptopenjdk-11)
#&& asdf plugin-add ant                                      \
#&& asdf install    ant  latest                              \
#&& asdf global     ant  latest                              \
#&& asdf plugin-add gradle                                   \
#&& asdf install    gradle latest                            \
#&& asdf global     gradle latest                            \
#&& asdf plugin-add maven                                    \
#&& asdf install    maven latest                             \
#&& asdf global     maven latest


FROM rodfersou/asdf-base
COPY --from=asdf-java /asdf/plugins/java  /asdf/plugins/java
COPY --from=asdf-java /asdf/installs/java /asdf/installs/java
COPY --from=asdf-java /root/.tool-versions  /root/.tool-versions


CMD ["asdf"]
