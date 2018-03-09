FROM shaoguangleo/ubuntu-tempo:latest
MAINTAINER [Guo Shaoguang] <sgguo@shao.ac.cn>

LABEL version="0.1"
LABEL description="Ubuntu PRESTO Image"

COPY src/presto_v2.1.tar.gz /usr/local/
COPY src/presto_v2.1.tar.gz /tmp/

WORKDIR /usr/local/

RUN cd /tmp/\
    && cd /usr/local/ \
    && tar zxvf presto_v2.1.tar.gz \
    && export PRESTO=/usr/local/presto \
    && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRESTO/lib \
    && export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PRESTO/include \
    && echo "export PRESTO=/usr/local/presto" >> ~/.bashrc \
    && echo "export PATH=$PATH:$PRESTO/bin" >> ~/.bashrc \
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRESTO/lib" >> ~/.bashrc \
    && echo "export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PRESTO/include" >> ~/.bashrc \
    && . ~/.bashrc \
    && cd presto/src \
    && make prep \
    && make makewisdom \
    && make \
    && make mpi \
    && make clean \
    && rm -rf /tmp/*tar.gz /usr/local/*.tar.gz
