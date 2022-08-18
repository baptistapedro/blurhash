FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev  libjpeg-dev
RUN git clone  https://github.com/woltapp/blurhash.git
WORKDIR /blurhash/C
RUN make blurhash_encoder
RUN mkdir /blurhashCorpus
RUN  cp ../Swift/BlurHashTest/*.png /blurhashCorpus
RUN cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang++ .

ENTRYPOINT ["afl-fuzz", "-i", "/blurhashCorpus", "-o", "/blurhashOut"]
CMD ["/blurhash/C/blurhash_encoder", "4", "3", "@@"]
