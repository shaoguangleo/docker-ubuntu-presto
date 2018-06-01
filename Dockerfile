FROM shaoguangleo/ubuntu-tempo:latest
MAINTAINER [Guo Shaoguang] <sgguo@shao.ac.cn>

LABEL version="0.1"
LABEL description="Ubuntu PRESTO Image"

COPY src/presto_v2.1.tar.gz /usr/local/
COPY src/ppgplot-1.4.tar.gz /usr/local/

WORKDIR /usr/local/src/

RUN cd /usr/local/ \
    && tar zxvf presto_v2.1.tar.gz \
    && export PRESTO=/usr/local/presto \
    && export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRESTO/lib \
    && export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PRESTO/include \
    && export PYTHONPATH=$PYTHONPATH:$PRESTO/lib/python \
    && echo "export PRESTO=/usr/local/presto" >> ~/.bashrc \
    && echo "export PATH=$PATH:$PRESTO/bin" >> ~/.bashrc \
    && echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PRESTO/lib" >> ~/.bashrc \
    && echo "export C_INCLUDE_PATH=$C_INCLUDE_PATH:$PRESTO/include" >> ~/.bashrc \
    && echo "export PYTHONPATH=$PYTHONPATH:$PRESTO/lib/python" >> ~/.bashrc \
    && . ~/.bashrc \
    && cd presto/src \
    && make prep \
    && make makewisdom \
    && make \
    && make mpi \
    && make clean \
    && cd ../python \
    && python setup.py install --home=${PRESTO} \
    && cd /usr/local/ \
    && tar zxvf ppgplot-1.4.tar.gz \
    && cd ppgplot-1.4 \
    && make ; make install\
    && rm -rvf /usr/local/presto/lib/python/ppgplot \
    && ln -s ppgplot /usr/local/presto/lib/python/ppgplot \
    && cd /usr/local/presto/python \
    && cd fftfit_src ; f2py -c fftfit.pyf *.f \
    && cd ../fftfit_src ; cp fftfit*so ${PRESTO}/lib/python/fftfit.so \
    && rm -rf /usr/local/*.tar.gz
