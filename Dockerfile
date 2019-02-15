FROM ubuntu
ARG trackId
ARG token

#setup
WORKDIR /usr/src/app

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y wget
RUN apt-get install -y build-essential
RUN wget https://raw.githubusercontent.com/QLaille/exercism_mentor_ignore/master/exercism_mentor_ignore.sh && chmod +x exercism_mentor_ignore.sh && mv exercism_mentor_ignore.sh /usr/local/bin/

#exercism setup
RUN wget https://github.com/exercism/cli/releases/download/v3.0.5/exercism-linux-64bit.tgz
RUN tar xzf exercism-linux-64bit.tgz
RUN mv exercism /usr/local/bin/
RUN exercism configure --token=$token -w /usr/src/app
#run
RUN exercism download --uuid=$trackId > exercism_path
RUN cd $(cat exercism_path|grep "/") && exercism_mentor_ignore.sh comment test/*.c && make
#RUN if [ $? = 0 ]; then ; else echo "Build fails";fi