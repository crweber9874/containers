FROM qmcgaw/latexdevcontainer
ARG USERNAME=latex
USER root
RUN tlmgr update --self && \
    tlmgr install latexindent latexmk && \
    tlmgr install mathexam setspace adjustbox xkeyval collectbox enumitem lastpage && \
    texhash
USER ${USERNAME}